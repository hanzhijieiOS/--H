//
//  DetailModel.h
//  西邮图书馆
//
//  Created by Jay on 2017/2/27.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject
@property(nonatomic,strong) NSDictionary *result;
@property(nonatomic,assign) int total;
@property(nonatomic,copy) NSString *author;
@property(nonatomic,copy) NSString *sort;
@property(nonatomic,assign) int available;
@property(nonatomic,assign) int avaliable;
@property(nonatomic,assign) int browseTimes;
@property(nonatomic,strong) NSDictionary *DoubanInfo;
@property(nonatomic,copy) NSString *image;
@property(nonatomic,copy) NSString *publish;
@property(nonatomic,assign) int favTimes;
@property(nonatomic,strong) NSMutableArray *circulation;
@property(nonatomic,copy) NSString *subject;
@property(nonatomic,strong) NSMutableArray *cirBarcode;
@property(nonatomic,strong) NSMutableArray *cirDepartment;
@property(nonatomic,strong) NSMutableArray *cirStatus;

@property(nonatomic,strong) NSMutableArray *referBooks;
@property(nonatomic,strong) NSMutableArray *referAuthor;
@property(nonatomic,strong) NSMutableArray *referTitle;
@property(nonatomic,strong) NSMutableArray *referID;

-(void)analysis;
@end
