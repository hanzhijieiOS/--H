//
//  NewsModel.m
//  西邮图书馆
//
//  Created by Jay on 2017/2/10.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

-(void)newsDataAnalysis{
    self.dateArray = [NSMutableArray array];
    self.IDArray = [NSMutableArray array];
    self.titleArray = [NSMutableArray array];
    NSDictionary *ditailDic = [self.resource objectForKey:@"Detail"];
    NSArray *array = [ditailDic objectForKey:@"Data"];
    for (NSDictionary *dictionary in array) {
        [self.dateArray addObject:[dictionary objectForKey:@"Date"]];
        [self.IDArray addObject:[dictionary objectForKey:@"ID"]];
        [self.titleArray addObject:[dictionary objectForKey:@"Title"]];
    }
}
-(void)anounceDataAnalysis{
    self.announceDate = [NSMutableArray array];
    self.announceID = [NSMutableArray array];
    self.announceTitle = [NSMutableArray array];
    NSDictionary *ditalDic = [self.resource objectForKey:@"Detail"];
    NSArray *array = [ditalDic objectForKey:@"Data"];
    for (NSDictionary *dictionary in array) {
        [self.announceDate addObject:[dictionary objectForKey:@"Date"]];
        [self.announceID addObject:[dictionary objectForKey:@"ID"]];
        [self.announceTitle addObject:[dictionary objectForKey:@"Title"]];
    }
}
+(NSString *)getDecumentDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
}
@end
