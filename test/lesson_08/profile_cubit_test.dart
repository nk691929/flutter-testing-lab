import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/lesson_07/profile_repository.dart';
import 'package:flutter_testing_lab/lesson_08/profile_cubit.dart';
import 'package:flutter_testing_lab/lesson_08/profile_state.dart';
import 'package:mocktail/mocktail.dart';

class MockRepository extends Mock implements ProfileRepository {}

void main() {
  group('ProfileCubit', () {
    late MockRepository repository;
    setUp(() {
      repository = MockRepository();
    });

    test("initial state is ProfileInitial", () {
      expect(ProfileCubit(repository).state, const ProfileInitial());
    });

    blocTest<ProfileCubit, ProfileState>(
      'emits [loading, loaded] when load succeeds',
      setUp: () {
        when(() => repository.getUserName()).thenAnswer((_) async => 'Noshad');
      },
      build: (() => ProfileCubit(repository)),
      act: (cubit) => cubit.load(),
      expect: () => [const ProfileLoading(), const ProfileLoaded('Noshad')],
      verify: (_) {
        verify(() => repository.getUserName()).called(1);
      },
    );

    blocTest<ProfileCubit, ProfileState>(
      'emits Exception when error occures',
      setUp: () {
        when(() => repository.getUserName())
            .thenAnswer((_) async => throw Exception());
      },
      build: () => ProfileCubit(repository),
      act: (cubit) => cubit.load(),
      expect: () => [
        const ProfileLoading(),
        const ProfileError('Could not load profile'),
      ],
      verify: (_) {
        verify(() => repository.getUserName()).called(1);
      },
    );
  });
}
