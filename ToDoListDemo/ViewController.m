//
//  ViewController.m
//  ToDoListDemo
//
//  Created by test on 4/30/16.
//  Copyright © 2016 test. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "TableViewCell.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dateArr,*listOfTasks;
@property (strong,nonatomic) NSIndexPath *path;

@property (nonatomic,strong) NSDate *taskDate;
@property (nonatomic,assign) int taskNumber,selectingTaskToDelete;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSDate *dateStr;

@property (strong,nonatomic) NSString *dateString;
@end
@implementation ViewController

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.selectingTaskToDelete=0;
    self.taskNumber=0;
    //self.listOfTasks =[[NSMutableArray alloc]init];
    self.dateArr=[[NSMutableArray alloc]init];
    [self fetchingData];
    
    
}
- (IBAction)addTasks:(id)sender {
    
//    self.taskNumber++;
//    NSString *object1=[NSString stringWithFormat:@"Task %d",self.taskNumber];
//    [self.listOfTasks addObject:object1];
    self.taskDate=[[NSDate alloc]init];
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.dateString= [format stringFromDate:_taskDate];
    [self.tableView reloadData];
    
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Enter Task Datails To Add" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder=NSLocalizedString(@"Enter Task", @"Task");
    }];
    
    
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                       {
                           UITextField *taskField=alert.textFields.firstObject;
                           
//                           [self.listOfTasks addObject:taskField.text];
                           
                           NSManagedObjectContext *context=[self getContext];
                           NSManagedObject *toDoList=[NSEntityDescription insertNewObjectForEntityForName:@"ToDoList1" inManagedObjectContext:context];
                           [toDoList setValue:taskField.text forKey:@"taskname"];
                           [toDoList setValue:_dateString forKey:@"taskdate"];
                           NSError *error=nil;
                           if ([context save:&error]) {
                               NSLog(@"saved Successfully");
                               [self fetchingData];
                           }
                           [self.tableView reloadData];
                           
                       }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    [self.dateArr addObject:_dateString];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listOfTasks.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSManagedObject *model=self.listOfTasks[indexPath.row];
    cell.taskName.text=[model valueForKey:@"taskname"];
//    NSDate *receivedDate=[model valueForKey:@"taskdate"];
//    NSLog(@"%@",receivedDate);
//    NSDateFormatter *ftr=[[NSDateFormatter alloc]init];
//    NSString *strDate=[ftr stringFromDate:receivedDate];
    cell.taskDate.text=[model valueForKey:@"taskdate"];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle==UITableViewCellEditingStyleDelete) {
//        
//        [_listOfTasks removeObjectAtIndex:indexPath.row];
//        [tableView reloadData];
//    }
//}
-(void)fetchingData
{
    NSManagedObjectContext *context=[self getContext];
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"ToDoList1"];
    NSError *error=nil;
    self.listOfTasks=[[NSMutableArray alloc]initWithArray:[context executeFetchRequest:request error:&error]];
    
}
-(NSManagedObjectContext*)getContext
{
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context=[app managedObjectContext];
    return context;
}
- (IBAction)rightSwipe:(UIGestureRecognizer*)sender {
    CGPoint loc=[sender locationInView:self.tableView];
    self.path=[self.tableView indexPathForRowAtPoint:loc];
    TableViewCell *tl=[self.tableView cellForRowAtIndexPath:self.path];
    tl.editOutlet.hidden=YES;
    tl.deleteOutlet.hidden=YES;
}
- (IBAction)leftSwipe:(id)sender {
    
    CGPoint loc=[sender locationInView:self.tableView];
    self.path=[self.tableView indexPathForRowAtPoint:loc];
    TableViewCell *tl=[self.tableView cellForRowAtIndexPath:self.path];
    tl.editOutlet.hidden=NO;
    tl.deleteOutlet.hidden=NO;

}
- (IBAction)deleteTask:(UIButton*)sender {
    
    NSIndexPath *index=[self.tableView indexPathForCell:(TableViewCell *)sender.superview.superview];
    NSManagedObjectContext *context=[self getContext];
    [context deleteObject:[self.listOfTasks objectAtIndex:index.row]];
    NSError *error=nil;
    [context save:&error];
    //[self fetchingData];
    
    
    [self.listOfTasks removeObjectAtIndex:index.row];
    [self.tableView reloadData];
    [self hideButtons];
    
}
-(void)hideButtons
{
    TableViewCell *tl=[self.tableView cellForRowAtIndexPath:self.path];
    tl.editOutlet.hidden=YES;
    tl.deleteOutlet.hidden=YES;
}
- (IBAction)editTask:(UIButton*)sender {
    
    self.taskDate=[[NSDate alloc]init];
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.dateString= [format stringFromDate:_taskDate];
    
    NSIndexPath *index=[self.tableView indexPathForCell:(TableViewCell*)sender.superview.superview];
    
    NSManagedObject *model=[self.listOfTasks objectAtIndex:index.row];
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Modify Details" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder=NSLocalizedString(@"Enter Task", @"Task");
        textField.text=[model valueForKey:@"taskname"];
    }];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                       {
                           UITextField *taskField=alert.textFields.firstObject;
                           
                           //                           [self.listOfTasks addObject:taskField.text];
                           
                           NSManagedObjectContext *context=[self getContext];
                           NSManagedObject *task=[self.listOfTasks objectAtIndex:self.path.row];
                           [task setValue:taskField.text forKey:@"taskname"];
                           [task setValue:_dateString forKey:@"taskdate"];
                           NSError *error=nil;
                           if ([context save:&error]) {
                               NSLog(@"saved Successfully");
                               [self fetchingData];
                           }
                           [self.tableView reloadData];
                           [self hideButtons];
                           
                       }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    

}
@end
