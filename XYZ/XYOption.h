//
//  XYOption.h
//  XY
//
//  Created by Julian on 12-9-23.
//  Copyright (c) 2012年 Julian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Operator.h"
#import "MathFunction.h"
@interface XYOption : NSObject
@property (strong,atomic) NSMutableArray *expression;
@property (strong,atomic) NSDictionary *operatores;
+(Boolean ) isFunction:(NSString *) exp;
+(Boolean ) isOperator:(NSString *) exp;
+(Boolean ) isNumber:(NSString *) exp;
+(Boolean ) isLeftAssoc:(NSString *)exp;
+(int) precedence:(NSString *)exp;
+(int) operandSeveral:(NSString *)exp;
+(Boolean ) isComma:(NSString *)exp;
+(Boolean ) isLeftParenthesis:(NSString *) exp;
+(Boolean ) isRightParenthesis:(NSString *) exp;
+(Boolean ) isAlgebra:(NSString *) exp;
+(Boolean ) isConstant:(NSString *) exp;
+(NSString *)cFunction:(NSString *)exp;
@end
