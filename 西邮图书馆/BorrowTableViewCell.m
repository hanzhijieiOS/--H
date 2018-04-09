//
//  BorrowTableViewCell.m
//  西邮图书馆
//
//  Created by Jay on 2017/2/10.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import "BorrowTableViewCell.h"

@implementation BorrowTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 300, 30)];
    self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 150, 25)];
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 65, 200, 25)];
    self.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:0.4];
    self.stateLabel.font = [UIFont systemFontOfSize:16.0 weight:0.1];
    self.dateLabel.font = [UIFont systemFontOfSize:16.0 weight:0.1];
    [self.stateLabel setTextColor:[UIColor grayColor]];
    [self.dateLabel setTextColor:[UIColor grayColor]];
    
    self.renewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.renewButton setFrame:CGRectMake(300, 72, 50, 27)];
    [self.renewButton setBackgroundColor:[UIColor whiteColor]];
    [self.renewButton setTitle:@"续租" forState:UIControlStateNormal];
    [self.renewButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    [self.renewButton.layer setMasksToBounds:YES];
    self.renewButton.clipsToBounds = YES;
    [self.renewButton.layer setCornerRadius:5];
    [self.renewButton.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor redColor])];
    [self.renewButton.layer setBorderWidth:1];
    
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.renewButton];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.stateLabel];
    
    return self;
}

@end
