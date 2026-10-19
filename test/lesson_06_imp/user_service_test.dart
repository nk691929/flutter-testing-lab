import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/lesson_06_imp/user_service.dart';

class FakeUserApi implements UserApi {
  @override
  Future<String> getUserName() async => 'Noshad';
}

void main() {
  late UserService userService;
  late FakeUserApi api;
  setUp(() {
    api = FakeUserApi();
    userService = UserService(api);
  });

  group("UserService", () {
    test("greeting says hello to the user", () async {
      final result = await userService.greeting();
      expect(result, 'Hello, Noshad');
    });
  });
}

// what problems would we have if UserService called the real server inside this test?

// A real request is slow, and there are three more, which tie back to Lesson 1:
// Flaky: if the internet is down, the test fails even though your code is fine.
// Non-deterministic: the server’s data can change, so 'Noshad' might be 'Ahmad' tomorrow.
// Can’t test failure on demand: you can’t ask a real server to crash whenever you want.
