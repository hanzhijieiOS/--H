//
//  NewsAnnounceViewController.m
//  西邮图书馆
//
//  Created by Jay on 2017/1/24.
//  Copyright © 2017年 韩智杰. All rights reserved.
//

#import "NewsAnnounceViewController.h"
#import <WebKit/WebKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"


@interface NewsAnnounceViewController ()<WKNavigationDelegate>
@property(nonatomic,strong) WKWebView *webView;
@property(nonatomic,strong)NSDictionary *recourse;
@property (nonatomic, strong) UIView * headView;
@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation NewsAnnounceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, -200, self.view.frame.size.width, 200)];
    _headView.backgroundColor = [UIColor yellowColor];
    
    UILabel * dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 50)];
    dateLabel.text = @"dateLabel";
    UILabel * publisherLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 100, 50)];
    publisherLabel.text = @"publisherLabel";
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 100, 50)];
    titleLabel.text = @"titleLabel";
    
    [_headView addSubview:dateLabel];
    [_headView addSubview:publisherLabel];
    [_headView addSubview:titleLabel];
    
    [_webView.scrollView addSubview:_headView];
    _webView.scrollView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    [self getData:self.type with:self.ID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getData:(NSString *)type with:(NSString *)ID{
    NSLog(@"type:%@,id:%@:",type,ID);
    NSString *urlString = [NSString stringWithFormat:@"http://api.xiyoumobile.com/xiyoulibv2/news/getDetail/%@/html/%@",type,ID];
    NSString *codedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:codedString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.f];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error == nil){
            self.recourse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            self.recourse = [self.recourse objectForKey:@"Detail"];
            NSLog(@"%@",self.recourse);
            [self performSelectorOnMainThread:@selector(loadData) withObject:nil waitUntilDone:NO];
        }
    }];
    [dataTask resume];
}

-(void)loadData{
//    NSLog(@"%@",self.recourse);
    __block NSString * content = [self.recourse objectForKey:@"Passage"];
//    NSString * date = self.recourse[@"Date"];
//    NSString * publisher = self.recourse[@"Publisher"];
//    NSString * title = self.recourse[@"Title"];
    NSRegularExpression * regEX = [NSRegularExpression regularExpressionWithPattern:@"<img(.*?)>" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray * resultArray = [regEX matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, content.length)];
    if (!resultArray.count) {
        [self.webView loadHTMLString:content baseURL:nil];
    }
    NSMutableDictionary *urlDicts = [[NSMutableDictionary alloc] init];
    NSString *docPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"badge"];
    [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
    for (NSTextCheckingResult * item in resultArray) {
        NSString * imgH5 = [content substringWithRange:[item rangeAtIndex:0]];
        NSArray * tmpArray = nil;
        if ([imgH5 rangeOfString:@"src=\""].location != NSNotFound ) {
            tmpArray = [imgH5 componentsSeparatedByString:@"src=\""];
        }else if([imgH5 componentsSeparatedByString:@"src="]){
            tmpArray = [imgH5 componentsSeparatedByString:@"src="];
        }
        if (tmpArray.count >= 2) {
            NSString * src = tmpArray[1];
            NSUInteger loc = [src rangeOfString:@"\""].location;
            if (loc != NSNotFound) {
                src = [src substringToIndex:loc];
                NSLog(@"正确解析出来的SRC为：%@", src);
                if (src.length > 0) {
                    NSString * localPath = [docPath stringByAppendingPathComponent:[self md5:src]];
                    [urlDicts setObject:localPath forKey:src];
                }
            }
        }
    }
    dispatch_queue_t queue = dispatch_queue_create("com.XiYouLib.HZJ", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    for (NSString * URL in urlDicts.allKeys) {
        __block NSString * jpg = nil;
        NSString * localPath = urlDicts[URL];
        if (![[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
            dispatch_group_async(group, queue, ^{
                [self downloadImageWithUrl:URL complete:^(NSString *location) {
                    UIImage *_image = [UIImage imageWithContentsOfFile:localPath];
                    jpg = [self htmlForJPGImage:_image];
                    content = [content stringByReplacingOccurrencesOfString:URL withString:jpg];
                } errorHandler:^{
                    
                }];
            });
        }else{
            
        }
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.webView loadHTMLString:content baseURL:nil];
    });
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self addImgClick];
    NSLog(@"OK");
}

- (void)addImgClick{
    [self.webView evaluateJavaScript:@"\
     function registerImageClickAction(){\
         var imgs = document.getElementsByTagName('img');\
         for(var i = 0; i < imgs.length; i ++){\
             imgs[i].customIndex = i;\
             imgs[i].onclick = function(){\
                 window.location.href = ''+this.src;\
             }\
         }\
     }" completionHandler:nil];
    [self.webView evaluateJavaScript:@"registerImageClickAction();" completionHandler:nil];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString * path = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    if ([path isEqualToString:@"about:blank"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        if ([path hasSuffix:@".png"] || [path hasSuffix:@".jpg"] || [path hasSuffix:@".jpeg"]) {
            NSLog(@"*************->>%@",path);
            NSLog(@"王德法小朋友");
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)downloadImageWithUrl:(NSString *)src complete:(void (^)(NSString * location)) completionHandler errorHandler:(void (^)()) errorBlock{
    UIImageView *imgView = [[UIImageView alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:src]];
    [imgView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        NSData *data = UIImagePNGRepresentation(image);
        NSString *docPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"badge"];
        [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *localPath = [docPath stringByAppendingPathComponent:[self md5:src]];
        if (![data writeToFile:localPath atomically:NO]) {
            NSLog(@"写入本地失败：%@", src);
        }else{
            NSLog(@"写入本地成功");
        }
        completionHandler(localPath);
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        errorBlock();
        NSLog(@"download image url fail: %@", src);
    }];
    
    if (self.imageViews == nil) {
        self.imageViews = [[NSMutableArray alloc] init];
    }
    [self.imageViews addObject:imgView];
}

- (NSString *)md5:(NSString *)sourceContent {
    if (self == nil || [sourceContent length] == 0) {
        return nil;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([sourceContent UTF8String], (int)[sourceContent lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    return [ms copy];
}

- (NSString *)htmlForJPGImage:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    NSString *imageSource = [NSString stringWithFormat:@"data:image/jpg;base64,%@",[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    return imageSource;
}

@end
