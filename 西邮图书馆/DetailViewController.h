//
//  DetailViewController.h
//  西邮图书馆
//
//  Created by Jay on 2017/2/7.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *barcode;
@property (nonatomic,copy) NSString *session;
@property (nonatomic,assign) int type;
@end
