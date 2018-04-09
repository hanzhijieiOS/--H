//
//  Searchmodel.h
//  西邮图书馆
//
//  Created by Jay on 2017/2/3.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Searchmodel : NSObject
@property(nonatomic,strong) NSDictionary *resource;
@property(nonatomic,strong) NSMutableArray *bookName;
@property(nonatomic,strong) NSMutableArray *ID;

@property(nonatomic,strong) NSMutableArray *ISBN;
@property(nonatomic,strong) NSMutableArray *Sort;
-(void)analysis;
@end
