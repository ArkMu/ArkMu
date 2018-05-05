//
//  WebViewVC.m
//  ArkMu
//
//  Created by Sky on 2018/5/5.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "WebViewVC.h"

#import "Common.h"

#import <WebKit/WebKit.h>

#import <AFNetworking.h>

@interface WebViewVC () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WebViewVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - Controller Method

- (void)loadView {
    [super loadView];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, AKScreenWidth, AKScreenHeight - 64) configuration:configuration];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    
    webView.layer.borderColor = [UIColor redColor].CGColor;
    webView.layer.borderWidth = 1.f;
    
    _webView = webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:self.urlStr];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
