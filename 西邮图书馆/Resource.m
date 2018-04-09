//
//  Resource.m
//  西邮图书馆
//
//  Created by Jay on 2017/2/3.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import "Resource.h"

@implementation Resource
-(void)showRank{
    
    NSArray *array = [NSArray array];
    array = [self.rank objectForKey:@"Detail"];
    self.rankTitle = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        [self.rankTitle addObject:[dic objectForKey:@"Title"]];
    }
}

@end
