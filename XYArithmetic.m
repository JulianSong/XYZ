//
//  XYCalculator.m
//  XY
//
//  Created by Julian on 12-9-23.
//  Copyright (c) 2012年 Julian. All rights reserved.
//

#import "XYOption.h"
#import "XYArithmetic.h"
#import "XYMathFunction.h"
#import "XYError.h"
@implementation XYArithmetic
//利用调度杨算法把表达式转为中缀表达
+(NSMutableArray *)shuntingYard:(NSMutableArray *)input error:(NSError **)error
{
    NSMutableArray *output= [[NSMutableArray alloc ]init];
    NSMutableArray *stack= [[NSMutableArray alloc ]init];
    NSString *first=[input objectAtIndex:0];
    if ([first isEqualToString:@"-"]||[first isEqualToString:@"+"]) {
        [input insertObject:@"0" atIndex:0];
    }
    NSLog(@"%@",input);
    while(input.count)
    {   
        NSString *exp = (NSString *)[input objectAtIndex:0];    
        [input removeObjectAtIndex:0];
        
        if([exp isEqualToString:@""]){
            continue;
        }else{
            NSString * opt = [stack lastObject];
            if ([XYOption isFunction:opt]&& ![XYOption isLeftParenthesis:exp]) {
                *error=[[NSError alloc] initWithDomain:@"XY" code:-1 userInfo:[XYError errorUserInfoWithDescription:[NSString stringWithFormat:@"函数\"%@\",需要用（）号表示参数",opt] recoverySuggestion:@"请补全括号"]];
            }
            
        }
        
        NSLog(@"输入操作符%@",exp);
        if([XYOption isNumber:exp]||[XYOption isAlgebra:exp])
       {
            NSLog(@"如果是数字直接输出%@",exp);
            [output addObject: exp];
        }
        
        
        else if([XYOption isAlgebra:exp]){
            [output addObject:exp];
        }
        else if([XYOption isConstant:exp]){
            [output addObject:exp];
        }
        else if([XYOption isFunction:exp])
        {
            NSLog(@"如果是函数则入栈%@",exp);
            [stack addObject:exp];
        }
        
        else if([XYOption isOperator:exp])
        {
            NSLog(@"如果是操作符则与栈顶元素比较");
            while (stack.count)
            {
                NSString * opt = [stack lastObject];

                NSLog(@"依次输出栈顶元素%@与当前输入元素%@比较",opt,exp);
                
                if( [XYOption isOperator:opt] &&
                   
                    (([XYOption isLeftAssoc:opt] && ([XYOption precedence:exp] <= [XYOption precedence:opt]))||
                        
                     (![XYOption isLeftAssoc:opt] && ([XYOption precedence:exp] <= [XYOption precedence:opt])))
                   
                   )
                {
                    NSLog(@"如果栈顶元素为操作符且有左结合性，且优先级小于当前输入的操作符，则输出栈顶元素%@",opt);
                    [output addObject:opt];
                    [stack removeLastObject];
                }
                else
                {
                    break;
                }
            }
            
            NSLog(@"如果栈顶元素为操作符且不符合条件（左结合性，且优先级小于当前输入的操作符）则操作符入栈‘%@’",exp);
            [stack addObject:exp];
            
        }
        
        else if([XYOption isLeftParenthesis:exp])
        {
            NSLog(@"如果是左括号则直接入栈");
            [stack addObject:exp];
        }
        
        else if([XYOption isRightParenthesis:exp])
        {
            NSLog(@"如果是右括号则输出栈顶元素直到遇到左括号");
            Boolean pe=NO;
            
            while(stack.count)
            {
                NSString *opt = [stack lastObject];
                [stack removeLastObject];
                 NSLog(@"输出%@",opt);
                if([XYOption isLeftParenthesis:opt])
                {
                    pe=YES;
                    break;
                }
                else
                {
                    [output addObject:opt];
                }
            }
            if(!pe){
                NSLog(@"112没有匹配的右括号");
                *error=[[NSError alloc] initWithDomain:@"XY" code:-1 userInfo:[XYError errorUserInfoWithDescription:@"没有匹配的右括号" recoverySuggestion:@"请补全右括号"]];
               return nil;
            }
            if(stack.count>0){
                NSString *opt = [stack lastObject];
                [stack removeLastObject];
                if([XYOption isFunction:opt]){
                    [output addObject:opt];
                }
            }
        }
        else
        {
            return nil;
        }

    }
    
    NSLog(@"stack %@",stack);
    while(stack.count)
    {
        NSString *opt = [stack lastObject];
        [stack removeLastObject];
        NSLog(@"最后依次输出栈顶元素%@",opt);
        if([XYOption isLeftParenthesis:opt]||[XYOption isRightParenthesis:opt])
        {
            
            NSLog(@"140 没有匹配的括号");
            *error=[[NSError alloc] initWithDomain:@"XY" code:-1 userInfo:[XYError errorUserInfoWithDescription:@"没有匹配的右括号" recoverySuggestion:@"请补全右括号"]];
            return nil;
            
        }

        [output addObject:opt];
        
    }
    
    NSLog(@"算法结果%@",output );
    if (!output.count) {
        *error=[[NSError alloc] initWithDomain:@"XY" code:-1 userInfo:[XYError errorUserInfoWithDescription:@"输入的表达式无效" recoverySuggestion:@"请修改表达式"]];
    }
    return output;
}

