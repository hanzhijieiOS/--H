//
//  LabelTableViewCell.m
//  西邮图书馆
//
//  Created by Jay on 2017/2/7.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import "LabelTableViewCell.h"

@implementation LabelTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, [UIScreen mainScreen].bounds.size.width, 10)];
    _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, [UIScreen mainScreen].bounds.size.width, 10)];
    _homeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 60, [UIScreen mainScreen].bounds.size.width, 10)];
    [self addSubview:_numberLabel];
    [self addSubview:_stateLabel];
    [self addSubview:_homeLabel];
    return self;
}
@end
