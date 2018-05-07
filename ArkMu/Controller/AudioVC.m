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
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>

#import "UIImage+ClipImage.h"

#import "AudioModel.h"

static NSString *AudioCellIdentifier = @"AudioCellIdentifier";

@interface AudioVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *currentLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, strong) UIButton *forwardBtn;
@property (nonatomic, strong) UIButton *playOrPauseBtn;
@property (nonatomic, strong) UIButton *backwardBtn;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) AVPlayer  *player;
@property (nonatomic, strong) id        observer;
@property (nonatomic, assign) NSInteger totalAudioTime;

@property (nonatomic, assign) BOOL      playState;

@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *containerView;

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
    _imgView = imgView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = AKWhiteColor;
    titleLabel.font = AKCustomFont(20.0);
    [self.view addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UIImageView *avtarImgView = [[UIImageView alloc] init];
    [self.view addSubview:avtarImgView];
    _avatarImgView = avtarImgView;
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.textColor = AKWhiteColor;
    descLabel.font = AKCustomFont(16);
    [self.view addSubview:descLabel];
    _descLabel = descLabel;
    
    UIButton *focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [focusBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
    [focusBtn setTitleColor:AKWhiteColor forState:UIControlStateNormal];
    focusBtn.titleLabel.font = AKCustomFont(16);
    [focusBtn setBackgroundColor:AKLightCoral];
    focusBtn.layer.cornerRadius = 16;
    focusBtn.layer.masksToBounds = YES;
    [self.view addSubview:focusBtn];
    
    UISlider *slider = [[UISlider alloc] init];
    slider.maximumTrackTintColor = AKLightGray;
    slider.minimumTrackTintColor = AKRedColor;
    slider.thumbTintColor = AKClearColor;
    [slider addTarget:self action:@selector(audioVCSliderValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:slider];
    _slider = slider;
    
    UILabel *currentTimeLabel = [[UILabel alloc] init];
    currentTimeLabel.textColor = AKWhiteColor;
    currentTimeLabel.font = AKCustomFont(14);
    [self.view addSubview:currentTimeLabel];
    _currentLabel = currentTimeLabel;
    
    UILabel *totalTimeLabel = [[UILabel alloc] init];
    totalTimeLabel.textColor = AKWhiteColor;
    totalTimeLabel.font = AKCustomFont(14);
    [self.view addSubview:totalTimeLabel];
    _totalLabel = totalTimeLabel;
    
    UIButton *forwardBtn = [self audioVCCreateButtonWithImage:@"forwardno@2x" selector:@selector(audioVCForwardBtnAction:)];
    [self.view addSubview:forwardBtn];
    _forwardBtn = forwardBtn;
    
    UIButton *playOrPauseBtn = [self audioVCCreateButtonWithImage:@"play@2x" selector:@selector(audioVCPlayOrPauseBtnAction:)];
    [self.view addSubview:playOrPauseBtn];
    _playOrPauseBtn = playOrPauseBtn;
    
    UIButton *backwardBtn = [self audioVCCreateButtonWithImage:@"backward@2x" selector:@selector(audioVCBackwardBtnAction:)];
    [self.view addSubview:backwardBtn];
    _backwardBtn = backwardBtn;
    
    UIButton *downloadBtn = [self audioVCCreateButtonWithImage:@"download@2x" selector:@selector(audioVCDownloadBtnAction:)];
    [self.view addSubview:downloadBtn];
    
    UIButton *messageBtn = [self audioVCCreateButtonWithImage:@"message@2x" selector:@selector(audioVCMessageBtnAction:)];
    [self.view addSubview:messageBtn];
    
    UIButton *storeBtn = [self audioVCCreateButtonWithImage:@"store@2x" selector:@selector(audioVCStoreBtnAction:)];
    [self.view addSubview:storeBtn];
    
    UIButton *shareBtn = [self audioVCCreateButtonWithImage:@"share@2x" selector:@selector(audioVCShareBtnAction:)];
    [self.view addSubview:shareBtn];
    
    UIButton *listBtn = [self audioVCCreateButtonWithImage:@"list@2x" selector:@selector(audioVCListBtnAction:)];
    [self.view addSubview:listBtn];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(60);
        make.top.mas_equalTo(64 + 30);
        make.trailing.mas_equalTo(-60);
        make.height.mas_equalTo(150);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(imgView.mas_bottom).mas_equalTo(10);
        make.trailing.mas_equalTo(-15);
        make.height.mas_equalTo(21);
    }];
    
    [avtarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(titleLabel);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(60, 28));
        make.centerY.mas_equalTo(avtarImgView);
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(avtarImgView.mas_trailing).mas_equalTo(8);
        make.trailing.mas_equalTo(focusBtn.mas_leading).mas_equalTo(-8);
        make.height.centerY.mas_equalTo(avtarImgView);
    }];
    
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.top.mas_equalTo(avtarImgView.mas_bottom).mas_equalTo(15);
        make.trailing.mas_equalTo(-15);
    }];
    
    [currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(slider);
        make.size.mas_equalTo(CGSizeMake(60, 21));
        make.top.mas_equalTo(slider.mas_bottom).mas_equalTo(15);
    }];
    
    [totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(slider.mas_trailing);
        make.size.centerY.mas_equalTo(currentTimeLabel);
    }];
    
    [playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.accessibilityViewIsModal);
        make.top.mas_equalTo(currentTimeLabel.mas_bottom).mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    
    [forwardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(playOrPauseBtn);
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.trailing.mas_equalTo(playOrPauseBtn.mas_leading).mas_equalTo(-30);
    }];
    
    [backwardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.centerY.mas_equalTo(forwardBtn);
        make.leading.mas_equalTo(playOrPauseBtn.mas_trailing).mas_equalTo(30);
    }];
    
    CGFloat btnWidth = AKScreenWidth / 5.0;
    [downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(btnWidth);
        make.bottom.mas_equalTo(self.view).mas_equalTo(-15);
    }];
    
    [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(downloadBtn.mas_trailing);
        make.size.centerY.mas_equalTo(downloadBtn);
    }];
    
    [storeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(messageBtn.mas_trailing);
        make.size.centerY.mas_equalTo(downloadBtn);
    }];
    
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(storeBtn.mas_trailing);
        make.size.centerY.mas_equalTo(downloadBtn);
    }];
    
    [listBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(shareBtn.mas_trailing);
        make.size.centerY.mas_equalTo(downloadBtn);
        make.trailing.mas_equalTo(self.view);
    }];
    
    [self audioVCCreateTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = AKSliverColor;
    self.navigationController.navigationBar.barTintColor = AKSliverColor;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(audioVCBackItemAction:)];
    backItem.imageInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    self.navigationItem.leftBarButtonItem = backItem;
    
    _currentIndex = 0;
    _playState = NO;
    self.title = @"暂停播放";
    [self audioVCLoadMessageFromNetwork];
}

