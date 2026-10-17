import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/lesson_02/text_utils.dart';

void main() {
  group("onlyEven", () {
    test("keeps only even numbers", () {
      expect(onlyEven([1, 2, 3, 4, 5, 6]), equals([2, 4, 6]));
    });

    test('returns an empty list when there are no even numbers', () {
      expect(onlyEven([1, 3, 5, 7, 9, 11, 13]), isEmpty);
    });

    test("returns two items when the input has two even numbers", () {
      expect(onlyEven([1, 2, 3, 4, 5, 7]), hasLength(2));
    });
  });
}
