abstract class UserRemoteSource {
  Future<String> getUserName();
}

abstract class UserCache {
  Future<void> save(String name);
}

class ProfileRepository {
  final UserRemoteSource _remote;
  final UserCache _cache;
  const ProfileRepository({required this._remote, required this._cache});

  Future<String> getUserName() async {
    final name = await _remote.getUserName();
    await _cache.save(name);
    return name;
  }
}
