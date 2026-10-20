import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/lesson_06_imp/user_service.dart';
import 'package:mocktail/mocktail.dart';

class MockUserApi extends Mock implements UserApi {}

void main() {
  group('UserService with mocktail', () {
    late MockUserApi api;
    late UserService service;

    setUp(() {
      api = MockUserApi();
      service = UserService(api);
    });

    test("greeting hello to user", () async {
      //Arrange
      when(() => api.getUserName()).thenAnswer((_) async => 'Noshad');

      //Act
      final result = await service.greeting();

      //Assert
      expect(result, 'Hello, Noshad');
      verify(() => api.getUserName()).called(1);
    });

    test("greeting throws when the API fails", () async {
      when(() => api.getUserName())
          .thenAnswer((_) => throw Exception('Server down'));

      await expectLater(service.greeting(), throwsException);
    });
  });
}