//代入x的值计算表达式的值
+(float)calculateExpression:(NSMutableArray *)expression withX:(float) x error:(NSError **)error{
    NSMutableArray *stack= [[NSMutableArray alloc ]init];
    int count = expression.count;
    for (int i=0; i<count; i++) {
        //NSLog(@"expression count %d",expression.count);
        NSString *exp = (NSString *)[expression objectAtIndex:i];
        if ([XYOption isAlgebra:exp]) {
            
            [stack addObject:[[NSNumber alloc]initWithFloat:x]];
        }
        if ([exp isEqualToString:@"π"]) {
            [stack addObject:[[NSNumber alloc]initWithFloat:M_PI]];
        }
        if ([exp isEqualToString:@"E"]) {
             [stack addObject:[[NSNumber alloc]initWithFloat:M_E]];
        }
        if([XYOption isNumber:exp])
        {
           // NSLog(@"如果是数字直接入栈%@",exp);
            NSScanner * scan = [NSScanner scannerWithString:exp];
            float fval;
            [scan scanFloat:&fval];
            [stack addObject:[[NSNumber alloc]initWithFloat:fval]];
        }
        
        if([XYOption isOperator:exp]||[XYOption isFunction:exp]){
           // NSLog(@"是操作符%@",exp);
            int operandSeveral=[XYOption operandSeveral:exp];
          //  NSLog(@"操作符所需操作数%d,栈元素总数%d",operandSeveral,stack.count);
            if(operandSeveral <= stack.count){
               // NSLog(@"如果是操作符所需操作数%d小于等于栈元素总数%d",operandSeveral,stack.count);
                float operand[operandSeveral];
                while (operandSeveral>0) {
                    operand[operandSeveral-1]=[(NSNumber*)[stack lastObject]floatValue];
                    [stack removeLastObject];
                    operandSeveral--;
                }
                [stack addObject:[[NSNumber alloc]initWithFloat:[self calculate:exp operand:operand]]];
            }else{
                *error=[[NSError alloc] initWithDomain:@"XY" code:-1 userInfo:[XYError errorUserInfoWithDescription:[NSString stringWithFormat:@"\"%@\",需要%d个操作数",exp,operandSeveral] recoverySuggestion:@"请补全操作数"]];
                return 0;
            }
        }
    }
    if(stack.count==1){
        return [(NSNumber *)[stack lastObject] floatValue];
    }else{
        return 0;
    }

}


+(float)calculate:(NSString *)exp operand:(float *)operand{
    if([exp isEqualToString:@"+"]){
        return operand[0]+operand[1];
    }
    if([exp isEqualToString:@"-"]){
        return operand[0]-operand[1];
    }
    if([exp isEqualToString:@"*"]){
        return operand[0]*operand[1];
    }
    if([exp isEqualToString:@"/"]){
        if (operand[0]==0) {
            return NAN;
        }
        return operand[0]/operand[1];
    }
    if([exp isEqualToString:@"^"]){ 
        return powf(operand[0],operand[1]);
    }
    if ([exp isEqualToString:@"√"]) {
        if (operand[0]<0) {
            return NAN;
        }
        return sqrtf(operand[0]);
    }
    XYMathFunction *mf = [[XYMathFunction alloc]init];
    return  [mf calculate:[XYOption cFunction:exp] operand:operand];
}
@end
