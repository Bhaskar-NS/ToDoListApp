//
//  TaskList.m
//  ToDoListDemo
//
//  Created by test on 5/3/16.
//  Copyright © 2016 test. All rights reserved.
//

#import "TaskList.h"

@implementation TaskList
- (instancetype)initWithName:(NSString *)taskName2;
{
    self = [super init];
    if (self) {
        _nameTask=taskName2;
    }
    return self;
}
@end
