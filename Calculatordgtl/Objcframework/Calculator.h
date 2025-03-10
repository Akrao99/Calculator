#ifndef Calculator_h
#define Calculator_h

#import <Foundation/Foundation.h>
#import <math.h>

NS_ASSUME_NONNULL_BEGIN

@interface Calculator : NSObject



//Expression evaluation
+ (double)evaluateExpression:(NSString *)expression;

@end

// Global function prototypes
double calculateSin(double angle);
double calculateCos(double angle);
double calculateTan(double angle);

NS_ASSUME_NONNULL_END

#endif /* Calculator_h */
