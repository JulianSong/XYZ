//
//  AddFunctionViewController.h
//  XYZ
//
//  Created by Julian on 12-9-15.
//  Copyright (c) 2012年 Julian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ViewController.h"
#import "UIColor+Random.h"
@interface AddFunctionViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *textExpression;
@property (strong,nonatomic) ViewController * viewController;
@property (strong,nonatomic) NSMutableArray * arrExpression;
@property (strong,nonatomic) NSString * inputValue;
@property (strong, nonatomic) IBOutlet UILabel *returnInfo;
- (IBAction)addFunction:(id)sender; 
- (IBAction)addExpression:(id)sender;
- (IBAction)delExpression:(id)sender;

-(void) joinExpression;
@end