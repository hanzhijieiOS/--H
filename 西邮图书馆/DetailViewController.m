//
//  DetailViewController.m
//  西邮图书馆
//
//  Created by Jay on 2017/2/7.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import "DetailViewController.h"
#import "TableViewCell.h"
#import "LabelTableViewCell.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

#import "DetailModel.h"

@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(nonatomic) UITableView *tableView;
@property(nonatomic,copy) NSString *url;
@property(nonatomic,strong) DetailModel *model;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[DetailModel alloc] init];
    
    NSNotification *Detail = [[NSNotification alloc] initWithName:@"DetailViewController" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:Detail];

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(getDetailSession:) name:@"Detail" object:nil];
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self getdata];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0||section == 2) {
        return 1;
    }else if (section == 1){
        return self.model.circulation.count;
    }else
        return self.model.referBooks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        TableViewCell *cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID1"];
        cell.IDLabel.text = [NSString stringWithFormat:@"检索号 : %@",self.model.sort];
        cell.writerLabel.text = [NSString stringWithFormat:@"作者 : %@",self.model.author];
        cell.homeLabel.text = [NSString stringWithFormat:@"出版社 : %@",self.model.publish];
        cell.borrowLabel.text = [NSString stringWithFormat:@"借阅次数 : %d次",self.model.avaliable];
        cell.collectLabel.text = [NSString stringWithFormat:@"收藏次数 : %d次",self.model.available];
        return cell;
    }else if(indexPath.section == 1){
        LabelTableViewCell *cell = [[LabelTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID2"];
        cell.numberLabel.text = [NSString stringWithFormat:@"条码 : %@",self.model.cirBarcode[indexPath.row]];
        cell.stateLabel.text = [NSString stringWithFormat:@"状态 : %@",self.model.cirStatus[indexPath.row]];
        cell.homeLabel.text = [NSString stringWithFormat:@"所在书库 : %@",self.model.cirDepartment[indexPath.row]];
        return cell;
    }else if(indexPath.section == 2){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID3"];
        if ([self.model.subject  isEqual: @""]) {
            cell.textLabel.text = @"暂无数据";
        }else{
            cell.textLabel.text = self.model.subject;
        }
        return cell;
    }else{
        LabelTableViewCell *cell = [[LabelTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID4"];
        cell.numberLabel.text = [NSString stringWithFormat:@"书名 : %@",self.model.referTitle[indexPath.row]];
        cell.stateLabel.text = [NSString stringWithFormat:@"作者 : %@",self.model.referAuthor[indexPath.row]];
        cell.homeLabel.text = [NSString stringWithFormat:@"索书号 : %@",self.model.referID[indexPath.row]];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 150;
    }else if (indexPath.section == 1){
        return 80;
    }else if (indexPath.section == 2){
        return 50;
    }else{
        return 80;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 360;
    }else if (section == 1){
        return 105;
    }else {
        return 55;
    }
}

#pragma mark - Web Request
-(void)getdata{
    if (self.type == 1) {
        NSLog(@"type = ID");
        NSString *urlStr = [NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/book/detail/id/%@",self.ID];
        self.url = [NSString stringWithString:urlStr];
    }else{
        NSLog(@"type =barcode");
        NSString *urlStr = [NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/book/detail/barcode/%@",self.barcode];
        self.url = [NSString stringWithString:urlStr];
    }
    NSString *codedString = [self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:codedString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *Detail= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if ([Detail rangeOfString:@"NO_RECORD"].location == NSNotFound) {
            self.model.result = [responseObject objectForKey:@"Detail"];
            NSLog(@"responseObject:%@",responseObject);
            [self.model analysis];
            [self.tableView reloadData];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"暂无数据" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@",error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"暂无数据" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view1 = [[UIView alloc] init];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width -200)/2, 10, 200, 260)];
        [view1 addSubview:imageView];
        imageView.backgroundColor = [UIColor grayColor];
//        NSLog(@"image:%@",self.model.image);
        
//        if (self.model.image) {
//            NSURL *imageURL = [NSURL URLWithString:self.model.image];
//            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//            imageView.image = [UIImage imageWithData:imageData];
//        }else{
            imageView.image = [UIImage imageNamed:@"NOimage"];
//        }
        UIButton *numButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [numButton setFrame:CGRectMake(10, 300, 35, 35)];
        numButton.clipsToBounds = YES;
        numButton.layer.cornerRadius = 17.5;
        numButton.backgroundColor = [UIColor colorWithRed:255.0/255 green:45.0/255 blue:44.0/255 alpha:1];
        [numButton setTitle:@"1" forState:UIControlStateNormal];
        [numButton.titleLabel setFont:[UIFont systemFontOfSize:25]];
        [numButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [collectButton setFrame:CGRectMake(180, 300, 35, 35)];
        [collectButton setBackgroundImage:[UIImage imageNamed:@"收藏按钮"] forState:UIControlStateNormal];
        [collectButton addTarget:self action:@selector(collectBook) forControlEvents:UIControlEventTouchUpInside];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(55, 300, 100, 35)];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(225, 300, 100, 35)];
        [label1 setFont:[UIFont systemFontOfSize:20]];
        [label2 setFont:[UIFont systemFontOfSize:20]];
        label1.text = @"书本详情";
        label2.text = @"收藏";
        [view1 addSubview:numButton];
        [view1 addSubview:collectButton];
        [view1 addSubview:label1];
        [view1 addSubview:label2];
        return view1;
    }else if (section == 1){
        UIView *headerView = [[UIView alloc] init];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(10, 5, 35, 35)];
        [button setBackgroundColor:[UIColor colorWithRed:255.0/255 green:45.0/255 blue:44.0/255 alpha:1]];
        button.clipsToBounds = YES;
        button.layer.cornerRadius = 17.5;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"2" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:25]];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 100, 35)];
        label1.text = @"流通情况";
        [label1 setFont:[UIFont systemFontOfSize:20]];
        
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, 300, 15)];
        label2.text = @"图书的流通情况如下:";
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 73, 300, 15)];
        label3.text = [NSString stringWithFormat:@"可借图书:%d本。     共有图书：%d本",self.model.avaliable,self.model.total];
        [headerView addSubview:button];
        [headerView addSubview:label1];
        [headerView addSubview:label2];
        [headerView addSubview:label3];
        return headerView;
    }else{
        UIView *headerView = [[UIView alloc] init];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(5, 0, 35, 35)];
        [button setBackgroundColor:[UIColor colorWithRed:255.0/255 green:45.0/255 blue:44.0/255 alpha:1]];
        button.clipsToBounds = YES;
        button.layer.cornerRadius = 17.5;
        [button setTitle:[NSString stringWithFormat:@"%ld",(long)section +1] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:25]];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, 35)];
        if (section == 3) {
            label.text = @"图书主题";
        }else{
            label.text = @"相关推荐";
        }
        [label setFont:[UIFont systemFontOfSize:20]];
        [headerView addSubview:label];
        [headerView addSubview:button];
        return headerView;
    }
}

