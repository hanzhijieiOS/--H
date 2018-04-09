//
//  BorrowViewController.m
//  西邮图书馆
//
//  Created by 韩智杰 on 16/12/13.
//  Copyright (c) 2016年 韩智杰. All rights reserved.
//

#import "BorrowViewController.h"
#import "BorrowModel.h"
#import "BorrowTableViewCell.h"
#import "DetailViewController.h"
#import "SVProgressAnimatedView.h"
#import "SVProgressHUD.h"

@interface BorrowViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic) BorrowModel *dataModel;
@end

@implementation BorrowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的借阅";
    self.dataModel = [[BorrowModel alloc] init];
    [self initTableView];
    [self getdata];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
//    [SVProgressHUD setBackgroundLayerColor:[UIColor whiteColor]];
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
//    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
//    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
//    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
//    [SVProgressHUD show];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footView;
    [self.view addSubview:self.tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataModel.Title.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BorrowTableViewCell *cell = [[BorrowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
    if (!cell) {
        cell = [[BorrowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
    }
    NSString *canrenew = self.dataModel.canRenew[indexPath.row];
    if (canrenew.boolValue == 0) {
        [cell.renewButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cell.renewButton addTarget:self action:@selector(cannotRenewBook) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.renewButton.tag = indexPath.row;
    [cell.renewButton addTarget:self action:@selector(renewBook:) forControlEvents:UIControlEventTouchUpInside];
    cell.titleLabel.text = self.dataModel.Title[indexPath.row];
    cell.stateLabel.text = [NSString stringWithFormat:@"当前状态: %@",self.dataModel.State[indexPath.row]];
    cell.dateLabel.text = [NSString stringWithFormat:@"应还日期: %@",self.dataModel.Date[indexPath.row]];
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.barcode = [NSString stringWithString:self.dataModel.Barcode[indexPath.row]];
    vc.type = 0;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)cannotRenewBook{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"续租失败" message:@"提示：本书无法续租！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)renewBook:(UIButton*)button{
    UITableViewCell *cell = (UITableViewCell *)[[button superview] superview];
    NSIndexPath *cellPath = [self.tableView indexPathForCell:cell];
    NSInteger index = cellPath.row;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    if (self.dataModel.canRenew[index] == 0) {
    }
    else{
        NSString *urlStr = [NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/user/renew?session=%@&barcode=%@&department_id=%@&library_id=%@",self.session,self.dataModel.Barcode[index],self.dataModel.Department_id[index],self.dataModel.Library_id[index]];
        NSString *codedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL * url = [NSURL URLWithString:codedString];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
            if(error == nil){
                NSDictionary *Info = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                NSString *Newdate = [Info objectForKey:@"Detail"];
                NSString *result = [Info objectForKey:@"Result"];
                if (result.boolValue) {
                    dispatch_sync(dispatch_get_main_queue(), ^(){
                        alert.title = @"续租成功!";
                        alert.message = [NSString stringWithFormat:@"提示：续租至%@",Newdate];
                        [alert show];
                        self.dataModel.Date[index] = Newdate;
                        self.dataModel.canRenew[index] = @"0";
                        [self.tableView reloadData];
                });
                }
            }
        }];
        [dataTask resume];
    }
}

- (void)getdata{
    NSString *urlStr = [NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/user/rent?session=%@",self.session];
    NSString *codedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:codedString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        if(error == nil){
            NSDictionary *Info = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            self.resource = [NSDictionary dictionaryWithDictionary:Info];
            NSLog(@"info:%@",Info);
            if ([[Info objectForKey:@"Detail"] isKindOfClass:[NSString class]]) {
                dispatch_async(dispatch_get_main_queue(), ^(){
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                    imageView.image = [UIImage imageNamed:@"background"];
                    [self.view addSubview:imageView];
                    [SVProgressHUD showSuccessWithStatus:@"加载成功!"];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^(){
                    [self analysis];
                    [SVProgressHUD showSuccessWithStatus:@"加载成功!"];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^(){
                [SVProgressHUD showErrorWithStatus:@"加载失败!"];
            });

        }
        [SVProgressHUD dismissWithDelay:0.5f];
    }];
    [dataTask resume];
}
-(void)analysis{
    self.dataModel.recourse = self.resource;
    [self.dataModel dataAnalysis];
    [self.tableView reloadData];
};


@end
