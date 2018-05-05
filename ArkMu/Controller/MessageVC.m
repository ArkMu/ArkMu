//
//  MessageVC.m
//  ArkMu
//
//  Created by Sky on 2018/5/4.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "MessageVC.h"

#import "Common.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import <SVProgressHUD.h>
#import "Reachability.h"

#import "StreamModel.h"

#import "PostCell.h"
#import "MonoGraphicCell.h"
#import "NewFlashCell.h"
#import "AlbumCell.h"

#import "FeedModel.h"
#import "FeedCell.h"

static NSString *PostCellIdentifier = @"PostCellIdetifier";
static NSString *MonoGraphicCellIdentifier = @"MonoGraphicCellIdentifier";
static NSString *NewFlashCellIdentifier = @"NewFlashCellIdentifier";
static NSString *ThemeCellIdentifier = @"ThemeCellIdentifier";

@interface MessageVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *feedArr;

@end

@implementation MessageVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - Controller Method

- (void)loadView {
    [super loadView];
    
    self.title = @"messageVC";
    self.view.backgroundColor = AKClearColor;
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, frame.size.width, frame.size.height - 64) style:UITableViewStyleGrouped];
    tableView.backgroundColor = AKClearColor;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellStyleDefault;
    [tableView registerClass:[PostCell class] forCellReuseIdentifier:PostCellIdentifier];
    [tableView registerClass:[MonoGraphicCell class] forCellReuseIdentifier:MonoGraphicCellIdentifier];
    [tableView registerClass:[NewFlashCell class] forCellReuseIdentifier:NewFlashCellIdentifier];
    [tableView registerClass:[AlbumCell class] forCellReuseIdentifier:ThemeCellIdentifier];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf arkMuLoadDataFromServerWithBId:0 state:YES];
    }];
    [_tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if ([reach currentReachabilityStatus]) {
        __weak typeof(self) weakSelf = self;
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSInteger bid = 0;
            if (strongSelf.dataArr.count > 0) {
                StreamModel *model = (StreamModel *)strongSelf.dataArr.lastObject;
                bid = model.streamId;
            }
            [strongSelf arkMuLoadDataFromServerWithBId:bid state:NO];
        }];
    } else {
        [SVProgressHUD showWithStatus:@"网络状况不佳"];
        
        if ([_tableView.mj_header isRefreshing]) {
            [_tableView.mj_header endRefreshing];
        }
    }
}

- (void)arkMuLoadDataFromServerWithBId:(NSInteger)bid state:(BOOL)isTop {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
   
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(3);
    
    NSMutableArray *itemsArr = [NSMutableArray array];
    
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    [parametersDic setValue:@59 forKey:@"feed_id"];
    [parametersDic setValue:@20 forKey:@"per_page"];
    if (bid != 0) {
        [parametersDic setValue:@(bid) forKey:@"b_id"];
    }
    
    if (isTop) {
        self.dataArr = [NSMutableArray array];
    }
    
    __weak typeof(self) weakSelf = self;
    [manager GET:AKStreamUrl parameters:parametersDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof(weakSelf) strongSelf = self;
        NSDictionary *dict = [(NSDictionary *)responseObject valueForKey:@"data"];
        NSArray *responseArr = [dict valueForKey:@"items"];
        
        NSLog(@"responseArr.count: %lu", responseArr.count);
        
        for (int i = 0; i < responseArr.count; i++) {
            NSDictionary *dict = responseArr[i];
            StreamModel *model = [StreamModel modelWithDictionary:dict];
            [itemsArr addObject:model];
        }
        
        [strongSelf.dataArr addObjectsFromArray:itemsArr];
        
        dispatch_semaphore_signal(semaphore);
        
//        [strongSelf.tableView reloadData];
//
//        if ([strongSelf.tableView.mj_header isRefreshing]) {
//            [strongSelf.tableView.mj_header endRefreshing];
//        }
//
//        if ([strongSelf.tableView.mj_footer isRefreshing]) {
//            [strongSelf.tableView.mj_footer endRefreshing];
//        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        
        [SVProgressHUD showWithStatus:@"网络状况不佳"];
        
        dispatch_semaphore_signal(semaphore);
        
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        if ([strongSelf.tableView.mj_header isRefreshing]) {
//            [strongSelf.tableView.mj_header endRefreshing];
//        }
//
//        if ([strongSelf.tableView.mj_footer isRefreshing]) {
//            [strongSelf.tableView.mj_footer endRefreshing];
//        }
    }];
    
    if (isTop) {
        [parametersDic removeAllObjects];
        [parametersDic setValue:@59 forKey:@"feed_id"];
        [parametersDic setValue:@"feed" forKey:@"type"];
        
        __weak typeof(self) weakSelf = self;
        [manager GET:AKFocusUrl parameters:parametersDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSArray *itemsArr = [[responseObject valueForKey:@"data"] valueForKey:@"items"];
            for (int i = 0; i < itemsArr.count; i++) {
                NSDictionary *dict = itemsArr[i];
                FeedModel *model = [FeedModel modelWithDictionary:dict];
                if (strongSelf.feedArr == nil) {
                    strongSelf.feedArr = [NSMutableArray array];
                }
                
                [strongSelf.feedArr addObject:model];
            }
            
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showWithStatus:@"网络状况不佳"];
            
            dispatch_semaphore_signal(semaphore);
        }];
        
        
        [parametersDic removeAllObjects];
        [parametersDic setValue:@59 forKey:@"feed_id"];
        [parametersDic setValue:@"feed_second_level" forKey:@"type"];
        
        [manager GET:AKFocusUrl parameters:parametersDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self.tableView reloadData];
    
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    StreamModel *model = [self.dataArr objectAtIndex:indexPath.row];
    if ([model.entityType isEqualToString:@"post"] || [model.entityType isEqualToString:@"audio"] || [model.entityType isEqualToString:@"video"]) {
        return 140.0;
    } else if ([model.entityType isEqualToString:@"monographic"]) {
        return 200.0;
    } else if ([model.entityType isEqualToString:@"newsflash"]) {
        return 100.0;
    } else {
        return 210.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    return label;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StreamModel *model = self.dataArr[indexPath.row];
    if ([model.entityType isEqualToString:@"post"] || [model.entityType isEqualToString:@"audio"] || [model.entityType isEqualToString:@"video"]) {
        PostCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PostCellIdentifier];
        }
        
        cell.streamModel = self.dataArr[indexPath.row];
        
        return cell;
    } else if ([model.entityType isEqualToString:@"monographic"]) {
        MonoGraphicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[MonoGraphicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MonoGraphicCellIdentifier];
        }
        cell.streamModel = model;
        return cell;
    } else if ([model.entityType isEqualToString:@"album"]) {
        AlbumCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[AlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ThemeCellIdentifier];
        }
        
        cell.streamModel = model;
        return cell;
    } else {
        NewFlashCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[NewFlashCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewFlashCellIdentifier];
        }
        
        cell.streamModel = model;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
