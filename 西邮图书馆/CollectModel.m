//
//  CollectModel.m
//  西邮图书馆
//
//  Created by Jay on 2017/2/10.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import "CollectModel.h"

@implementation CollectModel
-(void)dataAnalysis{
    self.titleArray = [NSMutableArray array];
    self.authorArray = [NSMutableArray array];
    self.IDArray = [NSMutableArray array];
    NSArray *array = [self.resource objectForKey:@"Detail"];
    if (array.count != 1&&array.count != 0) {
        for (NSDictionary *dic in array) {
            [self.titleArray addObject:[dic objectForKey:@"Title"]];
            [self.authorArray addObject:[dic objectForKey:@"Author"]];
            [self.IDArray addObject:[dic objectForKey:@"ID"]];
        }
    }
}
@end
