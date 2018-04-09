//
//  BorrowModel.h
//  西邮图书馆
//
//  Created by Jay on 2017/2/10.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BorrowModel : NSObject

@property(nonatomic,strong) NSDictionary *recourse;
@property(nonatomic,strong) NSMutableArray *canRenew;
@property(nonatomic,strong) NSMutableArray *Title;
@property(nonatomic,strong) NSMutableArray *Barcode;
@property(nonatomic,strong) NSMutableArray *Date;
@property(nonatomic,strong) NSMutableArray *State;
@property(nonatomic,strong) NSMutableArray *Library_id;
@property(nonatomic,strong) NSMutableArray *Department_id;
- (void)dataAnalysis;
@end
