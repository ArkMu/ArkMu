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

#import "StreamModel.h"
#import "PostCell.h"

static NSString *PostCellIdentifier = @"PostCellIdetifier";

@interface MessageVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation MessageVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - Controller Method

- (void)loadView {
    [super loadView];
    
    self.title = @"messageVC";
    self.view.backgroundColor = [UIColor clearColor];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, frame.size.width, frame.size.height - 64) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellStyleDefault;
    [tableView registerClass:[PostCell class] forCellReuseIdentifier:PostCellIdentifier];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _operationQueue = [[NSOperationQueue alloc] init];
    _operationQueue.maxConcurrentOperationCount = 1;
    _dataArr = [NSMutableArray array];
    
    [self arkMuLoadDataFromServerWithBId:0];
}

- (void)viewWillAppear:(BOOL)animated {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager manager];
    if (manager.reachable) {
        __weak typeof(self) weakSelf = self;
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSInteger bid = 0;
            if (strongSelf.dataArr.count > 0) {
                StreamModel *model = (StreamModel *)strongSelf.dataArr.lastObject;
                bid = model.streamId;
            }
            [strongSelf arkMuLoadDataFromServerWithBId:bid];
        }];
    } else {
        
    }
    
}

- (void)arkMuLoadDataFromServerWithBId:(NSInteger)bid {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableArray *itemsArr = [NSMutableArray array];
    
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@59, @"feed_id", @20, @"per_page", nil];
    if (bid != 0) {
        [parametersDic setValue:@(bid) forKey:@"b_id"];
    }
    
    [manager GET:AKStreamUrl parameters:parametersDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *responseArr = [[(NSDictionary *)responseObject valueForKey:@"data"] valueForKey:@"items"];
        
        for (int i = 0; i < responseArr.count; i++) {
            NSDictionary *dict = responseArr[i];
            StreamModel *model = [StreamModel modelWithDictionary:dict];
            [itemsArr addObject:model];
        }
        
        [self.dataArr addObjectsFromArray:itemsArr];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
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
    PostCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PostCellIdentifier];
    }
    
    cell.streamModel = self.dataArr[indexPath.row];
    
    return cell;
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