#pragma mark - UINavigationItemAction

- (void)audioVCBackItemAction:(UIBarButtonItem *)item {
    self.navigationController.navigationBar.barTintColor = AKWhiteColor;
    
    [_player pause];
    _player = nil;
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Custom Method

- (void)audioVCLoadMessageFromNetwork {
    AFShareManager *manager = [AFShareManager shareManager];
    
    NSDictionary *parameter = @{@"b_id": @(_bId), @"column_id": @(_columnId), @"contiuous": @1, @"order_asc": @0, @"per_page": @20};
    
    __block NSInteger blockIndex = _currentIndex;
    [manager.sessionManager GET:AKAudioBaseUrl parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dataDict = [responseObject objectForKey:@"data"];
        NSArray *itemsArr = [dataDict valueForKey:@"items"];
        
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *dict in itemsArr) {
            AudioModel *model = [AudioModel modelWithDictionary:dict];
            [mArr addObject:model];
        }
        
        self.datasArr = mArr;
        [self audioVCSetMessageWithIndex:blockIndex];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
}

- (void)audioVCSetMessageWithIndex:(NSInteger)index {
    if (self.datasArr.count == 0 || index >= self.datasArr.count) {
        return;
    }
    
    if (self.datasArr.count == 1) {
        [self.backwardBtn setEnabled:NO];
        [self.backwardBtn setImage:[UIImage imageNamed:@"backwardno@2x"] forState:UIControlStateNormal];
    }
    
    AudioModel *model = self.datasArr[_currentIndex];
    
    if (model.coverArr.count) {
        _imgView.image = [model.coverArr firstObject];
    } else {
        __weak typeof(self) weakSelf = self;
        [_imgView sd_setImageWithURL:[NSURL URLWithString:model.cover] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            __strong typeof(weakSelf) strongSelf = weakSelf; dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *clipImage = [image clipImageWithCornerRadius:12];
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.imgView.image = clipImage;
                    [strongSelf.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo((AKScreenWidth - 120) / clipImage.size.width * clipImage.size.height);
                    }];
                });
                model.coverArr = [NSArray arrayWithObject:clipImage];
            });
        }];
    }
    
    _titleLabel.text = model.title;
    
    if (model.avtarArr.count) {
        _avatarImgView.image = [model.avtarArr firstObject];
    } else {
        __weak typeof(self) weakSelf = self;
        [_avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.userAvtarUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *clipImage = [image clipImageWithCornerRadius:0.2 * image.size.width];
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.avatarImgView.image = clipImage;
                });
                model.avtarArr = [NSArray arrayWithObject:clipImage];
            });
        }];
    }
    
    _descLabel.text = model.userName;
    
    [self audioVCCreateAudioPlayerWithUrl:model.url];
}

