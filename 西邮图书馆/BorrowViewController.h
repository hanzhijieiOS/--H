//
//  BorrowViewController.h
//  西邮图书馆
//
//  Created by 韩智杰 on 16/12/13.
//  Copyright (c) 2016年 韩智杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BorrowViewController : UIViewController
@property(nonatomic,retain) NSString *session;
@property(nonatomic,strong) NSDictionary *resource;
@end
