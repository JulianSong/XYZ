//
//  UIGridView.h
//  XYZ
//
//  Created by Julian on 12-9-9.
//  Copyright (c) 2012年 Julian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  <QuartzCore/QuartzCore.h>
@interface UIGridView : UIView
@property(nonatomic)CGContextRef context;
@property(atomic)CGSize size;
@property(atomic)CGPoint origin;
@property(atomic)float unit;
@property(strong,nonatomic)UIColor *linColor;
@property(nonatomic)BOOL originIsEqualWithCenter;
@end
