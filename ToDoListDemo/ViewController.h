//
//  ViewController.h
//  ToDoListDemo
//
//  Created by test on 4/30/16.
//  Copyright © 2016 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskList.h"

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *leftSwiper;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSwipe;


@end

