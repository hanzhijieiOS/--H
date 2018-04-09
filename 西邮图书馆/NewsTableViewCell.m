//
//  NewsTableViewCell.m
//  西邮图书馆
//
//  Created by 韩智杰 on 16/11/17.
//  Copyright (c) 2016年 韩智杰. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.label = [[UILabel alloc] init];
        _label.highlightedTextColor = [UIColor clearColor];
        _label.numberOfLines = 0;
        _label.opaque = NO;
        _label.backgroundColor = [UIColor clearColor];
        [self.label setFont:[UIFont systemFontOfSize:18]];
        [self.contentView addSubview:_label];
    }
    return self;
}

@end