- (void)collectBook{
    if (!self.session) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"收藏失败" message:@"提示：未登录（如已登录请尝试重新登录）" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        NSLog(@"session:%@,ID:%@",self.session,self.ID);
    }else if (self.type == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"收藏失败" message:@"暂时无法收藏" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else{
        NSString *urlstr = [NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/user/addFav?session=%@&id=%@",self.session,self.ID];
        NSLog(@"session:%@,ID:%@",self.session,self.ID);
        NSString *codeStr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *URL = [NSURL URLWithString:codeStr];
        NSURLRequest *request= [NSURLRequest requestWithURL:URL];
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                NSLog(@"info:%@",info);
                NSString *result = [info objectForKey:@"Detail"];
                if ([result isEqualToString:@"ADDED_SUCCEED"]) {
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        [self addedSecceed];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        [self addedFailed:result];
                    });
                }
            }
        }];
        [dataTask resume];
    }
}
- (void)addedSecceed{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加成功!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}
- (void)addedFailed:(NSString *)reason{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加失败!" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    if ([reason isEqualToString:@"ALREADY_IN_FAVORITE"]) {
        alertView.message = @"请不要重复收藏!";
    }else{
        alertView.message = nil;
    }
    [alertView show];
}

- (void)getDetailSession:(NSNotification *)notification{
    self.session = [notification object];
    NSLog(@"self.session:%@",self.session);
}
@end
