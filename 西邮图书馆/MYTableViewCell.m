//
//  MYTableViewCell.m
//  西邮图书馆
//
//  Created by Jay on 2017/2/10.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import "MYTableViewCell.h"

@implementation MYTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 15, 60, 24)];
    self.classLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 55, 130, 15)];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.classLabel];
    return self;
}
@end
