//
//  ModifyViewController.m
//  西邮图书馆
//
//  Created by Jay on 2017/2/19.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import "ModifyViewController.h"
#import "ModifyTableViewCell.h"
@interface ModifyViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,copy) NSString *password;
@property(nonatomic,copy) NSString *NewPassword;
@property(nonatomic,copy) NSString *rePassword;
@property(nonatomic,strong) UIButton *button;
@property(nonatomic,copy) NSString *result;
@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = 55;
    [self.view addSubview:self.tableView];
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setFrame:CGRectMake(80, 350, 215, 40)];
    [self.button setBackgroundColor:[UIColor greenColor]];
    [self.button setTitle:@"确        定" forState:UIControlStateNormal];
    [self.button.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.button.clipsToBounds = YES;
    self.button.layer.cornerRadius = 5;
    [self.button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ModifyTableViewCell *cell = [[ModifyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row +100;
    NSArray *text = [NSArray arrayWithObjects:@"用户账号",@"当前密码",@"新密码",@"确认密码", nil];
    cell.label.text = text[indexPath.row];
    NSArray *array = [NSArray arrayWithObjects:@"请输入当前密码",@"请设置新密码",@"请再次输入", nil];
    if (indexPath.row != 0) {
        cell.textField.placeholder = array[indexPath.row - 1];
    }else{
        cell.textField.text = self.username;
        cell.textField.textColor = [UIColor grayColor]; ;
        cell.textField.enabled = NO;
    }
    return cell;
}

-(void)clickButton{
    UITextField *tf = (UITextField *)[self.view viewWithTag:101];
    self.password = tf.text;
    UITextField *tf2 = (UITextField *)[self.view viewWithTag:102];
    self.NewPassword = tf2.text;
    UITextField *tf3 = (UITextField *)[self.view viewWithTag:103];
    self.rePassword = tf3.text;
    [self modifyPassword];
}
- (void)modifyPassword{
    NSString *urlStr = [NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/user/modifyPassword?session=%@&username=%@&password=%@&newpassword=%@&repassword=%@",self.session,self.username,self.password,self.NewPassword,self.rePassword];
    NSString *codeStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:codeStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            self.result = [info objectForKey:@"Detail"];
            NSLog(@"info:%@",info);
            [self performSelectorOnMainThread:@selector(showModifyResult) withObject:nil waitUntilDone:NO];
        }
    }];
    [dataTask resume];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)showModifyResult{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alertView.delegate = self;
    if ([self.result isEqualToString:@"MODIFY_SUCCEED"]) {
        alertView.title = @"修改成功";
    }else if ([self.result isEqualToString:@"INVALID_PASSWORD"]){
        alertView.title = @"修改失败";
        alertView.message = @"提示：旧密码不正确或未登录";
    }else if([self.result isEqualToString:@"UDIFFERENT_PASSWORD"]){
        alertView.title = @"修改失败";
        alertView.message = @"提示：两次密码输入不一致";
    }else{
        alertView.title = @"修改失败";
    }
    [alertView show];
}
@end
