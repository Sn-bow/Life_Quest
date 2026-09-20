/// Serializes cloud snapshots and keeps each caller attached to its own write.
/// A failed write cannot poison later writes, and a queued old identity never
/// borrows the authentication of the next profile.
class ProfileWriteQueue {
  Future<void> _tail = Future.value();

  Future<void> enqueue({
    required bool Function() isCurrent,
    required Future<void> Function() commit,
  }) {
    final write = _tail.then((_) async {
      if (!isCurrent()) {
        throw StateError('Profile session changed before save.');
      }
      await commit();
      if (!isCurrent()) {
        throw StateError('Profile session changed during save.');
      }
    });
    // Observe the internal tail immediately, but return the original Future so
    // the caller still receives the actual commit failure.
    _tail = write.catchError((Object _) {});
    return write;
  }
}
