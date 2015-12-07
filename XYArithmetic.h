//
//  XYCalculator.h
//  XY
//
//  Created by Julian on 12-9-23.
//  Copyright (c) 2012年 Julian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYArithmetic : NSObject
+(float)calculateExpression:(NSMutableArray *)expression withX:(float) x error:(NSError **)error;
+(NSMutableArray *)shuntingYard:(NSMutableArray *) input error:(NSError **)error;
+(float)calculate:(NSString *)exp operand:(float *)operand;
@end
