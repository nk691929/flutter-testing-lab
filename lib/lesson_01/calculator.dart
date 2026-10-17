int add(int a, int b) => a + b;

int subtract(int a, int b) => a - b;

int multiply(int a, int b) => a * b;

double division(int a, int b) {
  if (b == 0) throw ArgumentError("Cannot divide by 0");
  return a / b;
}
