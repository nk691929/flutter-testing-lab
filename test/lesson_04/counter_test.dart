import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/lesson_04/counter.dart';

void main() {
  group("counter", () {
    late Counter counter;

    setUp(() => counter = Counter());

    test("starts at zero", () {
      expect(counter.count, 0);
    });

    test('increment add one', () {
      counter.increment();
      expect(counter.count, 1);
    });

    test('decrement substract one', () {
      counter.decrement();
      expect(counter.count, -1);
    });

    test('reset sets the count back to zero', () {
      counter.increment();
      counter.increment();
      expect(counter.count, 2);
      counter.reset();
      expect(counter.count, 0);
    });
  });
}
