//
//  TaskList.h
//  ToDoListDemo
//
//  Created by test on 5/3/16.
//  Copyright © 2016 test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskList : NSObject


@property (nonatomic,strong) NSString *nameTask;

- (instancetype)initWithName:(NSString *)taskName2;
@end
