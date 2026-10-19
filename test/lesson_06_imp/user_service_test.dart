import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/lesson_06_imp/user_service.dart';

class FakeUserApi implements UserApi {
  @override
  Future<String> getUserName() async => 'Noshad';
}

class FailingUserApi implements UserApi {
  @override
  Future<String> getUserName() async => throw Exception('Server down');
}

void main() {
  late UserService userService;
  late UserService failedUserService;
  late FakeUserApi api;
  late FailingUserApi failedApi;
  setUp(() {
    api = FakeUserApi();
    failedApi = FailingUserApi();
    userService = UserService(api);
    failedUserService = UserService(failedApi);
  });

  group("UserService", () {
    test("greeting says hello to the user", () async {
      final result = await userService.greeting();
      expect(result, 'Hello, Noshad');
    });
  });

  test('greeting throws when the API fails', () async {
    await expectLater(failedUserService.greeting(), throwsException);
  });
}
