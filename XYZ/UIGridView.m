//
//  UIGridView.m
//  XYZ
//
//  Created by Julian on 12-9-9.
//  Copyright (c) 2012年 Julian. All rights reserved.
//

#import "UIGridView.h"

@implementation UIGridView
@synthesize context;//绘图上下文
@synthesize size;//视图大小
@synthesize origin;//视图中点
@synthesize unit=_unit;//每单元占像素数
@synthesize linColor;//线条颜色
@synthesize originIsEqualWithCenter;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUnit:20];
        [self setLinColor:[UIColor darkTextColor]];
        [self setContentMode:UIViewContentModeRedraw];
        [self setOriginIsEqualWithCenter:YES];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.context=UIGraphicsGetCurrentContext();
    CGRect viewBounds = self.bounds;
    CGContextTranslateCTM(self.context, 0, viewBounds.size.height);
    CGContextScaleCTM(self.context, 1, -1);
    
   // CGContextSetFillColorWithColor(self.context,[self.linColor CGColor]);
    
    CGContextSetStrokeColorWithColor(self.context,[self.linColor CGColor]);
    [self setSize:self.frame.size];
    if (self.originIsEqualWithCenter) {
        [self setOrigin:self.center];
    }
    [self drawGrid];
    [super drawRect:rect];
}
//绘制网格
-(void)drawGrid{

    float xDistance=0;
    if(self.origin.x<=0){
        xDistance=self.size.width-self.origin.x;
    }else if(self.origin.x>0 && self.origin.x<self.size.width){
        xDistance=self.size.width;
    }else{
        xDistance=self.origin.x;
    }
    
    float yDistance=0;
    if(self.origin.y<=0){
        yDistance=self.size.height-self.origin.y;
    }else if(self.origin.y >0 && self.origin.y<self.size.height){
        yDistance=self.size.height;
    }else{
        yDistance=self.origin.y;
    }
    
    for(float i=0.0;i<xDistance;i++){
        if(i&&fmod(i,self.unit)==0&&fmod(i,self.unit*5)!=0){
            CGContextSetLineWidth(self.context,0.2f);
            CGContextMoveToPoint(self.context,self.origin.x+i,0.0f);
            CGFloat lengths[]={2,2};
            CGContextSetLineDash(context,0,lengths, 2);
            CGContextAddLineToPoint(self.context,self.origin.x+i,self.size.height);
            CGContextMoveToPoint(self.context,self.origin.x-i,0.0f);
            CGContextAddLineToPoint(self.context,self.origin.x-i,self.size.height);
            CGContextStrokePath(self.context);
        }
        if(i&&fmod(i,self.unit*5)==0){
            CGContextSetLineWidth(self.context,0.5);
            CGContextMoveToPoint(self.context,self.origin.x+i,0.0f);
            CGContextAddLineToPoint(self.context,self.origin.x+i,self.size.height);
            CGContextMoveToPoint(self.context,self.origin.x-i,0.0f);
            CGContextAddLineToPoint(self.context,self.origin.x-i,self.size.height);
            CGContextStrokePath(self.context);
        }
    }
    
    for(float i=0.0;i<yDistance;i++){
        if(i&&fmod(i,self.unit)==0&&fmod(i,self.unit*5)!=0){
            CGContextSetLineWidth(self.context,0.2f);
            CGContextMoveToPoint(self.context,0.0f,origin.y+i);
            CGContextAddLineToPoint(self.context,self.size.width,self.origin.y+i);
            CGContextMoveToPoint(self.context,0.0f,origin.y-i);
            CGContextAddLineToPoint(self.context,self.size.width,self.origin.y-i);
            CGContextStrokePath(self.context);
        }
        if(i&&fmod(i,self.unit*5)==0){
            CGContextSetLineWidth(self.context,0.5f);
            CGContextMoveToPoint(self.context,0.0f,self.origin.y+i);
            CGContextAddLineToPoint(self.context,self.size.width,self.self.origin.y+i);
            CGContextMoveToPoint(self.context,0.0f,self.origin.y-i);
            CGContextAddLineToPoint(self.context,self.size.width,origin.y-i);
            CGContextStrokePath(self.context);
        }
    }
}
@end
