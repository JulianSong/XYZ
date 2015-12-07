//
//  UICoordinateView.m
//  XYZ
//
//  Created by Julian on 12-9-9.
//  Copyright (c) 2012年 Julian. All rights reserved.
//

#import "UICoordinateView.h"

@implementation UICoordinateView
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
        [self setLinColor:[UIColor blackColor]];
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
    
    CGContextSetFillColorWithColor(self.context,[self.linColor CGColor]);
    CGContextSetStrokeColorWithColor(self.context,[self.linColor CGColor]);
    CGContextSetAlpha(self.context, 1.0);
    CGContextSelectFont(self.context, "Helvetica", 16.0, kCGEncodingMacRoman);
    CGContextSetCharacterSpacing(self.context, 2.0);
    CGContextSetTextDrawingMode(self.context, kCGTextFill);
    [self setSize:self.frame.size];
    
    if (self.originIsEqualWithCenter) {
        [self setOrigin:self.center];
    }

    [self drawCoordinate];
    [super drawRect:rect];
}

//绘制坐标系
-(void)drawCoordinate{
    
    CGContextSetLineWidth(self.context,1.0);
    
    float startX=0;
    float xDistance=0;
    if(self.origin.x<=0){
        startX=5;
        xDistance=self.size.width-self.origin.x;
    }else if(self.origin.x>0 && self.origin.x<self.size.width){
        startX=self.origin.x;
        xDistance=self.size.width;
    }else{
        startX=5;
        xDistance=self.origin.x;
    }
    
    float startY=0;
    float yDistance=0;
    if(self.origin.y<=0){
        startY=25;
        yDistance=self.size.height-self.origin.y;
    }else if(self.origin.y >0 && self.origin.y<self.size.height){
        startY=self.origin.y;
        yDistance=self.size.height;
    }else{
        startY=25;
        yDistance=self.origin.y;
    }
    
    //x轴
    if (self.origin.y>0 && self.origin.y < self.size.height) {
        CGContextMoveToPoint(self.context,0.0f,self.origin.y);
        CGContextAddLineToPoint(self.context,size.width,self.origin.y);
    }
    //x轴坐标
    for(float i=0.0;i<=xDistance;i++){
        if(i&&fmod(i,self.unit*5)==0){
            //正半轴
            CGContextMoveToPoint(self.context,self.origin.x+i,startY+5);
            CGContextAddLineToPoint(self.context,self.origin.x+i,startY-5);
            
            NSString *xx=[[NSString alloc]initWithFormat:@"%1.0f",i/self.unit];
            CGContextShowTextAtPoint(self.context,self.origin.x+i-5,startY+10, [xx UTF8String], xx.length);
            
            //负半轴
            CGContextMoveToPoint(self.context,self.origin.x-i,startY+5);
            CGContextAddLineToPoint(self.context,self.origin.x-i,startY-5);
            
            NSString *x_x=[[NSString alloc]initWithFormat:@"%1.0f",-i/self.unit];
            CGContextShowTextAtPoint(self.context,self.origin.x-i-5,startY+10, [x_x UTF8String], x_x.length);
        }
    }
    
    //y轴
    if (self.origin.x>0 && self.origin.x < self.size.width) {
        CGContextMoveToPoint(self.context,self.origin.x,0.0);
        CGContextAddLineToPoint(self.context,self.origin.x,self.size.height);
    }
        //y轴坐标
    for(float i=0.0;i<yDistance;i++){
        if(i&&fmod(i,self.unit*5)==0){
            //正半轴
            CGContextMoveToPoint(self.context,startX-5,self.origin.y+i);
            CGContextAddLineToPoint(self.context, startX+5,self.origin.y+i);
            
            
            NSString *yy=[[NSString alloc]initWithFormat:@"%1.0f",i/self.unit];
            CGContextShowTextAtPoint(self.context,startX+10,self.origin.y+i+10, [yy UTF8String],yy.length);
            
            //负半轴
            CGContextMoveToPoint(self.context,startX-5,self.origin.y-i);
            CGContextAddLineToPoint(self.context,startX+5,self.origin.y-i);
            NSString *y_y=[[NSString alloc]initWithFormat:@"%1.0f",-i/self.unit];
            
            CGContextShowTextAtPoint(self.context,startX+10,self.origin.y-i+10, [y_y UTF8String],y_y.length);

        }
    }
    
    CGContextStrokePath(self.context);
}

@end
