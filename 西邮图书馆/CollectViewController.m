//
//  CollectViewController.m
//  西邮图书馆
//
//  Created by 韩智杰 on 16/12/13.
//  Copyright (c) 2016年 韩智杰. All rights reserved.
//

#import "CollectViewController.h"
#import "CollectTableViewCell.h"
#import "CollectModel.h"
#import "DetailViewController.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"

@interface CollectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSDictionary *recourse;
@property(nonatomic) CollectModel *dataModel;
@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    self.dataModel = [[CollectModel alloc] init];
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footView;
    [self.view addSubview:self.tableView];
    [self getdata];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getdata{
    NSString *urlStr = [NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/user/favoriteWithImg?session=%@",self.session];
    NSString *codedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:codedString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.recourse = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[self.recourse objectForKey:@"Detail"] isKindOfClass:[NSArray class]]) {
            [self analysis];
        }else{
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            imageView.image = [UIImage imageNamed:@"background"];
            [self.view addSubview:imageView];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求错误！");
    }];
}
-(void)analysis{
    self.dataModel.resource = [NSDictionary dictionaryWithDictionary:self.recourse];
    [self.dataModel dataAnalysis];
    if (self.dataModel.titleArray.count != 0) {
        [self.tableView reloadData];
    }
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataModel.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"identifier";
    CollectTableViewCell *cell = [[CollectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    if (!cell) {
        cell = [[CollectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.titleLabel.text = self.dataModel.titleArray[indexPath.row];
    cell.authorLabel.text = self.dataModel.authorArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.ID = self.dataModel.IDArray[indexPath.row];
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
