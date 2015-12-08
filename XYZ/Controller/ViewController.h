//
//  ViewController.h
//  XYZ
//
//  Created by Julian on 12-9-3.
//  Copyright (c) 2012年 Julian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridView.h"
#import "UICoordinateView.h"
#import "UIFunctionsView.h"
#import "UIScaleView.h"
#import "FunctionListViewController.h"
#import  <QuartzCore/QuartzCore.h>
@interface ViewController : UIViewController <UIPopoverControllerDelegate,UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIButton *utility;
@property (strong, nonatomic) IBOutlet UIGridView *gridView;
@property (strong, nonatomic) IBOutlet UICoordinateView *coordinateView;
@property (strong, nonatomic) IBOutlet UIFunctionsView *functionsView;
@property (strong, nonatomic) IBOutlet UIScaleView *scaleView;

@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@property (strong,nonatomic) UIPopoverController *funcionListPopover;
@property (strong,nonatomic) UIPopoverController *addFuncionPopover;
@property (readonly,strong,nonatomic) UIActionSheet *actionSheet;
- (IBAction)showHideGrid:(id)sender;
- (IBAction)choiceDarkLight:(id)sender;
- (IBAction)showScale:(id)sender;
- (IBAction)showTools:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)shouldShowAddFunctionView:(id)sender;
- (IBAction)shouldShowFunctionsView:(id)sender;
- (IBAction)showActionView:(id)sender;
- (void)handlePinchFrom:(UIPinchGestureRecognizer*)recognizer;
- (void)handlePanFrom:(UIPanGestureRecognizer*)recognizer;
@end
