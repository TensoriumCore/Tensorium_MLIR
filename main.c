#include <stdio.h>

double add(double, double);
double sub(double, double);

int main() {
    double a = 10.5, b = 20.3;
    printf("Result: %f\n", add(a, b));

	printf("Result: %f\n", sub(a, b));
    return 0;
}
