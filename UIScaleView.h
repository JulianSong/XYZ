//
//  UIScaleView.h
//  XYZ
//
//  Created by Julian on 12-9-9.
//  Copyright (c) 2012年 Julian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScaleView : UIView

@property(atomic)CGSize size;
@property(atomic)CGPoint origin;
@property(atomic)float unit;
@property(nonatomic) CGPoint touchPoint;
@property(nonatomic)BOOL originIsEqualWithCenter;
@end
