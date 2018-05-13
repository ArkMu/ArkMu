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

#import "EntityModel.h"

#import "SmallImageCell.h"
#import "BigImageCell.h"
#import "NoImageCell.h"
#import "MultiImageCell.h"
#import "AlbumCell.h"

#import "FeedModel.h"
#import "FeedCell.h"

#import "TypeModel.h"
#import "TypeCell.h"

#import "TypeInfoVC.h"
#import "InfoVC.h"

#import "VideoVC.h"
#import "AudioVC.h"

#import "ActivityVC.h"

static NSString *FeedCellIdentifier = @"FeedCellIdentifier";
static NSString *TypeCellIdentifier = @"TypeCellIdentifier";

static NSString *SmallImageCellIdentifier = @"SmallImageCellIdentifier";
static NSString *BigImageCellIdentifier = @"BigImageCellIdentifier";
static NSString *NoImageCellIdentifier = @"NoImageCellIdentifier";
static NSString *MultiImageCellIdentifier = @"MultiImageCellIdentifier";
static NSString *ThemeCellIdentifier = @"ThemeCellIdentifier";
static NSString *AlbumCellIdentifier = @"AlbumCellIdentifier";

@interface MessageVC () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *feedArr;
@property (nonatomic, strong) NSMutableArray *typeArr;

@end

@implementation MessageVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - Controller Method

- (void)loadView {
    [super loadView];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, frame.size.width, frame.size.height - 64) style:UITableViewStyleGrouped];
    tableView.backgroundColor = AKClearColor;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellStyleDefault;
    [tableView registerClass:[FeedCell class] forCellReuseIdentifier:FeedCellIdentifier];
    [tableView registerClass:[TypeCell class] forCellReuseIdentifier:TypeCellIdentifier];
    [tableView registerClass:[SmallImageCell class] forCellReuseIdentifier:SmallImageCellIdentifier];
    [tableView registerClass:[BigImageCell class] forCellReuseIdentifier:BigImageCellIdentifier];
    [tableView registerClass:[NoImageCell class] forCellReuseIdentifier:NoImageCellIdentifier];
    [tableView registerClass:[AlbumCell class] forCellReuseIdentifier:ThemeCellIdentifier];
    [tableView registerClass:[MultiImageCell class] forCellReuseIdentifier:MultiImageCellIdentifier];
    [tableView registerClass:[AlbumCell class] forCellReuseIdentifier:AlbumCellIdentifier];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"搜个关键词试试看?";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *loginItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"login"] style:UIBarButtonItemStylePlain target:self action:@selector(messageVCLoginItemAction:)];
    loginItem.imageInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    self.navigationItem.leftBarButtonItem = loginItem;
    
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"activity"] style:UIBarButtonItemStyleDone target:self action:@selector(messageVCActivityItemAction:)];
    activityItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, -8);
    self.navigationItem.rightBarButtonItem = activityItem;
    
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
                EntityModel *model = (EntityModel *)strongSelf.dataArr.lastObject;
                bid = model.tempId;
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

#pragma mark - UINavigationItemAction

- (void)messageVCLoginItemAction:(UIBarButtonItem *)item {
    
}

- (void)messageVCActivityItemAction:(UIBarButtonItem *)item {
    ActivityVC *activityVC = [[ActivityVC alloc] init];
    
    [self.navigationController pushViewController:activityVC animated:NO];
}

#pragma mark - Custom Method

