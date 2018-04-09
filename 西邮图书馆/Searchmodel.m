//
//  Searchmodel.m
//  西邮图书馆
//
//  Created by Jay on 2017/2/3.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import "Searchmodel.h"

@implementation Searchmodel
-(void)analysis{
    NSArray *array = [NSArray array];
    self.bookName = [NSMutableArray array];
    self.ID = [NSMutableArray array];
    self.Sort = [NSMutableArray array];
    self.ISBN = [NSMutableArray array];
    array = [self.resource objectForKey:@"BookData"];
    for (NSDictionary *dic in array) {
        [self.ID addObject:[dic objectForKey:@"ID"]];
        [self.bookName addObject:[dic objectForKey:@"Title"]];
        [self.ISBN addObject:[dic objectForKey:@"ISBN"]];
        [self.Sort addObject:[dic objectForKey:@"Sort"]];
    }
}
@end
