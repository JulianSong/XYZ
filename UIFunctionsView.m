//
//  UIFunctionsView.m
//  XYZ
//
//  Created by Julian on 12-9-9.
//  Copyright (c) 2012年 Julian. All rights reserved.
//

#import "UIFunctionsView.h"
@interface UIFunctionsView()

@end
@implementation UIFunctionsView
@synthesize context;//绘图上下文
@synthesize size;//视图大小
@synthesize origin;//视图中点
@synthesize unit=_unit;//每单元占像素数
@synthesize functionLayers=_functionLayers;
@synthesize linColor;//线条颜色
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize hasDrawFunctions;
@synthesize originIsEqualWithCenter;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUnit:20];
        [self setLinColor:[UIColor darkTextColor]];
        [self setFunctionLayers:[[NSMutableArray alloc] init]];
        [self fetchedResultsController];
        [self setHasDrawFunctions:NO];
        [self setOriginIsEqualWithCenter:YES];
        [self setContentMode:UIViewContentModeRedraw];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    if (self.originIsEqualWithCenter) {
        [self setOrigin:self.center];
    }
    
    self.context=UIGraphicsGetCurrentContext();

    [self setSize:self.frame.size];
    
    if(!self.hasDrawFunctions){
        [self drawAllFunction];
        self.hasDrawFunctions=YES;
    }
    
    [self drawFunctionLayersToContext];
    [super drawRect:rect];
}

//获得数据检索结果控制器
-(NSFetchedResultsController *) fetchedResultsController
{
    if(_fetchedResultsController!=nil){
        return _fetchedResultsController;
    }
    
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication ] delegate];
    
    NSFetchRequest * fetchRequest= [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expression" inManagedObjectContext:appDelegate.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]initWithKey:@"timeStamp" ascending:YES];
    
    NSArray * descriptores = [[NSArray alloc] initWithObjects:descriptor, nil];
    
    [fetchRequest setSortDescriptors:descriptores];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(type = %@)",@"ON_USE"];
    [fetchRequest setPredicate:predicate];
    
    _fetchedResultsController=[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate=self;

    NSError *error = nil;
    if(![_fetchedResultsController performFetch:&error]){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);
    }
    return _fetchedResultsController;
}

//绘制函数曲线
-(void)drawFunctionToLayer:(Expression *)exp
{
    NSLog(@"draw function:%@",exp.expressionString);
    NSMutableArray *pn = [NSKeyedUnarchiver unarchiveObjectWithData:exp.prefixNotation];
    CGLayerRef functionLayer=CGLayerCreateWithContext(self.context,size,NULL);
    CGContextRef functionContext = CGLayerGetContext (functionLayer);
    CGRect viewBounds = self.bounds;
    CGContextTranslateCTM(functionContext, 0, viewBounds.size.height);
    CGContextScaleCTM(functionContext, 1, -1);
    
    CGContextSetLineWidth(functionContext,2.0f);

    CGContextSetStrokeColorWithColor(functionContext, [(UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:exp.color] CGColor]);

   
    Boolean hasSetStartPoint=NO;
    float xDistance=0;
    if(self.origin.x<=0){
        xDistance=self.size.width-self.origin.x;
    }else if(self.origin.x>0 && self.origin.x<self.size.width){
        xDistance=self.size.width;
    }else{
        xDistance=self.origin.x;
    }
    
    for (float x=-self.origin.x; x<xDistance; x++)
    {
        float y=[XYArithmetic calculateExpression:pn withX:x/self.unit error:nil]*self.unit;
        if (hasSetStartPoint==NO &&!isnan(y)&& !isinf(y)) {
            NSLog(@"start point x=%f,y=%f",x+self.origin.x,y);
            CGContextMoveToPoint(functionContext,x+self.origin.x,y+self.origin.y);
            hasSetStartPoint=YES;
        }
        if (!isnan(y)&&!isinf(y)) {
             CGContextAddLineToPoint(functionContext,x+self.origin.x,y+self.origin.y);
        }
        if (hasSetStartPoint==YES && (isnan(y) ||isinf(y))) {
            hasSetStartPoint=NO;
        }
    }
    
    CGContextStrokePath(functionContext);
    [self.functionLayers addObject:[NSValue valueWithBytes:&functionLayer objCType:@encode(CGLayerRef)]];
}

-(void) drawAllFunction
{
    for (Expression *exp in self.fetchedResultsController.fetchedObjects)
    { 
        [self drawFunctionToLayer:exp];
    }
}


//
-(void) drawFunctionLayersToContext
{

    /*NSLog(@" 1 self.functionLayers.count %d",self.functionLayers.count);
    for (NSValue *layerVar in self.functionLayers)
    {
        CGLayerRef functionLayer;
        [(NSValue *) layerVar getValue:&functionLayer];
        CGContextDrawLayerAtPoint(self.context,CGPointZero,functionLayer);
    }
    */
    
    for (Expression *exp in self.fetchedResultsController.fetchedObjects)
    {
        if (![(NSNumber *) exp.isHide boolValue]) {
            NSIndexPath *indexPath=[self.fetchedResultsController indexPathForObject:exp];
            NSValue *layerVar=[self.functionLayers objectAtIndex:indexPath.row];
            CGLayerRef functionLayer;
            [(NSValue *) layerVar getValue:&functionLayer];
            CGContextDrawLayerAtPoint(self.context,CGPointZero,functionLayer);
        }
    }
}


//侦听数据变化绘制函数
-(void) controllerWillChangeContent:(NSFetchedResultsController *)controller
{
   // NSLog(@"[UIFunctionsView controllerWillChangeContent]");
}
-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"[UIFunctionsView controllerDidChangeContent]");
    [self drawFunctionLayersToContext];
    [self setNeedsDisplay];
}
-(void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    NSLog(@"UIFunctionsView didChangeObject %@, %@",indexPath,newIndexPath);
    switch (type)
    {
        case NSFetchedResultsChangeInsert:
        {
            Expression *exp= (Expression *) [self.fetchedResultsController objectAtIndexPath:newIndexPath];
            [self drawFunctionToLayer:exp];
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [self.functionLayers removeObjectAtIndex:indexPath.row];
            break;
        }
        case NSFetchedResultsChangeUpdate:
        {
            
        }
        default:
            break;
    }
}
@end
