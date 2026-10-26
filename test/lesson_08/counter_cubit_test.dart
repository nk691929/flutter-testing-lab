import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/lesson_08/counter_cubit.dart';

void main() {
  group('counterCubit', () {
    test(("initial state is zero"), () {
      expect(CounterCubit().state, 0);
    });

    blocTest<CounterCubit, int>(
      'emits [1] when increment is called',
      build: () => CounterCubit(),
      act: (cubit) => cubit.increment(),
      expect: () => [1],
    );

    blocTest<CounterCubit, int>(
      "emit [-1] whn decrement calles",
      build: () => CounterCubit(),
      act: (cubit) => cubit.decrement(),
      expect: () => [-1],
    );
  });

  blocTest<CounterCubit, int>(
    'emits [1,2] when twice increment is called',
    build: () => CounterCubit(),
    act: (cubit) {
      cubit.increment();
      cubit.increment();
    },
    expect: () => [1, 2],
  );
}
