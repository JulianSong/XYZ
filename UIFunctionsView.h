//
//  UIFunctionsView.h
//  XYZ
//
//  Created by Julian on 12-9-9.
//  Copyright (c) 2012年 Julian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Expression.h"
#import "XYArithmetic.h"
#import "UIColor+Random.h"
#import  <QuartzCore/QuartzCore.h>
@interface UIFunctionsView : UIView <NSFetchedResultsControllerDelegate>
@property(nonatomic)CGContextRef context;
@property(atomic)CGSize size;
@property(atomic)CGPoint origin;
@property(atomic)float unit;
@property(strong,nonatomic)UIColor *linColor;
@property(strong,atomic) NSMutableArray *functionLayers;
@property (nonatomic) BOOL hasDrawFunctions;
@property (readonly,strong,nonatomic) NSFetchedResultsController * fetchedResultsController;
@property(nonatomic)BOOL originIsEqualWithCenter;
-(void) drawFunctionToLayer:(Expression *)exp;
-(void) drawFunctionLayersToContext;
-(void) drawAllFunction;
@end
