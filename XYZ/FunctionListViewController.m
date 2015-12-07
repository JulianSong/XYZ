//
//  FunctionListViewController.m
//  XYZ
//
//  Created by Julian on 12-9-14.
//  Copyright (c) 2012年 Julian. All rights reserved.
//

#import "FunctionListViewController.h"
@interface FunctionListViewController ()
-(void) hideOrShowFunction:(UITapGestureRecognizer *)recognizer;
@end

@implementation FunctionListViewController
@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize expressionType;
@synthesize changeExpressionType;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.changeExpressionType=NO;
    self.expressionType=@"ON_USE";
    [self performFetch];
    self.editButtonItem.title = @"删除";

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.allowsMultipleSelectionDuringEditing  = YES;
}
-(void) performFetch
{
    NSError *error = nil;
    if(![self.fetchedResultsController performFetch:&error]){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

//获得数据检索结果控制器
-(NSFetchedResultsController *) fetchedResultsController
{
    if(_fetchedResultsController!=nil&&!self.changeExpressionType){
        return _fetchedResultsController;
    }
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication ] delegate];
    
    NSFetchRequest * fetchRequest= [[NSFetchRequest alloc] init];
    

    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expression" inManagedObjectContext:appDelegate.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    

    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]initWithKey:@"timeStamp" ascending:NO];
    
    NSArray * descriptores = [[NSArray alloc] initWithObjects:descriptor, nil];
    
    [fetchRequest setSortDescriptors:descriptores];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(type = %@)",self.expressionType];
    [fetchRequest setPredicate:predicate];
    
    _fetchedResultsController=[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate=self;
    //NSLog(@"%@生成数据",self.expressionType);
    return _fetchedResultsController;
    
}


//绑定fetched results 到控制器，自动更新数据。

-(void) controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}
-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}
-(void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            NSLog(@"%@",@"insert data");
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            NSLog(@"%@",@"delete data");
           [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        default:
            break;
    }

}

-(void) tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"function";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Expression *expression = (Expression *) [self.fetchedResultsController objectAtIndexPath:indexPath];

    
    cell.textLabel.text=expression.expressionString;
    cell.textLabel.textColor=(UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:expression.color];
    
    if ([expression.type isEqualToString:@"ON_USE"] && [(NSNumber *)expression.isHide boolValue]) {
        cell.imageView.image=[UIImage imageNamed:@"unview.png"];
    }else if([expression.type isEqualToString:@"ON_USE"] && ![(NSNumber *)expression.isHide boolValue]){
        cell.imageView.image=[UIImage imageNamed:@"view.png"];
    }else{
        cell.imageView.image=[UIImage imageNamed:@"plus_alt_24x24.png"];
    }
    
    if ([expression.type isEqualToString:@"HISTORY"]) {

    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideOrShowFunction:)];
    [tap setNumberOfTouchesRequired:1];
    [tap setNumberOfTapsRequired:1];
    [cell.imageView setUserInteractionEnabled:YES];
    [cell.imageView addGestureRecognizer:tap];
    
    return cell;
    
}

//隐藏显示数据
-(void)hideOrShowFunction:(UITapGestureRecognizer *)recognizer{
    CGPoint tapLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    Expression *expression = (Expression *) [self.fetchedResultsController objectAtIndexPath:indexPath];
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([(NSNumber *)expression.isHide boolValue]) {
        expression.isHide=[[NSNumber alloc] initWithBool:NO];
        cell.imageView.image=[UIImage imageNamed:@"view.png"];
    }else{
        expression.isHide=[[NSNumber alloc] initWithBool:YES];
        cell.imageView.image=[UIImage imageNamed:@"unview.png"];
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


//提交数据修改
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication ] delegate];
        [appDelegate.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        NSError * error;
        if(![appDelegate.managedObjectContext save:&error]){
            NSLog(@"Unresolved error delete data error %@, %@", error, [error userInfo]);
        }
        NSLog(@"删除%@条数据",indexPath);
    }
    
    
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
        

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"Nib name" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

//选择列表
- (IBAction)changeFunctionList:(id)sender
{
    UISegmentedControl * segmentController = (UISegmentedControl *) sender;
    switch (segmentController.selectedSegmentIndex) {
        case 0:
            self.expressionType=@"ON_USE";
            break;
        case 1:
            self.expressionType=@"MORE_USE";
            break;
        case 2:
            self.expressionType=@"HISTORY";
            break;
    }
    self.changeExpressionType=YES;
    
    [self performFetch];
    self.changeExpressionType=NO;
    
    [self.tableView reloadData];
}

- (IBAction)delFunction:(id)sender
{
   NSArray *paths =  self.tableView.indexPathsForSelectedRows;
    for (NSIndexPath *indexPath in paths) {
        AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication ] delegate];
        [appDelegate.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        NSError * error;
        if(![appDelegate.managedObjectContext save:&error]){
            NSLog(@"Unresolved error delete data error %@, %@", error, [error userInfo]);
        }
        NSLog(@"删除%@条数据",indexPath);

    }
    

}


@end
