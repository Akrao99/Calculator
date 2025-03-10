#import "Calculator.h"

@implementation Calculator

//Basic Arithmetic Operations

- (double)add:(double)num1 withNumber:(double)num2 {
    return num1 + num2;
}

- (double)subtract:(double)num1 withNumber:(double)num2 {
    return num1 - num2;
}

- (double)multiply:(double)num1 withNumber:(double)num2 {
    return num1 * num2;
}

- (double)divide:(double)num1 withNumber:(double)num2 {
    if (num2 == 0) return NAN;
    return num1 / num2;
}


//Expression Evaluation

+ (double)evaluateExpression:(NSString *)expression {
    // Replace custom operator symbols with standard operators.
    NSString *standardExpression = [expression stringByReplacingOccurrencesOfString:@"×" withString:@"*"];
    standardExpression = [standardExpression stringByReplacingOccurrencesOfString:@"÷" withString:@"/"];
    standardExpression = [standardExpression stringByReplacingOccurrencesOfString:@"−" withString:@"-"];
    
    // Create an NSExpression from the processed string.
    NSExpression *exp = [NSExpression expressionWithFormat:standardExpression];
    NSNumber *result = [exp expressionValueWithObject:nil context:nil];
    return [result doubleValue];
}

@end

//Global Functions

double calculateSin(double angle) {
    return sin(angle * M_PI / 180); // Converts degrees to radians
}

double calculateCos(double angle) {
    return cos(angle * M_PI / 180); // Converts degrees to radians
}

double calculateTan(double angle) {
    return tan(angle * M_PI / 180); // Converts degrees to radians
}
