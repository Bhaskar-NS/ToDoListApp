//
//  TableViewCell.h
//  ToDoListDemo
//
//  Created by test on 5/10/16.
//  Copyright © 2016 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *taskName;
@property (strong, nonatomic) IBOutlet UILabel *taskDate;
@property (strong, nonatomic) IBOutlet UIButton *deleteOutlet;

@property (strong, nonatomic) IBOutlet UIButton *editOutlet;
@end
