//
//  Resource.h
//  西邮图书馆
//
//  Created by Jay on 2017/2/3.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Resource : NSObject
@property(nonatomic,strong) NSDictionary *rank;
@property(nonatomic,strong) NSMutableArray *rankTitle;
-(void)showRank;
@end
