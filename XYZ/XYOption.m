//
//  XYOption.m
//  XY
//
//  Created by Julian on 12-9-23.
//  Copyright (c) 2012年 Julian. All rights reserved.
//

#import "XYOption.h"
#import "AppDelegate.h"    
@implementation XYOption
@synthesize operatores=_operatores;
@synthesize expression=_expression;

-(id) init{
    self = [super init];
    if (self) {
        
    }
    return self;
}



//是否为函数
+(Boolean)isFunction:(NSString *)exp
{
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication ] delegate];
    return [appDelegate.mathFunctionList objectForKey:exp ]!=nil;
}

//是否为操作符
+(Boolean) isOperator:(NSString *)exp
{
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication ] delegate];
    return [appDelegate.operatorList objectForKey:exp ]!=nil;
}

//获得操作符的结合性
+(Boolean) isLeftAssoc:(NSString *)exp
{
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication ] delegate];
    Operator *op= (Operator *)[appDelegate.operatorList objectForKey:exp];
    return [op.leftAssoc boolValue];
}

//运算符优先级
+(int) precedence: exp
{
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication ] delegate];
    Operator *op= (Operator *)[appDelegate.operatorList objectForKey:exp];
    return [op.precedence intValue];
}

//运算符操作数个数
+(int) operandSeveral:(NSString *)exp{
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication ] delegate];
    Operator *op= (Operator *)[appDelegate.operatorList objectForKey:exp];
    if(op!=nil){
        return [op.operandSeveral intValue];
    }else{
        MathFunction *mf=(MathFunction *)[appDelegate.mathFunctionList objectForKey:exp];
        if(mf!=nil){
            return [mf.operandSeveral intValue];
        }else{
            return 0;
        }
    }
}


//是否为数字
+(Boolean) isNumber:(NSString *)exp{
    NSScanner * scan = [NSScanner scannerWithString:exp];
    int val;
    float fval;
    return ([scan scanInt:&val] && [scan isAtEnd])||([scan scanFloat:&fval] && [scan isAtEnd]);
    
}

//是否为逗号
+(Boolean ) isComma:(NSString *) exp{
    if([exp isEqualToString:@"," ]){
        return YES;
    }else{
        return NO;
    }
}
//是否为左括号
+(Boolean ) isLeftParenthesis:(NSString *) exp{
    return [exp isEqualToString:@"(" ];
}
//是否为右括号
+(Boolean ) isRightParenthesis:(NSString *) exp
{
    return [exp isEqualToString:@")" ];
}
//如果是代入数x
+(Boolean ) isAlgebra:(NSString *) exp{
    return [exp isEqualToString:@"x"];
}
+(Boolean) isConstant:(NSString *)exp{
    return [exp isEqualToString:@"π"]||[exp isEqualToString:@"E"];
}

+(NSString *) cFunction:(NSString *)exp{
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication ] delegate];
    MathFunction *mf=(MathFunction *)[appDelegate.mathFunctionList objectForKey:exp];
    return mf.cfuncion;
}
@end
