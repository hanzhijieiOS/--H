//
//  ResourceViewController.m
//  西邮图书馆
//
//  Created by Jay on 2017/2/3.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import "ResourceViewController.h"
#import "SearchTableViewCell.h"
#import "Searchmodel.h"
#import "DetailViewController.h"

@interface ResourceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic) Searchmodel *searchModel;
@property(nonatomic,strong) UITableView *tableView;

@end

@implementation ResourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.keyWord;
    self.searchModel = [[Searchmodel alloc] init];
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self getData:self.keyWord];
}

-(void)getData:(NSString *)keyWord{
    NSString *urlStr = [NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/book/search?keyword=%@&matchMethod=mh&orderby=title&size=30&image=1",keyWord];
    NSString *codedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:codedString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        if(error == nil){
            NSDictionary *Info = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"info:%@",Info);
            self.searchModel.resource = [Info objectForKey:@"Detail"];
            NSData *data = [NSJSONSerialization dataWithJSONObject:Info options:NSJSONWritingPrettyPrinted error:nil];
            NSString *Detail= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if ([Detail rangeOfString:@"NO_RECORD"].location == NSNotFound) {
                dispatch_async(dispatch_get_main_queue(), ^(){
                    [self showData];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                    imageView.image = [UIImage imageNamed:@"background"];
                    [self.view addSubview:imageView];
                });
            }
        }
    }];
    [dataTask resume];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showData{
    [self.searchModel analysis];
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchModel.bookName.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchTableViewCell *cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    cell.textLabel.text = self.searchModel.bookName[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *vc = [[DetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.ID = self.searchModel.ID[indexPath.row];
    vc.type = 1;
//    vc.ID = self.searchModel.Sort[indexPath.row];
//    vc.ID = self.searchModel.ISBN[indexPath.row];

}
@end
