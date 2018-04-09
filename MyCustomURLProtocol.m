//
//  MyCustomURLProtocol.m
//  西邮图书馆
//
//  Created by Jay on 2018/4/9.
//  Copyright © 2018年 韩智杰. All rights reserved.
//

#import "MyCustomURLProtocol.h"

@implementation MyCustomURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    if ([request.URL.scheme caseInsensitiveCompare:@""] == NSOrderedSame) {
        return YES;
    }
    return NO;
}

@end
