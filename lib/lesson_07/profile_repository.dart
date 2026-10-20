abstract class UserRemoteSource {
  Future<String> getUserName();
}

abstract class UserCache {
  Future<void> save(String name);
  Future<String?> read();
}

class ProfileRepository {
  final UserRemoteSource _remote;
  final UserCache _cache;
  const ProfileRepository({required this._remote, required this._cache});

  Future<String> getUserName() async {
    final String name;
    try {
      name = await _remote.getUserName();
    } on Exception {
      final cached = await _cache.read();
      if (cached == null) rethrow;
      return cached;
    }
    await _cache.save(name);
    return name;
  }
}
