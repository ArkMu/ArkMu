//
//  VideoVC.m
//  ArkMu
//
//  Created by Sky on 2018/5/6.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "VideoVC.h"

#import "Common.h"
#import "AFShareManager.h"

#import "VideoView.h"
#import "VideoModel.h"

@interface VideoVC ()

@property (nonatomic, strong) VideoView *videoView;

@end

@implementation VideoVC

#pragma mark - Controller Method

- (void)loadView {
    [super loadView];
    
    VideoView *videoView = [[VideoView alloc] initWithFrame:CGRectMake(0, 64, AKScreenWidth, 200)];
    [self.view addSubview:videoView];
    self.videoView = videoView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(videoVCBackItemAction:)];
    backItem.imageInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self videoVCLoadMessageFromNetwork];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.videoView setPlayerNil];
}

#pragma mark - UINavigationItemAction

- (void)videoVCBackItemAction:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Custom Method

- (void)videoVCLoadMessageFromNetwork {
    AFShareManager *manager = [AFShareManager shareManager];
    [manager.sessionManager GET:AKVideoUrlWithVideoId(self.videoId) parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [responseObject valueForKey:@"data"];
        
        VideoModel *model = [VideoModel modelWithDictionary:dict];
        [self.videoView loadVideoWithUrl:model.url];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
