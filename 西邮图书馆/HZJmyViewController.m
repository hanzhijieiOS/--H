//
//  HZJmyViewController.m
//  西邮图书馆
//
//  Created by 韩智杰 on 16/11/15.
//  Copyright (c) 2016年 韩智杰. All rights reserved.
//

#import "HZJmyViewController.h"
#import "HZJsetViewController.h"
#import "MYTableViewCell.h"
#import "MyModel.h"
#import "BorrowViewController.h"
#import "CollectViewController.h"
#import "HistoryViewController.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "SVProgressHUD.h"


@interface HZJmyViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong) UITextField *userText;
@property(nonatomic,strong) UITextField *pswText;
@property(nonatomic,strong) UIButton *loginBtn;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSDictionary *massage;
@property(nonatomic) MyModel *dataModel;
@property(nonatomic) UIButton *imageButton;
@property(nonatomic,copy)NSString *username;
@end

@implementation HZJmyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataModel = [[MyModel alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255.0/255 green:45.0/255 blue:44.0/255 alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor:[UIColor whiteColor],UITextAttributeFont:[UIFont boldSystemFontOfSize:21]};
    [self beforeLogin];
    
    NSNotificationCenter *DetailCenter = [NSNotificationCenter defaultCenter];
    [DetailCenter addObserver:self selector:@selector(detailViewControllerNotification) name:@"DetailViewController" object:nil];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(beforeLogin) name:@"TC" object:nil];
    
    NSNotificationCenter *SFDLcenter = [NSNotificationCenter defaultCenter];
    [SFDLcenter addObserver:self selector:@selector(sfdlfunction) name:@"SFDL?" object:nil];
}
- (void)detailViewControllerNotification{
    if (self.Session == NULL) {
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^(){
            NSNotification *notification = [[NSNotification alloc] initWithName:@"Detail" object:self.Session userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        });
    }
}
- (void)sfdlfunction{
    if (self.Session == NULL) {
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^(){
            NSArray *array = [NSArray arrayWithObjects:self.Session,self.username, nil];
            NSNotification *notification = [[NSNotification alloc] initWithName:@"DL" object:array userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableView *)mytableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 567) style:UITableViewStyleGrouped];
    }
    return _tableView;
}
-(UIButton *)myloginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _loginBtn;
}
-(void)beforeLogin{
    for (int i=0; i<[self.view.subviews count]; i++) {
        [[self.view.subviews objectAtIndex:i] removeFromSuperview];
    }
    [self myloginBtn];
    [self.loginBtn setTitle:@"点击登录" forState:UIControlStateNormal];
    self.loginBtn.frame = CGRectMake(140, 400, 95, 35);
    [self.view addSubview:self.loginBtn];
    self.loginBtn.backgroundColor = [UIColor yellowColor];
    [self.loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(showTextInputAlert) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)afterLogin{
    [self.loginBtn removeFromSuperview];
    [self requestMessage];
    [self mytableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    NSArray *array = [NSArray arrayWithObjects:self.Session,self.username, nil];
    NSNotification *notification = [[NSNotification alloc] initWithName:@"DL" object:array userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    NSNotification *Detail = [[NSNotification alloc] initWithName:@"Detail" object:self.Session userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:Detail];
}
-(void)showTextInputAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录" message:@"请输入信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
    alert.delegate = self;
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    self.userText = [[UITextField alloc] init];
    self.pswText = [[UITextField alloc] init];
    self.userText = [alert textFieldAtIndex:0];
    self.pswText = [alert textFieldAtIndex:1];
    self.pswText.secureTextEntry = YES;
    self.userText.placeholder = @"输入用户名";
    self.pswText.placeholder = @"输入密码";
    self.userText.keyboardType = UIKeyboardTypeNumberPad;
    self.pswText.keyboardType = UIReturnKeySend;
    self.userText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.pswText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        
//        self.username = self.userText.text;
        //04142015  123456
        self.username = @"04151010";
        [self request:@"04151010" with:@"151010"];
//        [self request:self.userText.text with:self.pswText.text];
    }
    else if (buttonIndex == 0){
        
    }
}
#pragma mark - NetWork request

-(void)request:(NSString *)username with:(NSString *)password{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/user/login?username=%@&password=%@",username,password];
    NSString *codedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:codedString];
    
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager GET:codedString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
    
    
    
    
    
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        if(error == nil){
            NSDictionary *Info = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"info:%@",Info);
            NSString *res = [Info objectForKey:@"Result"];
            BOOL result = res.boolValue;
            if (result) {
                self.Session = [Info objectForKey:@"Detail"];
                [self performSelectorOnMainThread:@selector(afterLogin) withObject:self waitUntilDone:NO];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^(){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"学号或密码错误" message:nil delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                    [alertView show];
                });
            }
        }
    }];
    [dataTask resume];
}
-(void)requestMessage{
    NSString *urlStr = [NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/user/info?session=%@",self.Session];
    NSString *codedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:codedString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        if(error == nil){
            NSDictionary *Info = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            self.massage = [NSDictionary dictionaryWithDictionary:Info];
            NSLog(@"self.massgae:%@",self.massage);
            [self performSelectorOnMainThread:@selector(getdata) withObject:nil waitUntilDone:NO];
        }
    }];
    [dataTask resume];
}
-(void) getdata{
    self.dataModel.message = [NSDictionary dictionaryWithDictionary:self.massage];
    [self.dataModel dataAnalysis];
    [self.tableView reloadData];
}
#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else{
        return 3;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MYTableViewCell *cell = [[MYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.nameLabel.text = self.dataModel.nameStr;
        cell.classLabel.text = self.dataModel.classStr;
        self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.imageButton.frame = CGRectMake(10, 10, 65, 65);
        self.imageButton.clipsToBounds = YES;
        self.imageButton.layer.cornerRadius = 32.5;
        self.imageButton.backgroundColor = [UIColor blackColor];
        self.imageButton.backgroundColor = [UIColor whiteColor];
        [self.imageButton setBackgroundImage:[UIImage imageNamed:@"头像"] forState:UIControlStateNormal];
        [cell.contentView addSubview:self.imageButton];
        [self.imageButton addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ooooo"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ooooo"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        NSArray *image = [NSArray arrayWithObjects:@"书", @"收藏", @"浏览记录", nil];
        NSArray *text = [NSArray arrayWithObjects:@"我的借阅",@"我的收藏",@"我的足迹", nil];
        cell.imageView.image = [UIImage imageNamed:image[indexPath.row]];
        cell.textLabel.text = text[indexPath.row];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 85;
    }
    else{
        return 65;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD setBackgroundLayerColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD showWithStatus:@"Loading"];
    

    
    
    if(indexPath.section == 1){
        if(indexPath.row == 0){
            BorrowViewController *borrow = [[BorrowViewController alloc] init];
            borrow.session = self.Session;
            [self.navigationController pushViewController:borrow animated:YES];
        }
        if (indexPath.row == 1) {
            CollectViewController *collect = [[CollectViewController alloc] init];
            [self.navigationController pushViewController:collect animated:YES];
        }
        if (indexPath.row == 2) {
            HistoryViewController *history = [[HistoryViewController alloc] init];
            history.session = self.Session;
            [self.navigationController pushViewController:history animated:YES];
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - camare

-(void)chooseImage{
    UIImagePickerController *Ipc = [[UIImagePickerController alloc] init];
    Ipc.delegate = self;
    Ipc.allowsEditing = YES;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选取图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camaraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        Ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        Ipc.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:Ipc animated:YES completion:nil];
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        Ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:Ipc animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:camaraAction];
    [alert addAction:photoAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDeledate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imageButton setBackgroundImage:image forState:UIControlStateNormal];
//    SEL selectorToCall = @selector(image:didFinishSavingWithError:contextInfo:);
 //   UIImageWriteToSavedPhotosAlbum(image, self, selectorToCall, NULL);
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil) {
        NSLog(@"Image was saved successfully.");
    }else{
        NSLog(@"An error happened while saving the image.");
        NSLog(@"error:%@",error);
    }
}
@end
