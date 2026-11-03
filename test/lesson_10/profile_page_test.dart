import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/lesson_08/profile_cubit.dart';
import 'package:flutter_testing_lab/lesson_08/profile_state.dart';
import 'package:flutter_testing_lab/lesson_10/profile_page.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

void main() {
  group('ProfilePage', () {
    late MockProfileCubit profileCubit;
    setUp(() {
      profileCubit = MockProfileCubit();
    });

    Future<void> pumpPage(WidgetTester tester) async {
      return tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProfileCubit>.value(
            value: profileCubit,
            child: const ProfilePage(),
          ),
        ),
      );
    }

    testWidgets('shows a spinner while loading', (tester) async {
      when(() => profileCubit.state).thenReturn(const ProfileLoading());

      await pumpPage(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows the name when loaded', (tester) async {
      when(() => profileCubit.state).thenReturn(ProfileLoaded('Noshad'));

      await pumpPage(tester);

      expect(find.text('Hello, Noshad'), findsOneWidget);
    });

    testWidgets('show the error when error', (tester) async {
      when(() => profileCubit.state)
          .thenReturn(const ProfileError('Could not load profile'));

      await pumpPage(tester);

      expect(find.text('Could not load profile'), findsOneWidget);
    });

    testWidgets('tapping Retry calls load on the cubit', (tester) async {
      when(() => profileCubit.state)
          .thenReturn(const ProfileError('Could not load profile'));
      when(() => profileCubit.load()).thenAnswer((_) async {});

      await pumpPage(tester);
      await tester.tap(find.text('Retry'));
      await tester.pump();

      verify(() => profileCubit.load()).called(1);
    });
  });
}
