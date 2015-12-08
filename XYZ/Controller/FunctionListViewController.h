//
//  FunctionListViewController.h
//  XYZ
//
//  Created by Julian on 12-9-14.
//  Copyright (c) 2012年 Julian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Expression.h"
@interface FunctionListViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (readonly,strong,nonatomic) NSFetchedResultsController * fetchedResultsController;
@property (strong,nonatomic) NSString *expressionType;
@property Boolean changeExpressionType;
-(void) performFetch;
- (IBAction)changeFunctionList:(id)sender;
- (IBAction)delFunction:(id)sender;

@end;
