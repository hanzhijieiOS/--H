//
//  BorrowTableViewCell.h
//  西邮图书馆
//
//  Created by Jay on 2017/2/10.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BorrowTableViewCell : UITableViewCell
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *dateLabel;
@property(nonatomic,strong) UILabel *stateLabel;
@property(nonatomic,strong) UIButton *renewButton;
@end