- (void)audioVCCreateAudioPlayerWithUrl:(NSString *)audioUrl {
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:audioUrl]];
    [self.player replaceCurrentItemWithPlayerItem:item];
    
    [self audioVCAddProgressObserver];
    
    [_playOrPauseBtn setImage:[UIImage imageNamed:@"pause@2x"] forState:UIControlStateNormal];
    [_player play];
    
    _playState = YES;
    self.title = @"正在播放";
}

- (AVPlayer *)player {
    if (_player == nil) {
        _player = [[AVPlayer alloc] init];
    }
    
    return _player;
}

- (void)audioVCAddProgressObserver {
    AVPlayerItem *item = self.player.currentItem;
    
    __weak typeof(self) weakSelf = self;
    
    _observer = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.slider.userInteractionEnabled = YES;
        
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([item duration]);
        
        CMTime totalTime = item.duration;
        
        strongSelf.totalAudioTime = (CGFloat)totalTime.value / totalTime.timescale;
        
        [strongSelf.slider setValue:(current / total) animated:NO];
        
        strongSelf.currentLabel.text = [NSString stringWithFormat:@"%.2ld: %.2ld", (NSInteger)current / 60, (NSInteger)current % 60];
        strongSelf.totalLabel.text = [NSString stringWithFormat:@"%.2ld: %.2ld", (NSInteger)total / 60, (NSInteger)total % 60];
    }];
}

- (void)audioVCSliderValueChanged:(UISlider *)slider {
    [self.player pause];
    
    float current = (float)(self.totalAudioTime * slider.value);
    CMTime currentTime = CMTimeMake(current, 1);
    [self.player seekToTime:currentTime completionHandler:^(BOOL finished) {
        [self.player play];
    }];
}

