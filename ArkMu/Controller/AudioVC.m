//
//  AudioVC.m
//  ArkMu
//
//  Created by Sky on 2018/5/6.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "AudioVC.h"

#import "Common.h"
#import "AFShareManager.h"

@interface AudioVC ()

@end

@implementation AudioVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - Controller Method

- (void)loadView {
    [super loadView];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    [self.view addSubview:imgView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = AKWhiteColor;
    titleLabel.font = AKCustomFont(17.0);
    [self.view addSubview:titleLabel];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(audioVCBackItemAction:)];
    backItem.imageInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    self.navigationItem.leftBarButtonItem = backItem;
    
    
}

#pragma mark - UINavigationItemAction

- (void)audioVCBackItemAction:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
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
