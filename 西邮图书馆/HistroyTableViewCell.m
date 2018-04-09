//
//  HistroyTableViewCell.m
//  西邮图书馆
//
//  Created by Jay on 2017/2/10.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import "HistroyTableViewCell.h"

@implementation HistroyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 375, 30)];
    self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 375, 25)];
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 65, 375, 25)];
    
    self.titleLabel.font = [UIFont systemFontOfSize:20 weight:0.3];
    self.typeLabel.font = [UIFont systemFontOfSize:16 weight:0.2];
    self.dateLabel.font = [UIFont systemFontOfSize:16 weight:0.2];
    
    self.typeLabel.textColor = [UIColor grayColor];
    self.dateLabel.textColor = [UIColor grayColor];

    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.typeLabel];
    return self;
}
@end
