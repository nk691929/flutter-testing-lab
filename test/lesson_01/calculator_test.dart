import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/lesson_01/calculator.dart';

void main() {
  test('add returns the sum of two numbers', () {
    //Arrange
    const a = 2;
    const b = 3;

    //Act
    final result = add(a, b);

    //Assert
    expect(result, 5);
  });

  test('subtract returns the subtract of two numbers', () {
    //Arracnge
    const a = 9;
    const b = 5;

    //Act
    final result = subtract(a, b);

    //Assert
    expect(result, 4);
  });

  test("multiply returns the multiply of two numbers", () {
    //Arracnge
    const a = 4;
    const b = 2;

    //Act
    final result = multiply(a, b);

    //Assert
    expect(result, 8);
  });

  test("division returns the division of two numbers", () {
    //Arracnge
    const a = 12;
    const b = 3;

    //Act
    final result = division(a, b);

    //Assert
    expect(result, 4);
  });

  test("division throw an argument error when divide by 0", () {
    expect(() => division(2, 0), throwsArgumentError);
  });
}
