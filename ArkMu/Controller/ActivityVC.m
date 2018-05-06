//
//  ActivityVC.m
//  ArkMu
//
//  Created by Sky on 2018/5/6.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "ActivityVC.h"

#import "Common.h"
#import "AFShareManager.h"
#import <SVProgressHUD.h>

#import "ActivityModel.h"
#import "ActivityCell.h"

#import "WebViewVC.h"

static NSString *ActivityCellIdentifier = @"ActivityCellIdentifier";

@interface ActivityVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ActivityVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - Controller Method

- (void)loadView {
    [super loadView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, AKScreenWidth, AKScreenHeight - 64) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[ActivityCell class] forCellReuseIdentifier:ActivityCellIdentifier];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(activityVCBackItemAction:)];
    backItem.imageInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.navigationItem.title = @"活动中心";
    
    [self activityVCLoadMessageFromNetwork];
    [SVProgressHUD show];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - UINavigationItemAction

- (void)activityVCBackItemAction:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Custom Method

- (void)activityVCLoadMessageFromNetwork {
    AFShareManager *manager = [AFShareManager shareManager];
    
    [manager.sessionManager GET:AKActivityUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dataDict = [responseObject valueForKey:@"data"];
        NSArray *itemsArr = [dataDict valueForKey:@"items"];
        
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *dict in itemsArr) {
            ActivityModel *model = [ActivityModel modelWithDictionary:dict];
            [mArr addObject:model];
        }
        
        self.datasArr = mArr;
        
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, AKScreenWidth, 0)];
    return label;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, AKScreenWidth, 0)];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (AKScreenWidth - 28) / 800 * 450 + 21 + 28 + 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[ActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ActivityCellIdentifier];
    }
    
    ActivityModel *model = self.datasArr[indexPath.row];
    cell.activityModel = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ActivityModel *model = self.datasArr[indexPath.row];
    WebViewVC *webViewVC = [[WebViewVC alloc] init];
    webViewVC.urlStr = model.url;
    [self.navigationController pushViewController:webViewVC animated:NO];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
