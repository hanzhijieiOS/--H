//
//  SetTableViewCell.m
//  西邮图书馆
//
//  Created by Jay on 2017/2/19.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import "SetTableViewCell.h"

@implementation SetTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.Switch = [[UISwitch alloc] initWithFrame:CGRectMake(300, 15, 75, 40)];
    [self.contentView addSubview:self.Switch];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}
@end
