//
//  HZJmainViewController.m
//  西邮图书馆
//
//  Created by 韩智杰 on 16/11/15.
//  Copyright (c) 2016年 韩智杰. All rights reserved.
//

#import "HZJmainViewController.h"
#import "NewsTableViewCell.h"
#import "NewsAnnounceViewController.h"
#import "SearchViewController.h"
#import "NewsModel.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MJRefreshHeader.h"
#import "MJRefreshComponent.h"
#import "SVProgressHUD.h"

@interface HZJmainViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UISegmentedControl *segmented;
@property(nonatomic,strong) NSMutableURLRequest *request;
@property(nonatomic) NewsModel *model;
@property(nonatomic,copy) NSString *newsFilePath;
@property(nonatomic,copy) NSString *announceFilePath;
@end

@implementation HZJmainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[NewsModel alloc] init];
    [self getRequest];
    [self makeUI];
}

#pragma mark - UI
-(void)makeUI{
    self.tabBarController.tabBar.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"首页";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255.0/255 green:45.0/255 blue:44.0/255 alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor:[UIColor whiteColor],UITextAttributeFont:[UIFont boldSystemFontOfSize:21]};
    UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStyleDone target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem = search;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.origin.y+35, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-35)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

    
    [self.view addSubview:self.tableView];
    
    NSArray* segmenteArray = [[NSArray alloc]initWithObjects:@"公告",@"新闻", nil];
    self.segmented = [[UISegmentedControl alloc]initWithItems:segmenteArray];
    self.segmented.frame = CGRectMake(0, 60, self.view.bounds.size.width, 40);
    self.segmented.selectedSegmentIndex = 0;
    [self.segmented setTintColor:[UIColor blackColor]];
    [self.segmented setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmented setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.segmented setDividerImage:[UIImage imageNamed:@"whiteline"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:15],NSFontAttributeName, nil];
    [self.segmented setTitleTextAttributes:dic forState:UIControlStateNormal];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255.0/255 green:45.0/255 blue:44.0/255 alpha:1],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:17],NSFontAttributeName, nil];
    [self.segmented setTitleTextAttributes:dic1 forState:UIControlStateSelected];
    [self.view addSubview:self.segmented];
    [self.segmented addTarget:self action:@selector(getRequest) forControlEvents:UIControlEventValueChanged];
}
-(void) loadNewData{
    NSString *type = [[NSString alloc] init];
    if(self.segmented.selectedSegmentIndex == 0){
        type = @"announce";
    }
    else{
        type = @"news";
    }
    NSString *urlStr = [NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/news/getList/%@/1",type];
    NSString *codedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:codedString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.model = [NewsModel yy_modelWithJSON:responseObject];
        [self.tableView reloadData];
        self.dic = [NSDictionary dictionaryWithDictionary:responseObject];
        [self analysis];
        if ([type isEqualToString:@"announce"]) {
            NSLog(@"______announce缓存");
            [self writeLocalCachesData:responseObject with:@"announceData.txt"];
        }else{
            NSLog(@"_____news缓存");
            [self writeLocalCachesData:responseObject with:@"newsData.txt"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    [self.tableView.header beginRefreshing];
    [self.tableView.header endRefreshing];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   if(self.segmented.selectedSegmentIndex == 0){
        return self.model.announceDate.count;
    }
    else{
        return self.model.titleArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsTableViewCell *cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    NSString *text;
    if(self.segmented.selectedSegmentIndex == 1){
        text = [NSString stringWithFormat:@"%@  %@",self.model.titleArray[indexPath.row],self.model.dateArray[indexPath.row]];
    }
    else{
        text = [NSString stringWithFormat:@"%@  %@",self.model.announceTitle[indexPath.row],self.model.announceDate[indexPath.row]];
    }
    cell.label.text = text;
    CGRect cellFrame = [cell frame];
    cellFrame.origin = CGPointMake(30, 0);
    CGRect rect = CGRectInset(cellFrame, 2, 2);
    cell.label.frame = rect;
    [cell.label sizeToFit];
    if(cell.label.frame.size.height > 25){
        cellFrame.size.height = 4 + cell.label.frame.size.height;
    }
    else{
        cellFrame.size.height = 29;
    }
    [cell setFrame:cellFrame];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsAnnounceViewController *vc = [[NewsAnnounceViewController alloc] init];
    if (self.segmented.selectedSegmentIndex == 0) {
        vc.type = @"announce";
        vc.ID = self.model.announceID[indexPath.row];
        
    }
    else{
        vc.type = @"news";
        vc.ID = self.model.IDArray[indexPath.row];
    }
    [self.navigationController pushViewController:vc animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - request

-(void)getRequest{
    NSString *type = [[NSString alloc] init];
    if(self.segmented.selectedSegmentIndex == 0){
        type = @"announce";
        if ((self.dic = [self readLocalCacheDataWithKey:@"announceData.txt"])) {
            NSLog(@"有缓存");
            [self analysis];
            return;
        }
    }
    else{
        type = @"news";
        if ((self.dic = [self readLocalCacheDataWithKey:@"newsData.txt"])) {
            NSLog(@"有缓存");
            [self analysis];
            return;
        }
    }
    NSString *urlStr = [NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/news/getList/%@/1",type];
    NSString *codedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:codedString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.model = [NewsModel yy_modelWithJSON:responseObject];
        [self.tableView reloadData];
        self.dic = [NSDictionary dictionaryWithDictionary:responseObject];
        [self analysis];
        
        
        if ([type isEqualToString:@"announce"]) {
            [self writeLocalCachesData:responseObject with:@"announceData.txt"];

        }else{
            [self writeLocalCachesData:responseObject with:@"newsData.txt"];

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
    }];
}


-(void)analysis{
    self.model.resource = [NSDictionary dictionaryWithDictionary:self.dic];
    
    if(self.segmented.selectedSegmentIndex == 1){
        [self.model newsDataAnalysis];
    }
    else{
        [self.model anounceDataAnalysis];
    }
    [self.tableView reloadData];

}
-(void)search{
    SearchViewController *vc = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

# pragma mark - 数据缓存

-(void)writeLocalCachesData:(NSDictionary *)dic with:(NSString *)key{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
                            stringByAppendingPathComponent:key];
    if([dic writeToFile:cachesPath atomically:YES]){
        NSLog(@"存入成功!");
    }
}

- (NSDictionary *)readLocalCacheDataWithKey:(NSString *)key {
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
                            stringByAppendingPathComponent:key];
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachesPath]) {
        return [NSDictionary dictionaryWithContentsOfFile:cachesPath];
    }
    return nil;
}
@end
