//
//  MyModel.m
//  西邮图书馆
//
//  Created by Jay on 2017/2/10.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import "MyModel.h"
#import "YYClassInfo.h"
#import "YYModel.h"

@implementation MyModel
-(void)dataAnalysis{
    NSDictionary *dic = [self.message objectForKey:@"Detail"];
    NSLog(@"diccccccc:%@",dic);
    self.nameStr = [dic objectForKey:@"Name"];
    self.classStr = [dic objectForKey:@"Department"];
}
@end
