//
//  HistroyModel.m
//  西邮图书馆
//
//  Created by Jay on 2017/2/10.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import "HistroyModel.h"

@implementation HistroyModel
-(void)dataAnalysis{
    self.Barcode = [NSMutableArray array];
    self.Title = [NSMutableArray array];
    self.Type = [NSMutableArray array];
    self.Date = [NSMutableArray array];
    NSArray *array = [self.resource objectForKey:@"Detail"];
    for (NSDictionary *dic in array) {
        [self.Barcode addObject:[dic objectForKey:@"Barcode"]];
        [self.Title addObject:[dic objectForKey:@"Title"]];
        [self.Type addObject:[dic objectForKey:@"Type"]];
        [self.Date addObject:[dic objectForKey:@"Date"]];
    }
}
@end
