import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/lesson_07/profile_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRemoteSource extends Mock implements UserRemoteSource {}

class MockUserCache extends Mock implements UserCache {}

void main() {
  group("ProfileRepository.getUserName", () {
    late MockUserRemoteSource remote;
    late MockUserCache cache;
    late ProfileRepository repository;
    setUp(() {
      remote = MockUserRemoteSource();
      cache = MockUserCache();
      repository = ProfileRepository(remote: remote, cache: cache);
    });

    test("returns the remote name and saves it to the cache", () async {
      when(() => remote.getUserName()).thenAnswer((_) async => 'Noshad');
      when(() => cache.save("Noshad")).thenAnswer((_) async {});

      final result = await repository.getUserName();

      expect(result, 'Noshad');
      verify(() => cache.save('Noshad')).called(1);
    });
  });
}
