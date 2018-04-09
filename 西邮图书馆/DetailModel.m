//
//  DetailModel.m
//  西邮图书馆
//
//  Created by Jay on 2017/2/27.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import "DetailModel.h"

@implementation DetailModel

-(void)analysis{
    NSString *total = [self.result objectForKey:@"Total"];
    self.total = total.intValue;
    self.cirBarcode = [NSMutableArray array];
    self.cirDepartment = [NSMutableArray array];
    self.cirStatus = [NSMutableArray array];
    self.referAuthor = [NSMutableArray array];
    self.referTitle = [NSMutableArray array];
    self.referID = [NSMutableArray array];
//    if ([self.result objectForKey:@"DoubanInfo"]!=nil) {
//        self.DoubanInfo = [self.result objectForKey:@"DoubanInfo"];
//        
//        
//        NSDictionary *dic = [self.DoubanInfo objectForKey:@"Images"];
//        self.image = [dic objectForKey:@"medium"];
//    }
    self.sort = [self.result objectForKey:@"Sort"];
    self.author = [self.result objectForKey:@"Author"];
    NSString *available = [self.result objectForKey:@"Available"];
    self.available = available.intValue;
    NSString *avaliable = [self.result objectForKey:@"Avaliable"];
    self.avaliable = avaliable.intValue;
    NSString *browseTimes = [self.result objectForKey:@"BrowseTimes"];
    self.browseTimes = browseTimes.intValue;
    self.image = [self.result objectForKey:@"DoubanInfo"];
    self.publish = [self.result objectForKey:@"Pub"];
    NSString *FavTimes = [self.result objectForKey:@"FavTimes"];
    self.favTimes = FavTimes.intValue;
    self.circulation = [self.result objectForKey:@"CirculationInfo"];
    for (NSDictionary *dic in self.circulation) {
        [self.cirBarcode addObject:[dic objectForKey:@"Barcode"]];
        [self.cirStatus addObject:[dic objectForKey:@"Status"]];
        [self.cirDepartment addObject:[dic objectForKey:@"Department"]];
    }
    self.subject = [self.result objectForKey:@"Subject"];
    self.referBooks = [self.result objectForKey:@"ReferBooks"];
    for (NSDictionary *dic in self.referBooks) {
        [self.referID addObject:[dic objectForKey:@"ID"]];
        [self.referTitle addObject:[dic objectForKey:@"Title"]];
        [self.referAuthor addObject:[dic objectForKey:@"Author"]];
    }
}

@end
