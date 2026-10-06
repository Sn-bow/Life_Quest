import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../state/character_state.dart';

typedef ProfilePhotoUploader = Future<String> Function(String uid, File photo);

/// A retry resumes setup of the identity this instance actually created.
/// Credentials live in the form only and are never stored here or on disk.
class CloudProfileRegistration {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final ProfilePhotoUploader _uploadPhoto;
  User? _createdUser;
  bool _busy = false;

  CloudProfileRegistration({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    ProfilePhotoUploader? uploadPhoto,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _uploadPhoto = uploadPhoto ?? _uploadProfilePhoto;

  bool get hasCreatedAccount => _createdUser != null;

  static Future<String> _uploadProfilePhoto(String uid, File photo) async {
    final ref = FirebaseStorage.instance.ref('users/$uid/profile.jpg');
    await ref.putFile(photo);
    return ref.getDownloadURL();
  }

  void _requireSameIdentity(User user) {
    if (_auth.currentUser?.uid != user.uid) {
      throw StateError('Account changed during profile setup.');
    }
  }

  Future<void> finish({
    required String email,
    required String password,
    required String name,
    required String languageCode,
    File? photo,
  }) async {
    if (_busy) throw StateError('Profile setup is already in progress.');
    _busy = true;
    try {
      final normalizedEmail = email.trim();
      if (_createdUser == null) {
        if (_auth.currentUser != null && !_auth.currentUser!.isAnonymous) {
          throw StateError('Sign out before creating a different account.');
        }
        final credential = await _auth.createUserWithEmailAndPassword(
          email: normalizedEmail,
          // Passwords must exactly match the confirmed form value.
          password: password,
        );
        _createdUser = credential.user;
        if (_createdUser == null) {
          throw StateError('Account creation did not return a user.');
        }
      } else if (_createdUser!.email?.toLowerCase() !=
          normalizedEmail.toLowerCase()) {
        throw StateError('Finish setup of the account already created.');
      }

      final user = _createdUser!;
      _requireSameIdentity(user);
      final chosenName = name.trim();
      if (chosenName.isEmpty) throw StateError('A name is required.');
      await user.updateDisplayName(chosenName);
      _requireSameIdentity(user);

      if (photo != null) {
        final url = await _uploadPhoto(user.uid, photo);
        _requireSameIdentity(user);
        await user.updatePhotoURL(url);
        _requireSameIdentity(user);
      }
      await user.reload();
      _requireSameIdentity(user);
      final currentUser = _auth.currentUser!;
      final initial = CharacterState.newCloudProfilePayload(
        currentUser,
        languageCode: languageCode,
      );
      final ref = _firestore.collection('users').doc(user.uid);
      await _firestore.runTransaction((transaction) async {
        final existing = await transaction.get(ref);
        _requireSameIdentity(user);
        if (!existing.exists) {
          transaction.set(ref, initial);
        } else {
          // Another first-login task may already have saved progress. Patch
          // only the identity fields chosen in this signup, never XP or tools.
          if (existing.data()?['accountKind'] == 'purchaseOnly') {
            throw StateError('A purchase identity is not a cloud profile.');
          }
          transaction.update(ref, {
            'character.name': chosenName,
            'character.usesDefaultGuestName': false,
            if (currentUser.photoURL != null)
              'character.photoUrl': currentUser.photoURL,
          });
        }
      });
      _requireSameIdentity(user);
    } finally {
      _busy = false;
    }
  }

  /// Leaving an interrupted signup signs out only its own new identity.
  /// It never deletes an account or signs out a different user's session.
  Future<void> leaveSetup() async {
    if (_busy) throw StateError('Wait for profile setup to finish.');
    final uid = _createdUser?.uid;
    if (uid != null && _auth.currentUser?.uid == uid) {
      await _auth.signOut();
    }
  }
}
