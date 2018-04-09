//
//  MyModel.h
//  西邮图书馆
//
//  Created by Jay on 2017/2/10.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface MyModel : NSObject
@property(nonatomic,strong) NSDictionary *message;
@property(nonatomic,copy) NSString *nameStr;
@property(nonatomic,copy) NSString *classStr;
-(void)dataAnalysis;
@end
