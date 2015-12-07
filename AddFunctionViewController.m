//
//  AddFunctionViewController.m
//  XYZ
//
//  Created by Julian on 12-9-15.
//  Copyright (c) 2012年 Julian. All rights reserved.
//

#import "AddFunctionViewController.h"
#import "AppDelegate.h"
#import "Expression.h"
#import "XYArithmetic.h"

@interface AddFunctionViewController ()

@end

@implementation AddFunctionViewController
@synthesize viewController;
@synthesize textExpression;
@synthesize arrExpression=_arrExpression;
@synthesize inputValue;
@synthesize returnInfo;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setArrExpression:[[NSMutableArray alloc] init]];
    [self.arrExpression removeAllObjects];
    [self setInputValue:@""];
    self.textExpression.userInteractionEnabled=NO;
    self.textExpression.text=@"y=";
    
    
    
    UIColor *circleColorPattern = [UIColor colorWithPatternImage:
                                   [UIImage imageNamed:@"dark_noise_bkg.png"]];
    self.view.backgroundColor=circleColorPattern;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setTextExpression:nil];
    [self setViewController:nil];
    [self setArrExpression:nil];
    [self setInputValue:nil];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//添加函数
- (IBAction)addFunction:(id)sender
{
    if(!self.arrExpression.count){
        self.returnInfo.textColor=[UIColor redColor];
        self.returnInfo.text=@"请输入表达式";
        return;
    }
    
    if(![self.inputValue isEqualToString:@""]){
        [self.arrExpression addObject:self.inputValue];
    }
    
    NSData * notation = [NSKeyedArchiver archivedDataWithRootObject:self.arrExpression];
    NSError *error=nil;
    NSMutableArray *expression=[XYArithmetic shuntingYard:self.arrExpression error:&error];
    [XYArithmetic calculateExpression:expression withX:1 error:&error];
    if (error!=nil) {
        self.returnInfo.textColor=[UIColor redColor];
        self.returnInfo.text=[[error userInfo] objectForKey:NSLocalizedDescriptionKey];
        return;
    }
    
    NSData *prefixNotation = [NSKeyedArchiver archivedDataWithRootObject:expression];
    NSData *colorData=[NSKeyedArchiver archivedDataWithRootObject:[UIColor randomColor]];
    NSDate *datenow = [NSDate date];
    
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication ] delegate];
    

    Expression *ex= (Expression *)[NSEntityDescription insertNewObjectForEntityForName:@"Expression" inManagedObjectContext:appDelegate.managedObjectContext];
    ex.isHide=[[NSNumber alloc] initWithBool:NO ];
    ex.expressionString=self.textExpression.text;
    ex.type=@"ON_USE";
    ex.color=colorData;
    ex.notation=notation;
    ex.prefixNotation = prefixNotation;
    ex.timeStamp = [NSString stringWithFormat:@"%ld",(long)[datenow timeIntervalSince1970]];
    
    
    Expression *exh= (Expression *)[NSEntityDescription insertNewObjectForEntityForName:@"Expression" inManagedObjectContext:appDelegate.managedObjectContext];
    exh.isHide=[[NSNumber alloc] initWithBool:NO ];
    exh.expressionString=self.textExpression.text;
    exh.type=@"HISTORY";
    exh.color=colorData;
    exh.timeStamp = [NSString stringWithFormat:@"%ld",(long)[datenow timeIntervalSince1970]];

    
    if(![appDelegate.managedObjectContext save:&error]){
        NSLog(@"%@",@"添加表达式");
    }
    [self.viewController.addFuncionPopover dismissPopoverAnimated:YES];
}

//添加操作符
- (IBAction)addExpression:(id)sender
{
    UIButton *exp = (UIButton *)sender;
    NSScanner* scan = [NSScanner scannerWithString:exp.titleLabel.text];
    int val;
    
    if(([scan scanInt:&val] && [scan isAtEnd])||[exp.titleLabel.text isEqualToString:@"."]){
        self.inputValue=[self.inputValue stringByAppendingString:exp.titleLabel.text];
        
    }else{
        if(![self.inputValue isEqualToString:@""]){
            [self.arrExpression addObject:self.inputValue];
        }
        self.inputValue=@"";
        [self.arrExpression addObject:exp.titleLabel.text];
       // [self joinExpression];
    }
    
    self.textExpression.text=[self.textExpression.text stringByAppendingString:exp.titleLabel.text];
    
}

//删除表达式
- (IBAction)delExpression:(id)sender {
    if(![self.inputValue isEqualToString:@""]){
        self.inputValue=@"";
    }else{
        [self.arrExpression removeLastObject];
    }
    [self joinExpression];
}

//拼接表达式为字符串
-(void) joinExpression{
    self.textExpression.text=@"y=";
    for (NSString * exp in self.arrExpression) {
            self.textExpression.text=[self.textExpression.text stringByAppendingString:exp];
    }
}
@end
