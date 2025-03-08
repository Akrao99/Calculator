#ifndef Calculator_h
#define Calculator_h

#import <Foundation/Foundation.h>
#import <math.h>

NS_ASSUME_NONNULL_BEGIN

@interface Calculator : NSObject

// Basic arithmetic operations (not shown for brevity)
- (double)add:(double)num1 withNumber:(double)num2;
- (double)subtract:(double)num1 withNumber:(double)num2;
- (double)multiply:(double)num1 withNumber:(double)num2;
- (double)divide:(double)num1 withNumber:(double)num2;

// Trigonometric functions (input in degrees; methods convert to radians)
- (double)sin:(double)angle;
- (double)cos:(double)angle;
- (double)tan:(double)angle;

// Expression evaluation (if needed)
+ (double)evaluateExpression:(NSString *)expression;

@end

// Global function prototypes (input in degrees)
double calculateSin(double angle);
double calculateCos(double angle);
double calculateTan(double angle);

NS_ASSUME_NONNULL_END

#endif /* Calculator_h */
