//
//  CollectModel.h
//  西邮图书馆
//
//  Created by Jay on 2017/2/10.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectModel : NSObject
@property(nonatomic,strong) NSDictionary *resource;
@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic,strong) NSMutableArray *authorArray;
@property(nonatomic,strong) NSMutableArray *IDArray;
-(void) dataAnalysis;
@end
