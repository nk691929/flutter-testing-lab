import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/lesson_01/calculator.dart';

void main() {
  test('Add return the sum of two numbers', () {
    //Arrange
    const a = 2;
    const b = 3;

    //Act
    final result = add(a, b);

    //Assert
    expect(result, 5);
  });

  test('Subtract return the subtraction number', () {
    //Arracnge
    const a = 9;
    const b = 5;

    //Act
    final result = subtract(a, b);

    //Assert
    expect(result, 4);
  });

  test("Multiply return the multiplied number", () {
    //Arracnge
    const a = 4;
    const b = 2;

    //Act
    final result = multiply(a, b);

    //Assert
    expect(result, 8);
  });

  test("Division, return the divided number", () {
    //Arracnge
    const a = 4;
    const b = 2;

    //Act
    final result = division(a, b);

    //Assert
    expect(result, 2);
  });
}
