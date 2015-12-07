//
//  ViewController.m
//  XYZ
//
//  Created by Julian on 12-9-3.
//  Copyright (c) 2012年 Julian. All rights reserved.
//

#import "ViewController.h"
#import "AddFunctionViewController.h"
@interface ViewController ()<UIGestureRecognizerDelegate>
-(void) savaImageToPhotosAlbum;
@end

@implementation ViewController
@synthesize gridView;
@synthesize coordinateView;
@synthesize functionsView;
@synthesize scaleView;

@synthesize navigationBar;
@synthesize toolBar;
@synthesize funcionListPopover;
@synthesize addFuncionPopover;
@synthesize actionSheet=_actionSheet;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setFuncionListPopover:nil];
    [self setAddFuncionPopover:nil];
    self.view.multipleTouchEnabled=YES;
    self.view.userInteractionEnabled=YES;

    UIPinchGestureRecognizer *pinchGR=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinchFrom:)];
    pinchGR.delegate=self;
    
    [self.view addGestureRecognizer:pinchGR];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanFrom:)]] ;
    
    [self.navigationBar setTintColor:[UIColor darkGrayColor]];
    [self.toolBar setTintColor:[UIColor darkGrayColor]];
} 


- (void)viewDidUnload
{
    [self setFunctionsView:nil];
    [self setGridView:nil];
    [self setFunctionsView:nil];
    [self setCoordinateView:nil];
    [self setScaleView:nil];
    [self setNavigationBar:nil];
    [self setToolBar:nil];
    [self setAddFuncionPopover:nil];
    [self setFuncionListPopover:nil];
    [self setUtility:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self.functionsView.functionLayers removeAllObjects];
    self.functionsView.hasDrawFunctions=NO;
    return YES;
}
-(BOOL)shouldAutorotate{
    [self.functionsView.functionLayers removeAllObjects];
    self.functionsView.hasDrawFunctions=NO;
    return YES;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIStoryboardPopoverSegue *popoverSegue=(UIStoryboardPopoverSegue *) segue;
    popoverSegue.popoverController.delegate=self;
    //popoverSegue.popoverController.popoverBackgroundViewClass=[XYUIPopoverBackgroundView class];
    if([segue.identifier isEqualToString:@"ShowAddFunctionView"]){
        UINavigationController *navigationController=(UINavigationController*)segue.destinationViewController;
    
        ((AddFunctionViewController *)navigationController.topViewController).viewController=self;
        self.addFuncionPopover=popoverSegue.popoverController;
        
    }
    if([segue.identifier isEqualToString:@"ShowFunctionListView"]){
        self.funcionListPopover=popoverSegue.popoverController;
    }
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    
}



- (IBAction)showHideGrid:(id)sender {
     NSLog(@"%@",self.gridView );
    if(self.gridView.hidden){
        self.gridView.hidden=NO;
    }else{
        self.gridView.hidden=YES;
    }
}

- (IBAction)choiceDarkLight:(id)sender {
    UISegmentedControl *segmented=(UISegmentedControl *) sender;
    if(segmented.selectedSegmentIndex==0){
        self.view.backgroundColor=[UIColor whiteColor];
        self.gridView.linColor=[UIColor blackColor];
        self.coordinateView.linColor=[UIColor blackColor];
    }else{
        self.view.backgroundColor=[UIColor blackColor];
        self.gridView.linColor=[UIColor whiteColor];
        self.coordinateView.linColor=[UIColor whiteColor];
    }
    [self.gridView setNeedsDisplay];
    [self.coordinateView setNeedsDisplay];
}

- (IBAction)showScale:(id)sender {
    if(self.scaleView.hidden){
        self.scaleView.hidden=NO;
    }else{
        self.scaleView.hidden=YES;
    }
}

- (IBAction)showTools:(id)sender {
    if(self.toolBar.hidden){
        self.toolBar.hidden=NO;
        self.navigationBar.hidden=NO;
    }else{
        self.toolBar.hidden=YES;
        self.navigationBar.hidden=YES;
    }

}
//重置坐标系
- (IBAction)reset:(id)sender {
    self.functionsView.originIsEqualWithCenter=YES;
    self.gridView.originIsEqualWithCenter=YES;
    self.coordinateView.originIsEqualWithCenter=YES;
    self.scaleView.originIsEqualWithCenter=YES;
    
    self.gridView.origin=self.view.center;
    self.gridView.unit=20;
    [self.gridView setNeedsDisplay];
    
    self.coordinateView.origin=self.view.center;
    self.coordinateView.unit=20;
    [self.coordinateView setNeedsDisplay];
    
    self.functionsView.origin=self.view.center;
    self.functionsView.unit=20;
    [self.functionsView.functionLayers removeAllObjects];
    self.functionsView.hasDrawFunctions=NO;
    [self.functionsView setNeedsDisplay];
}

