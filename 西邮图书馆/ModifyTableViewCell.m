//
//  ModifyTableViewCell.m
//  西邮图书馆
//
//  Created by Jay on 2017/2/19.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import "ModifyTableViewCell.h"

@implementation ModifyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 85, 55)];
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, 200, 55)];
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.textField];
    return self;
}
@end
