//
//  HZJsetViewController.m
//  西邮图书馆
//
//  Created by 韩智杰 on 16/11/15.
//  Copyright (c) 2016年 韩智杰. All rights reserved.
//

#import "HZJsetViewController.h"
#import "WTViewController.h"
#import "ModifyViewController.h"
#import "SetTableViewCell.h"
#import "HZJmyViewController.h"

@interface HZJsetViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIAlertView *alertView;
@end

@implementation HZJsetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
    self.flag = 0;
    
    NSNotification *notification = [[NSNotification alloc] initWithName:@"SFDL?" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    self.navigationItem.title = @"设置";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255.0/255 green:45.0/255 blue:44.0/255 alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor:[UIColor whiteColor],UITextAttributeFont:[UIFont boldSystemFontOfSize:21]};
    self.tableView.backgroundColor = [UIColor redColor];
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 313)];
    tableFooterView.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    self.tableView.tableFooterView = tableFooterView;
    self.tableView.rowHeight = 60;
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(reloadData:) name:@"DL" object:self.session];
 }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.flag == 0) {
        return 4;
    }else if(section == 0){
        return 6;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.flag == 0) {
        return 1;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0|indexPath.row == 1) {
            SetTableViewCell *cell = [[SetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"section1"];
            NSArray *text = [NSArray arrayWithObjects:@"到期提醒",@"2G/3G/4G下显示图片", nil];
            cell.textLabel.text = text[indexPath.row];
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"abc"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"abc"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            NSArray *text = [NSArray arrayWithObjects:@"常见问题",@"关于我们",@"修改密码",@"清除缓存", nil];
            cell.textLabel.text = text[indexPath.row - 2];
            return cell;
        }
    }
    else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            WTViewController *vc = [[WTViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 3){
        
        }else if(indexPath.row == 4){
            ModifyViewController *vc = [[ModifyViewController alloc] init];
            vc.session = self.session;
            vc.username = self.username;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 5){
            
////////////////////////////
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"newsData.txt"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:cachesPath]) {
                [[NSFileManager defaultManager] removeItemAtPath:cachesPath error:nil];
            }
            NSString *cachesPath1 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"announceData.txt"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:cachesPath1]) {
                [[NSFileManager defaultManager] removeItemAtPath:cachesPath1 error:nil];
            }
            NSLog(@"清除成功");
            
            
            
///////////////////////////
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出登录" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        self.flag = 0;
        [self.tableView reloadData];
        NSNotification *notification = [[NSNotification alloc] initWithName:@"TC" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
    }
}
-(void)reloadData:(NSNotification *)notification{
    self.flag = 1;
    NSArray *array = [NSArray arrayWithArray:[notification object]];
    self.session =array[0];
    self.username = array[1];
    [self.tableView reloadData];
}
@end
