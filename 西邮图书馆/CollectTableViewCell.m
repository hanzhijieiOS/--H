//
//  CollectTableViewCell.m
//  西邮图书馆
//
//  Created by Jay on 2017/2/10.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import "CollectTableViewCell.h"

@implementation CollectTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 360, 50)];
    self.authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 65, 375, 30)];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.authorLabel];
    return self;
}

@end
