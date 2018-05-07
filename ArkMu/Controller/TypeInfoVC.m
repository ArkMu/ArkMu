//
//  TypeInfoVC.m
//  ArkMu
//
//  Created by Sky on 2018/5/6.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "TypeInfoVC.h"

#import "Common.h"
#import "AFShareManager.h"
#import <SVProgressHUD.h>

#import "EntityModel.h"
#import "SmallImageCell.h"

#import "InfoVC.h"

static NSString *SmallImageCellIdentifier = @"SmallImageCellIdentifier";

@interface TypeInfoVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TypeInfoVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - Controller Method

- (void)loadView {
    [super loadView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, AKScreenWidth, AKScreenHeight - 64) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[SmallImageCell class] forCellReuseIdentifier:SmallImageCellIdentifier];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(typeInfoVCBackItemAction)];
    backItem.imageInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self typeInfoVCLoadMessageFromNetwork];
}

#pragma mark - UINavigationItemAction

- (void)typeInfoVCBackItemAction {
    [SVProgressHUD dismiss];
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Custom Method

- (void)typeInfoVCLoadMessageFromNetwork {
    [SVProgressHUD show];
    
    AFShareManager *manager = [AFShareManager shareManager];
    
    NSDictionary *parameter = @{@"per_page": @20};
    
    [manager.sessionManager GET:AKAlbumEntityUrlWithEntityId(self.entityId) parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *itemsArr = [[responseObject valueForKey:@"data"] valueForKey:@"items"];
        
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *dict in itemsArr) {
            EntityModel *model = [EntityModel modelWithDictionary:dict];
            [mArr addObject:model];
        }
        
        self.datasArr = mArr;
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        
        [SVProgressHUD showWithStatus:@"Message Load Failed!"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, AKScreenWidth, 0)];
    return label;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, AKScreenWidth, 0)];
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SmallImageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SmallImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SmallImageCellIdentifier];
    }
    
    EntityModel *model = self.datasArr[indexPath.row];
    cell.entityModel = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    EntityModel *model = self.datasArr[indexPath.row];
    
    InfoVC *infoVC = [[InfoVC alloc] init];
    infoVC.infoId = model.entityId;
    [self.navigationController pushViewController:infoVC animated:NO];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
