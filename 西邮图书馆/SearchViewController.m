//
//  SearchViewController.m
//  西邮图书馆
//
//  Created by Jay on 2017/1/27.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import "SearchViewController.h"
#import "Searchmodel.h"
#import "Resource.h"
#import "SearchTableViewCell.h"
#import "ResourceViewController.h"

@interface SearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic) UISearchBar *searchBar;
@property(nonatomic) Resource *resourceModel;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic) UILabel *textLabel;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, 375, 40)];
    self.searchBar.placeholder = @"输入关键字";
    [self.searchBar setShowsCancelButton:YES animated:YES];
    self.searchBar.delegate = self;
    
    [self.view addSubview:self.searchBar];
    [self getRankData];
    self.resourceModel = [[Resource alloc] init];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, self.view.bounds.size.width, 60)];
    self.textLabel.text = @"大家都在搜";
    self.textLabel.textColor = [UIColor blueColor];
    self.textLabel.textAlignment = UITextAlignmentCenter;
    self.textLabel.font = [UIFont systemFontOfSize:25];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, 375, 360)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.textLabel;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    if(touchPoint.y > 104 && touchPoint.y < 419){
        [self.searchBar resignFirstResponder];
    }
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    ResourceViewController *vc = [[ResourceViewController alloc] init];
    vc.keyWord = self.searchBar.text;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)getRankData{
    NSString *urlStr = [NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/book/rank?type=2"];
    NSString *codedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:codedString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        if(error == nil){
            NSDictionary *Info = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            self.resourceModel.rank = [NSDictionary dictionaryWithDictionary:Info];
            [self performSelectorOnMainThread:@selector(analysisData) withObject:nil waitUntilDone:NO];
        }
    }];
    [dataTask resume];
}
-(void)analysisData{
    [self.resourceModel showRank];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchTableViewCell *cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rus"];
    cell.textLabel.text = self.resourceModel.rankTitle[indexPath.row + 1];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ResourceViewController *vc = [[ResourceViewController alloc] init];
    vc.keyWord = self.resourceModel.rankTitle[indexPath.row + 1];
    [self.navigationController pushViewController:vc animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
