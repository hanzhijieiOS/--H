//
//  NewsModel.h
//  西邮图书馆
//
//  Created by Jay on 2017/2/10.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface NewsModel : NSObject




@property(nonatomic,strong) NSDictionary *resource;
@property(nonatomic,strong) NSMutableArray *dateArray;
@property(nonatomic,strong) NSMutableArray *IDArray;
@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic,strong) NSMutableArray *announceDate;
@property(nonatomic,strong) NSMutableArray *announceID;
@property(nonatomic,strong) NSMutableArray *announceTitle;

+(NSString *)getDecumentDirectory;

-(void)newsDataAnalysis;
-(void)anounceDataAnalysis;
@end
