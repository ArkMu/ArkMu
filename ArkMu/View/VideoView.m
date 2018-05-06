//
//  VideoView.m
//  ArkMu
//
//  Created by Sky on 2018/5/6.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "VideoView.h"

#import "Common.h"
#import <Masonry.h>

#import <AVFoundation/AVFoundation.h>

@interface VideoView ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) UILabel *currentLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, strong) id observer;

@property (nonatomic, assign) CGFloat totalVideoTime;

@end

@implementation VideoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.player = [[AVPlayer alloc] init];

        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        playerLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        _playerLayer = playerLayer;
        
        [self.layer addSublayer:playerLayer];
        [playerLayer setNeedsDisplay];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = AKClearColor;
        [btn addTarget:self action:@selector(videoViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(self);
        }];
        
        UILabel *currentLabel = [[UILabel alloc] init];
        currentLabel.font = AKCustomFont(12.0);
        currentLabel.textColor = AKWhiteColor;
        [self addSubview:currentLabel];
        _currentLabel = currentLabel;
        
        UISlider *slider = [[UISlider alloc] init];
        slider.maximumTrackTintColor = AKWhiteColor;
        slider.minimumTrackTintColor = AKBlueColor;
        slider.thumbTintColor = AKClearColor;
        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:slider];
        _slider = slider;
        
        UILabel *totalLabel = [[UILabel alloc] init];
        totalLabel.font = AKCustomFont(12.0);
        totalLabel.textColor = AKWhiteColor;
        [self addSubview:totalLabel];
        _totalLabel = totalLabel;
        
        [currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(8);
            make.bottom.mas_equalTo(self);
            make.height.mas_equalTo(21);
            make.width.mas_equalTo(50);
        }];
        
        [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-8);
            make.bottom.mas_equalTo(self);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(21);
        }];
        
        [slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(currentLabel.mas_trailing).mas_offset(8);
            make.trailing.mas_equalTo(totalLabel.mas_leading).mas_offset(-8);
            make.centerY.mas_lessThanOrEqualTo(currentLabel);
        }];
    }
    
    return self;
}

- (void)loadVideoWithUrl:(NSString *)videoUrl {
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:videoUrl]];
    [self.player replaceCurrentItemWithPlayerItem:item];
    
    [self addProgressObserver];
    
    [self.player play];
    
    _isPlaying = YES;
}

- (void)videoViewBtnAction:(UIButton *)sender {
    if (_isPlaying) {
        [self.player pause];
        [sender setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    } else {
        [self.player play];
        [sender setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    _isPlaying = !_isPlaying;
}

- (void)setPlayerNil {
    [self.playerLayer removeFromSuperlayer];
    
    _playerLayer = nil;
    _player = nil;
}

- (void)sliderValueChanged:(UISlider *)slider {
    [self.player pause];
    
    float current = (float)(self.totalVideoTime * slider.value);
    CMTime currentTime = CMTimeMake(current, 1);
    [self.player seekToTime:currentTime completionHandler:^(BOOL finished) {
        [self.player play];
    }];
}

- (void)addProgressObserver {
    AVPlayerItem *item = self.player.currentItem;
    
    __weak typeof(self) weakSelf = self;
    
    _observer = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.slider.userInteractionEnabled = YES;
        
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([item duration]);
        
        CMTime totalTime = item.duration;
        
        strongSelf.totalVideoTime = (CGFloat)totalTime.value / totalTime.timescale;
        
        [strongSelf.slider setValue:(current / total) animated:NO];
        
        strongSelf.currentLabel.text = [NSString stringWithFormat:@"%.2ld: %.2ld", (NSInteger)current / 60, (NSInteger)current % 60];
        strongSelf.totalLabel.text = [NSString stringWithFormat:@"%.2ld: %.2ld", (NSInteger)total / 60, (NSInteger)total % 60];
    }];
}

@end