- (void)audioVCForwardBtnAction:(UIButton *)sender {
    _currentIndex--;
    if (_currentIndex == 0) {
        _forwardBtn.enabled = NO;
        [_forwardBtn setImage:[UIImage imageNamed:@"forwardno@2x"] forState:UIControlStateNormal];
    }
    
    _backwardBtn.enabled = YES;
    [_backwardBtn setImage:[UIImage imageNamed:@"backward@2x"] forState:UIControlStateNormal];
    [self audioVCSetMessageWithIndex:_currentIndex];
}

- (void)audioVCBackwardBtnAction:(UIButton *)sender {
    _currentIndex++;
    if (_currentIndex == self.datasArr.count - 1) {
        _backwardBtn.enabled = NO;
        [_backwardBtn setImage:[UIImage imageNamed:@"backwardno@2x"] forState:UIControlStateNormal];
    }
    
    _forwardBtn.enabled = YES;
    [_forwardBtn setImage:[UIImage imageNamed:@"forward@2x"] forState:UIControlStateNormal];
    [self audioVCSetMessageWithIndex:_currentIndex];
}

- (void)audioVCPlayOrPauseBtnAction:(UIButton *)sender {
    if (_playState) {
        [self.player pause];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"play@2x"] forState:UIControlStateNormal];
        self.title = @"暂停播放";
    } else {
        [self.player play];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"pause@2x"] forState:UIControlStateNormal];
        self.title = @"正在播放";
    }
    
    _playState = !_playState;
}

- (UIButton *)audioVCCreateButtonWithImage:(NSString *)imgName selector:(nonnull SEL)selector {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setTintColor:AKWhiteColor];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)audioVCDownloadBtnAction:(UIButton *)sender {
    
}

- (void)audioVCMessageBtnAction:(UIButton *)sender {
    
}

- (void)audioVCStoreBtnAction:(UIButton *)sender {
    
}

- (void)audioVCShareBtnAction:(UIButton *)sender {
    
}

- (void)audioVCListBtnAction:(UIButton *)sender {
    [UIView animateWithDuration:1.0 animations:^{
        self.containerView.transform = CGAffineTransformMakeTranslation(0, -300);
        [self.tableView reloadData];
    }];
}

#pragma mark - Make TableView

- (void)audioVCCreateTableView {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, AKScreenHeight, AKScreenWidth, 300)];
    containerView.backgroundColor = AKAlphaColor(0.8);
    self.containerView = containerView;
    [self.view addSubview:containerView];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, AKScreenWidth, 44)];
    headerLabel.text = @"播放列表";
    headerLabel.font = AKCustomFont(20);
    headerLabel.textColor = AKWhiteColor;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview:headerLabel];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, AKScreenWidth, 212) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = AKClearColor;
    [containerView addSubview:tableView];
    _tableView = tableView;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, 256, AKScreenWidth, 44);
    [closeBtn setImage:[UIImage imageNamed:@"close@2x"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(audioVCCloseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:closeBtn];
}

- (void)audioVCCloseBtnAction:(UIButton *)sender {
    [UIView animateWithDuration:1.0 animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
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
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:AudioCellIdentifier];
    }
    
    AudioModel *model = self.datasArr[indexPath.row];
    
    cell.textLabel.text = model.title;
    cell.textLabel.font = AKCustomFont(18);
    if (_currentIndex == indexPath.row) {
        cell.textLabel.textColor = AKRedColor;
    } else {
        cell.textLabel.textColor = AKWhiteColor;
    }
    
    int duration = (int)model.duration;
    NSString *time = [NSString stringWithFormat:@"%.2d:%.2d", duration / 60, duration % 60];
    NSString *size = [NSString stringWithFormat:@"%ldM", model.filesize / 1024 / 256];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", time, size];
    cell.detailTextLabel.font = AKCustomFont(14);
    cell.detailTextLabel.textColor = AKWhiteColor;
    
    cell.backgroundColor = AKClearColor;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    _currentIndex = indexPath.row;
    [self audioVCSetMessageWithIndex:_currentIndex];
    
    [tableView reloadData];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
