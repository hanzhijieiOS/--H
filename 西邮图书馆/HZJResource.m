//
//  HZJResource.m
//  西邮图书馆
//
//  Created by 韩智杰 on 16/11/15.
//  Copyright (c) 2016年 韩智杰. All rights reserved.
//
//https://github.com/yuanguozheng/XiyouLibNodeExpress
// session	__NSCFString *	@"JSESSIONID=102B95C34ED6EDBE8D0151E73EDC2164; Path=/opac_two"


#import "HZJResource.h"
@class HZJmainViewController;


@implementation HZJResource
-(void)getdata{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/news/getList/news/1"];
    NSString *codedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:codedString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        if(error == nil){
            NSDictionary *Info = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"%@",Info);
            self.recourse = [NSDictionary dictionaryWithDictionary:Info];
        }
    }];
   [dataTask resume];
}
@end
