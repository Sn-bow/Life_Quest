import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'purchase_account_state.dart';

class FirebasePurchaseAccountGateway implements PurchaseAccountGateway {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _google = GoogleSignIn();
  PurchaseIdentity? _identity(User? user) =>
      user != null &&
          !user.isAnonymous &&
          user.providerData.any((p) => p.providerId == 'google.com')
      ? PurchaseIdentity(user.uid, email: user.email)
      : null;
  @override
  PurchaseIdentity? get current => _identity(_auth.currentUser);
  @override
  Stream<PurchaseIdentity?> get changes =>
      _auth.authStateChanges().map(_identity);

  Future<AuthCredential?> _credential() async {
    final selected = await _google.signIn();
    if (selected == null) return null;
    final tokens = await selected.authentication;
    return GoogleAuthProvider.credential(
      accessToken: tokens.accessToken,
      idToken: tokens.idToken,
    );
  }

  @override
  Future<PurchaseIdentity?> signIn() async {
    // Display the account chooser; silently reusing the last Google account can
    // bind a Play purchase to an unintended app identity.
    await _google.signOut();
    final credential = await _credential();
    if (credential == null) return null;
    return _identity((await _auth.signInWithCredential(credential)).user);
  }

  @override
  Future<bool> ensureAccount() async {
    final response = await FirebaseFunctions.instance
        .httpsCallable(
          'ensurePurchaseAccount',
          options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
        )
        .call();
    return response.data is Map && response.data['ready'] == true;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    await _google.signOut();
  }

  @override
  Future<bool> requestDeletion() async {
    final user = _auth.currentUser;
    if (_identity(user) == null) return false;
    await _google.signOut();
    final credential = await _credential();
    if (credential == null) return false;
    await user!.reauthenticateWithCredential(credential);
    if (_auth.currentUser?.uid != user.uid) return false;
    await user.getIdToken(true);
    final response = await FirebaseFunctions.instance
        .httpsCallable(
          'requestAccountDeletion',
          options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
        )
        .call();
    return response.data is Map && response.data['accepted'] == true;
  }
}
