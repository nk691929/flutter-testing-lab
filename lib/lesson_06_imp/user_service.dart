abstract class UserApi {
  Future<String> getUserName();
}

class UserService {
  final UserApi _api;
  UserService(this._api);

  Future<String> greeting() async {
    final name = await _api.getUserName();
    return 'Hello, $name';
  }
}