- (IBAction)shouldShowAddFunctionView:(id)sender {
    if (![self.addFuncionPopover isPopoverVisible]) {
        [self performSegueWithIdentifier:@"ShowAddFunctionView" sender:self];
    }
}

- (IBAction)shouldShowFunctionsView:(id)sender {
    if(![self.funcionListPopover isPopoverVisible]){
        [self performSegueWithIdentifier:@"ShowFunctionListView" sender:self];
    }
}

//保存为图片
- (IBAction)showActionView:(id)sender {
    if(![self.actionSheet isVisible]){
        [self.actionSheet showFromBarButtonItem:sender animated:YES];
    }
}
-(UIActionSheet *)actionSheet{
    if(_actionSheet!=nil){
        return _actionSheet;
    }
    _actionSheet= [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"保存到相册", nil];
    return _actionSheet;
}
-(void) savaImageToPhotosAlbum{
    self.toolBar.hidden=YES;
    self.navigationBar.hidden=YES;
    self.scaleView.hidden=YES;
    self.utility.hidden=YES;
    UIGraphicsBeginImageContext(self.view.bounds.size );
    [self.view.layer  renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *backgroundImage=UIGraphicsGetImageFromCurrentImageContext();
    UIImageWriteToSavedPhotosAlbum(backgroundImage, nil , nil , nil );

    self.toolBar.hidden=NO;
    self.navigationBar.hidden=NO;
    self.scaleView.hidden=NO;
    self.utility.hidden=NO;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self savaImageToPhotosAlbum];
    }       
}



//缩放移动图像
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    NSLog(@"gestureRecognizer class = %@ otherGestureRecognizer class = %@" ,[gestureRecognizer class],[otherGestureRecognizer class]);
    //return YES;   
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
-(void)handlePinchFrom:(UIPinchGestureRecognizer *)recognizer{
    NSLog(@"scale is %f",recognizer.scale);
    if (recognizer.state==UIGestureRecognizerStateBegan) {
        self.gridView.hidden=YES;
        self.scaleView.hidden=YES;
    }
    if(recognizer.state==UIGestureRecognizerStateChanged||recognizer.state==UIGestureRecognizerStateEnded){
        self.gridView.unit=ceilf(self.gridView.unit*recognizer.scale);
        self.coordinateView.unit=ceilf(self.coordinateView.unit*recognizer.scale);
        self.functionsView.unit=ceilf(self.functionsView.unit*recognizer.scale);
        
        self.scaleView.unit=ceilf(self.scaleView.unit*recognizer.scale);
        
        [self.coordinateView setNeedsDisplay];
        
        [self.functionsView.functionLayers removeAllObjects];
        self.functionsView.hasDrawFunctions=NO;
        [self.functionsView setNeedsDisplay];
        
    }
    
    if (recognizer.state==UIGestureRecognizerStateEnded) {
         //self.functionsView.transform=CGAffineTransformScale(self.functionsView.transform,1,1);
        
        self.gridView.hidden=NO;
        self.scaleView.hidden=NO;
        
        [self.gridView setNeedsDisplay];
        [self.coordinateView setNeedsDisplay];
        
        [self.functionsView.functionLayers removeAllObjects];
        self.functionsView.hasDrawFunctions=NO;
        [self.functionsView setNeedsDisplay];
    }
    recognizer.scale = 1;
}

//处理拖拽手势
-(void)handlePanFrom:(UIPanGestureRecognizer *)recognizer{
    if (recognizer.state==UIGestureRecognizerStateBegan) {
        self.gridView.hidden=YES;
        self.scaleView.hidden=YES;
        
        self.functionsView.originIsEqualWithCenter=NO;
        self.gridView.originIsEqualWithCenter=NO;
        self.coordinateView.originIsEqualWithCenter=NO;
        self.scaleView.originIsEqualWithCenter=NO;
    }
    
    if(recognizer.state==UIGestureRecognizerStateChanged||recognizer.state==UIGestureRecognizerStateEnded){
        CGPoint translation=[recognizer translationInView:self.view];

        CGPoint origin=CGPointMake(self.coordinateView.origin.x+translation.x,self.coordinateView.origin.y-translation.y);
        self.coordinateView.origin=origin;
        [self.coordinateView setNeedsDisplay];
        
        self.functionsView.center=CGPointMake(self.functionsView.center.x+translation.x,self.functionsView.center.y+translation.y);
        
        self.functionsView.origin=origin;

        self.gridView.origin=origin;
        self.scaleView.origin=origin;
    }
    if (recognizer.state==UIGestureRecognizerStateEnded) {
        self.gridView.hidden=NO;
        [self.gridView setNeedsDisplay];
        
        [self.functionsView.functionLayers removeAllObjects];
        self.functionsView.hasDrawFunctions=NO;
        [self.functionsView setNeedsDisplay];
        self.functionsView.center=self.coordinateView.center;
    }
    [recognizer setTranslation:CGPointZero inView:self.view];
}
@end
