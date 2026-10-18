import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/lesson_05/user_repository.dart';

void main() {
  group('UserRepository', () {
    late UserRepository repository;

    setUp(() {
      repository = UserRepository();
    });

    test("fetchUserName returns the user name", () async {
      final name = await repository.fetchUserName();
      expect(name, 'Noshad');
    });
  });
}
