//
//  MathFunction.m
//  CGtest
//
//  Created by Julian on 12-9-8.
//  Copyright (c) 2012年 Julian. All rights reserved.
//

#import "XYMathFunction.h"

@interface XYMathFunction()
-(NSNumber *)powf:(float *)arg;
-(NSNumber *)sinf:(float *)arg;
-(NSNumber *)cosf:(float *)arg;
-(NSNumber *)tanf:(float *)arg;
-(NSNumber *)cotf:(float *)arg;
-(NSNumber *)secf:(float *)arg;
-(NSNumber *)cscf:(float *)arg;
-(NSNumber *)asinf:(float *)arg;
-(NSNumber *)acosf:(float *)arg;
-(NSNumber *)atanf:(float *)arg;
-(NSNumber *)lnf:(float *)arg;
-(NSNumber *)logf:(float *)arg;
-(NSNumber *)log2f:(float *)arg;
-(NSNumber *)log10f:(float *)arg;
-(NSNumber *)absf:(float *)arg;
-(NSNumber *)ceilf:(float *)arg;
-(NSNumber *)floorf:(float *)arg;
@end

@implementation XYMathFunction

-(float)calculate:(NSString *)mathFunction operand:(float *)operand{
    if([self respondsToSelector:NSSelectorFromString(mathFunction)]){
        SEL mfSEL=NSSelectorFromString(mathFunction);
        IMP func = NULL;
        if (!func) {
            func = [self methodForSelector:mfSEL];
        }
        NSNumber *res=func(self, mfSEL,operand);
        //id res=[self performSelector:fs withObject:operand];//传入参数必须为对象
        return [res floatValue];
    }else{
        return NAN;
    }
    
   return NAN;
}
-(NSNumber *)powf:(float *)arg{
    if(arg[1]<0)return 0;
    return [[NSNumber alloc]initWithFloat: powf(arg[0],arg[1])];
}
-(NSNumber *)sinf:(float *)arg{
    return [[NSNumber alloc]initWithFloat: sinf(arg[0])];
}
-(NSNumber *)cosf:(float *)arg{
    return [[NSNumber alloc]initWithFloat: cosf(arg[0])];
}
-(NSNumber *)tanf:(float *)arg{
    
    return [[NSNumber alloc]initWithFloat: tanf(arg[0])];
}
-(NSNumber *)cotf:(float *)arg{
    if (tanf(arg[0])==0||isnan(tanf(arg[0]))) {
        return nil;
    }
    return [[NSNumber alloc]initWithFloat: 1/tanf(arg[0])];
}
-(NSNumber *)secf:(float *)arg{
    if (cosf(arg[0])==0||isnan(cosf(arg[0]))) {
        return nil;
    }
    return [[NSNumber alloc]initWithFloat:1/cosf(arg[0])];
}
-(NSNumber *)cscf:(float *)arg{
    if (sinf(arg[0])==0||isnan(sinf(arg[0]))||isinf(sinf(arg[0]))) {
        return nil;
    }
    return [[NSNumber alloc]initWithFloat:1/sinf(arg[0])];
}
-(NSNumber *)asinf:(float *)arg{
    return [[NSNumber alloc]initWithFloat:asinf(arg[0])];
}
-(NSNumber *)acosf:(float *)arg{
    return [[NSNumber alloc]initWithFloat:acosf(arg[0])];
}
-(NSNumber *)atanf:(float *)arg{
    return [[NSNumber alloc]initWithFloat:atanf(arg[0])];
}
-(NSNumber *)lnf:(float *)arg{
    return [[NSNumber alloc]initWithFloat: logf(arg[0])];
}
-(NSNumber *)logf:(float *)arg{
    return [[NSNumber alloc]initWithFloat:logf(arg[1])/logf(arg[0])];
}
-(NSNumber *)log2f:(float *)arg{    
    return [[NSNumber alloc]initWithFloat: log2f(arg[0])];
}
-(NSNumber *)log10f:(float *)arg{
    return [[NSNumber alloc]initWithFloat: log10f(arg[0])];
}
-(NSNumber *)absf:(float *)arg{
    if (arg[0]>0||arg[0]==0) {
        return [[NSNumber alloc] initWithFloat:arg[0]];
    }else{
        return [[NSNumber alloc] initWithFloat:-arg[0]];
    }
}
-(NSNumber *)ceilf:(float *)arg{
    return [[NSNumber alloc]initWithFloat: ceilf(arg[0])];
}
-(NSNumber *)floorf:(float *)arg{
    return [[NSNumber alloc]initWithFloat: floorf(arg[0])];
}
@end
