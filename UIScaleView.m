//
//  UIScaleView.m
//  XYZ
//
//  Created by Julian on 12-9-9.
//  Copyright (c) 2012年 Julian. All rights reserved.
//

#import "UIScaleView.h"
#include <math.h>
static inline double radians (double degrees) {return degrees * M_PI/180;}
@implementation UIScaleView

@synthesize size;//视图大小
@synthesize origin;//视图中点
@synthesize unit=_unit;//每单元占像素数
@synthesize touchPoint;
@synthesize originIsEqualWithCenter;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUnit:20];
        [self setTouchPoint:CGPointMake(self.origin.x+20, self.origin.y-24)];
        [self setContentMode:UIViewContentModeRedraw];
        [self setOriginIsEqualWithCenter:YES];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (self.originIsEqualWithCenter) {
        [self setOrigin:self.center];
    }
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    [self setSize:self.frame.size];
    
    CGContextSetLineWidth(context,1.0f);
    CGRect viewBounds = self.bounds;
    
    CGContextTranslateCTM(context, 0, viewBounds.size.height);
    CGContextScaleCTM(context, 1, -1);

    CGContextSetStrokeColorWithColor(context,[[UIColor redColor] CGColor]);
    CGFloat lengths[]={5,3};
    CGContextSetLineDash(context,2.0f,lengths, 2);
    //竖轴
    CGContextMoveToPoint(context,0.0f,self.touchPoint.y);
    CGContextAddLineToPoint(context,self.size.width,self.touchPoint.y);
    //横轴
    CGContextMoveToPoint(context,self.touchPoint.x,0.0f);
    CGContextAddLineToPoint(context,self.touchPoint.x,self.size.height);
    
    CGContextStrokePath(context);
    
    float x=(self.touchPoint.x-self.origin.x)/self.unit;
    float y=(self.touchPoint.y-self.origin.y)/self.unit;
    
    CGContextSelectFont(context, "Helvetica", 16.0, kCGEncodingMacRoman);
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextSetCharacterSpacing(context, 2.0);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    NSString *point=[[NSString alloc]initWithFormat:@"x=%1.2f,y=%1.2f",x
,y];
    
    
    CGContextShowTextAtPoint(context,self.touchPoint.x+8,self.touchPoint.y+8,[point UTF8String],point.length);
    
    [super drawRect:rect];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];
    
    if([allTouches count]==1){
        UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
        CGPoint point=[touch locationInView:self];
        self.touchPoint=CGPointMake(point.x, self.size.height-point.y);
        NSLog(@"x=%1.0f,y=%1.0f",self.touchPoint.x,self.touchPoint.y);
    }
    
    [self setNeedsDisplay];
}
@end
