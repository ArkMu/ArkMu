//
//  InfoVC.m
//  ArkMu
//
//  Created by Sky on 2018/5/6.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "InfoVC.h"

#import "InfoModel.h"

#import "Common.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>

@interface InfoVC () <UIWebViewDelegate>

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, strong) InfoModel *infoModel;

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation InfoVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - Controller Method

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = AKClearColor;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, AKScreenWidth, AKScreenHeight - 64)];
    webView.backgroundColor = AKClearColor;
    webView.delegate = self;
    [self.view addSubview:webView];
    _webView = webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(infoVCBackItemAction)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", nil];
    
    [self infoVCLoadInfoFromNetwork];
}

#pragma mark - UINavigationItemAction

- (void)infoVCBackItemAction {
    [SVProgressHUD dismiss];
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)infoVCLoadInfoFromNetwork {
    [SVProgressHUD show];
    [_manager GET:AKPostUrlWithInfoId(self.infoId) parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *infoDict = [responseObject valueForKey:@"data"];
        self.infoModel = [InfoModel modelWithDictionary:infoDict];
        
        [self infoVCLoadMessage];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        
        [SVProgressHUD showWithStatus:@"Message Load Failed!"];
    }];
}

- (void)infoVCLoadMessage {
    [_webView loadHTMLString:_infoModel.content baseURL:nil];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *js = @"function imgAutoFit() { var imgs = document.getElementsByTagName('img'); for (var i = 0; i < imgs.length; ++i) { var img = imgs[i]; img.style.maxWidth = %f;} }";

    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - 20];

    [_webView stringByEvaluatingJavaScriptFromString:js];
    [_webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    
    [SVProgressHUD dismiss];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
