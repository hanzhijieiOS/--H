//
//  BorrowModel.m
//  西邮图书馆
//
//  Created by Jay on 2017/2/10.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import "BorrowModel.h"

@implementation BorrowModel
-(void)dataAnalysis{
    self.Barcode = [NSMutableArray array];
    self.Title = [NSMutableArray array];
    self.Date = [NSMutableArray array];
    self.State = [NSMutableArray array];
    self.Department_id = [NSMutableArray array];
    self.Library_id = [NSMutableArray array];
    self.canRenew = [NSMutableArray array];
    NSArray *array = [self.recourse objectForKey:@"Detail"];
    if (array.count != 0) {
        for (NSDictionary *dic in array) {
            [self.canRenew addObject:[dic objectForKey:@"CanRenew"]];
            [self.Barcode addObject:[dic objectForKey:@"Barcode"]];
            [self.Title addObject:[dic objectForKey:@"Title"]];
            [self.Date addObject:[dic objectForKey:@"Date"]];
            [self.State addObject:[dic objectForKey:@"State"]];
            [self.Department_id addObject:[dic objectForKey:@"Department_id"]];
            [self.Library_id addObject:[dic objectForKey:@"Library_id"]];
        }
    }
}
@end
