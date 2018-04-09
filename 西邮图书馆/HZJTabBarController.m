//
//  HZJTabBarController.m
//  西邮图书馆
//
//  Created by 韩智杰 on 16/11/15.
//  Copyright (c) 2016年 韩智杰. All rights reserved.
//

#import "HZJTabBarController.h"
#import "HZJmainViewController.h"
#import "HZJmyViewController.h"
#import "HZJsetViewController.h"

@interface HZJTabBarController ()

@end

@implementation HZJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.barTintColor = [UIColor colorWithRed:255.0/255 green:45.0/255 blue:44.0/255 alpha:1];

    UIImage *image1 = [UIImage imageNamed:@"home"];
    UIImage *image2 = [UIImage imageNamed:@"我的"];
    UIImage *image3 = [UIImage imageNamed:@"设置"];
    
    HZJmainViewController *view1 = [[HZJmainViewController alloc] init];
    view1.tabBarItem.image = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    view1.tabBarItem.title = @"主页";
    [view1.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    UINavigationController *vc1 = [[UINavigationController alloc] initWithRootViewController:view1];
    [self addChildViewController:vc1];
    
    HZJmyViewController *view2 = [[HZJmyViewController alloc] init];
    view2.tabBarItem.image = [image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    view2.tabBarItem.title = @"我的";
    [view2.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    UINavigationController *vc2 = [[UINavigationController alloc] initWithRootViewController:view2];
    [self addChildViewController:vc2];
    
    HZJsetViewController *view3 = [[HZJsetViewController alloc] init];
    view3.tabBarItem.image = [image3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    view3.tabBarItem.title = @"设置";
    [view3.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    UINavigationController *vc3 = [[UINavigationController alloc] initWithRootViewController:view3];
    [self addChildViewController:vc3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