- (void)arkMuLoadDataFromServerWithBId:(NSInteger)bid state:(BOOL)isTop {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
   
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    if (!isTop) {
        semaphore = dispatch_semaphore_create(1);
    }
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __weak typeof(self) weakSelf = self;
    dispatch_group_async(group, queue, ^{
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
    
        [manager GET:AKStreamUrl parameters:parametersDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            __strong typeof(weakSelf) strongSelf = self;
            NSDictionary *dict = [(NSDictionary *)responseObject valueForKey:@"data"];
            NSArray *responseArr = [dict valueForKey:@"items"];
            
            for (int i = 0; i < responseArr.count; i++) {
                NSDictionary *dict = responseArr[i];
                if ([[dict valueForKey:@"type"] isEqualToString:@"ad"]) {
                    continue;
                }
                
                EntityModel *model = [EntityModel modelWithDictionary:dict];
                [itemsArr addObject:model];
            }
            
            [strongSelf.dataArr addObjectsFromArray:itemsArr];
            
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error: %@", error);
            
            [SVProgressHUD showWithStatus:@"网络状况不佳"];
            
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    if (isTop) {
        dispatch_group_async(group, queue, ^{
            __weak typeof(self) weakSelf = self;
            [manager GET:AKFeedUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.feedArr = [NSMutableArray array];
                
                NSArray *itemsArr = [[responseObject valueForKey:@"data"] valueForKey:@"items"];
                for (int i = 0; i < itemsArr.count; i++) {
                    NSDictionary *dict = itemsArr[i];
                    if ([[dict valueForKey:@"type"] isEqualToString:@"feed"]) {
                        FeedModel *model = [FeedModel modelWithDictionary:dict];
                        [strongSelf.feedArr addObject:model];
                    }
                }
                
                dispatch_semaphore_signal(semaphore);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [SVProgressHUD showWithStatus:@"网络状况不佳"];
                
                dispatch_semaphore_signal(semaphore);
            }];
        });
        
        dispatch_group_async(group, queue, ^{
            [manager GET:AKFeedSecond parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                NSArray *itemsArr = [[responseObject valueForKey:@"data"] valueForKey:@"items"];
                strongSelf.typeArr = [NSMutableArray array];
                for (int i = 0; i < itemsArr.count; i++) {
                    NSDictionary *dict = itemsArr[i];
                    TypeModel *model = [TypeModel modelWithDictionary:dict];
                    [strongSelf.typeArr addObject:model];
                }
                
                dispatch_semaphore_signal(semaphore);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                dispatch_semaphore_signal(semaphore);
            }];
        });
    }
    
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        if (isTop) {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.tableView reloadData];
        });
        
        if ([strongSelf.tableView.mj_header isRefreshing]) {
            [strongSelf.tableView.mj_header endRefreshing];
        }
        
        if ([strongSelf.tableView.mj_footer isRefreshing]) {
            [strongSelf.tableView.mj_footer endRefreshing];
        }
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 0.56 * AKScreenWidth;
    } else if (indexPath.row == 1) {
        return 81;
    } else {
        EntityModel *model = [self.dataArr objectAtIndex:indexPath.row - 2];
        if ([model.templateType isEqualToString:AKTemplateSmallImage]) {
            return 140.0;
        } else if ([model.templateType isEqualToString:AKTemplateBigImage]) {
            return 320.0;
        } else if ([model.templateType isEqualToString:AKTemplateNoImage]) {
            return 100.0;
        } else if ([model.templateType isEqualToString:AKMultiImage]) {
            return 210.0;
        } else {
            return 210.0;
        }
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
    if (indexPath.row == 0) {
//        FeedCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedCellIdentifier];
        if (cell == nil) {
            cell = [[FeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FeedCellIdentifier];
        }
        cell.feedArr = self.feedArr;
        
        __weak typeof(self) weakSelf = self;
        cell.gotoWebView = ^(NSInteger entityId) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            InfoVC *infoVC = [[InfoVC alloc] init];
            infoVC.infoId = entityId;
            [strongSelf.navigationController pushViewController:infoVC animated:NO];
        };
        return cell;
    } else if (indexPath.row == 1) {
//        TypeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        TypeCell *cell = [tableView dequeueReusableCellWithIdentifier:TypeCellIdentifier];
        if (cell == nil) {
            cell = [[TypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TypeCellIdentifier];
        }
        cell.typeArr = self.typeArr;
        __weak typeof(self) weakSelf = self;
        cell.gotoWebView = ^(NSInteger entityId) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            TypeInfoVC *typeInfoVC = [[TypeInfoVC alloc] init];
            typeInfoVC.entityId = entityId;
            [strongSelf.navigationController pushViewController:typeInfoVC animated:NO];
        };
        return cell;
    } else {
        EntityModel *model = self.dataArr[indexPath.row - 2];
        if ([model.templateType isEqualToString:AKTemplateSmallImage]) {
//            SmallImageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            SmallImageCell *cell = [tableView dequeueReusableCellWithIdentifier:SmallImageCellIdentifier];
            if (cell == nil) {
                cell = [[SmallImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SmallImageCellIdentifier];
            }
            
            cell.entityModel = model;
            return cell;
        } else if ([model.templateType isEqualToString:AKTemplateBigImage]) {
//            BigImageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            BigImageCell *cell = [tableView dequeueReusableCellWithIdentifier:BigImageCellIdentifier];
            if (cell == nil) {
                cell = [[BigImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BigImageCellIdentifier];
            }
            cell.entityModel = model;
            return cell;
        } else if ([model.templateType isEqualToString:AKTemplateAlbum]) {
//            AlbumCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            AlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:AlbumCellIdentifier];
            if (cell == nil) {
                cell = [[AlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ThemeCellIdentifier];
            }
            
            cell.entityModel = model;
            return cell;
        } else if ([model.templateType isEqualToString:AKTemplateNoImage]) {
//            NoImageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NoImageCellIdentifier];
            if (cell == nil) {
                cell = [[NoImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NoImageCellIdentifier];
            }
            
            cell.entityModel = model;
            return cell;
        } else  {
            // multi image
//            MultiImageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            MultiImageCell *cell = [tableView dequeueReusableCellWithIdentifier:MultiImageCellIdentifier];
            if (cell == nil) {
                cell = [[MultiImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MultiImageCellIdentifier];
            }
            
            cell.entityModel = model;
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
 
    EntityModel *entityModel = self.dataArr[indexPath.row - 2];
//    if ([entityModel.entityType isEqualToString:@"post"]) {
//        InfoVC *infoVC = [[InfoVC alloc] init];
//        infoVC.infoId = entityModel.entityId;
//        [self.navigationController pushViewController:infoVC animated:NO];
//    } else if ([entityModel.entityType isEqualToString:@"video"]) {
//        VideoVC *videoVC = [[VideoVC alloc] init];
//        videoVC.videoId = entityModel.entityId;
//        [self.navigationController pushViewController:videoVC animated:NO];
//    } else if ([entityModel.entityType isEqualToString:@"audio"]) {
//        AudioVC *audioVC = [[AudioVC alloc] init];
//        audioVC.bId = entityModel.entityId;
//        audioVC.columnId = entityModel.columnId;
//        [self.navigationController pushViewController:audioVC animated:NO];
//    } else if ([entityModel.entityType isEqualToString:@"theme"]) {
//
//    } else if ([entityModel.entityType isEqualToString:@"newsflash"]) {
//
//    }
    
    if ([entityModel.entityType isEqualToString:@"video"]) {
        VideoVC *videoVC = [[VideoVC alloc] init];
        videoVC.videoId = entityModel.entityId;
        [self.navigationController pushViewController:videoVC animated:NO];
    } else if ([entityModel.entityType isEqualToString:@"audio"]) {
        AudioVC *audioVC = [[AudioVC alloc] init];
        audioVC.bId = entityModel.entityId;
        audioVC.columnId = entityModel.columnId;
        [self.navigationController pushViewController:audioVC animated:NO];
    } else if ([entityModel.entityType isEqualToString:@"post"]) {
        InfoVC *infoVC = [[InfoVC alloc] init];
        infoVC.infoId = entityModel.entityId;
        [self.navigationController pushViewController:infoVC animated:NO];
    } else {
        
    }
}

#pragma makr - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
