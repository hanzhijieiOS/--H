//
//  HistroyModel.h
//  西邮图书馆
//
//  Created by Jay on 2017/2/10.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistroyModel : NSObject
@property(nonatomic,strong) NSDictionary *resource;
@property(nonatomic,strong) NSMutableArray *Barcode;
@property(nonatomic,strong) NSMutableArray *Date;
@property(nonatomic,strong) NSMutableArray *Title;
@property(nonatomic,strong) NSMutableArray *Type;
-(void)dataAnalysis;
@end
