class UserRepository {
  Future<String> fetchUserName() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return 'Noshad';
  }

  Future<String> fetchFailingUserName() async {
    Future.delayed(const Duration(milliseconds: 100));
    throw Exception('Network error');
  }
}
