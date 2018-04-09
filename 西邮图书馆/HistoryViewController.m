//
//  HistoryViewController.m
//  西邮图书馆
//
//  Created by 韩智杰 on 16/12/13.
//  Copyright (c) 2016年 韩智杰. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistroyModel.h"
#import "HistroyTableViewCell.h"
#import "DetailViewController.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

@interface HistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSDictionary *resource;
@property(nonatomic) HistroyModel *dataModel;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的足迹";
    self.dataModel = [[HistroyModel alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTableView];
    [self getdata];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView

-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView.rowHeight = 100;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataModel.Barcode.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"identifier";
    HistroyTableViewCell *cell = [[HistroyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    if (!cell) {
        cell = [[HistroyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.titleLabel.text =[NSString stringWithFormat:@"书   名：%@",self.dataModel.Title[indexPath.row]];
    cell.typeLabel.text = [NSString stringWithFormat:@"操作类型：%@",self.dataModel.Type[indexPath.row]];
    cell.dateLabel.text = [NSString stringWithFormat:@"操作类型：%@",self.dataModel.Date[indexPath.row]];
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.barcode = self.dataModel.Barcode[indexPath.row];
    vc.type = 0;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - NetWork request

-(void)getdata{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/user/history?session=%@",self.session];
    NSString *codedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:codedString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"Detail"] isKindOfClass:[NSArray class]]) {
            self.resource = [NSDictionary dictionaryWithDictionary:responseObject];
            [self analysis];
        }else{
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            imageView.image = [UIImage imageNamed:@"background"];
            [self.view addSubview:imageView];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求错误");
    }];
}

-(void)analysis{
    self.dataModel.resource = [NSDictionary dictionaryWithDictionary:self.resource];
    [self.dataModel dataAnalysis];
    [self.tableView reloadData];
}
@end
