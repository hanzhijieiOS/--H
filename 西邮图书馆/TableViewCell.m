//
//  TableViewCell.m
//  西邮图书馆
//
//  Created by Jay on 2017/2/7.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.IDLabel= [[UILabel alloc] initWithFrame:CGRectMake(5, 10, [UIScreen mainScreen].bounds.size.width, 10)];
    self.writerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, [UIScreen mainScreen].bounds.size.width, 10)];
    self.homeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, [UIScreen mainScreen].bounds.size.width, 10)];
    self.borrowLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 100, [UIScreen mainScreen].bounds.size.width, 10)];
    self.collectLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 130, [UIScreen mainScreen].bounds.size.width, 10)];
    [self.contentView addSubview:_IDLabel];
    [self.contentView addSubview:_writerLabel];
    [self.contentView addSubview:_homeLabel];
    [self.contentView addSubview:_borrowLabel];
    [self.contentView addSubview:_collectLabel];
    return self;
}
@end
