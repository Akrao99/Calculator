#import "Calculator.h"

@implementation Calculator





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
