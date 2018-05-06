//
//  WebViewVC.m
//  ArkMu
//
//  Created by Sky on 2018/5/6.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "WebViewVC.h"

#import "Common.h"
#import <SVProgressHUD.h>

@interface WebViewVC () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WebViewVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - Controller Method

- (void)loadView {
    [super loadView];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, AKScreenWidth, AKScreenHeight - 64)];
    webView.delegate = self;
    [self.view addSubview:webView];
    _webView = webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(webViewVCBackItemAction:)];
    backItem.imageInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    self.navigationItem.leftBarButtonItem = backItem;
    
    NSURL *url = [NSURL URLWithString:_urlStr];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [SVProgressHUD show];
}

#pragma mark - UINavigationItemAction

- (void)webViewVCBackItemAction:(UIBarButtonItem *)item {
    [SVProgressHUD dismiss];
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
