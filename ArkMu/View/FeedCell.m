//
//  FeedCell.m
//  ArkMu
//
//  Created by Sky on 2018/5/5.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "FeedCell.h"

#import "FeedModel.h"

#import "Common.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface FeedCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UIImageView *centerImgView;
@property (nonatomic, strong) UIImageView *rightImgView;

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *commentLabel;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation FeedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    UIScrollView *scrolleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0.56 * frame.size.width)];
    [self addSubview:scrolleView];
    scrolleView.delegate = self;
    scrolleView.pagingEnabled = YES;
    scrolleView.showsHorizontalScrollIndicator = NO;
    scrolleView.contentSize = CGSizeMake(frame.size.width * 3, 0.56 * frame.size.width);
    _scrollView = scrolleView;
    
    UIView *commentView = [[UIView alloc] init];
    commentView.backgroundColor = AKAlphaColor(0.5);
    [self addSubview:commentView];
    
    UILabel *commentLabel = [[UILabel alloc] init];
    commentLabel.textColor = AKWhiteColor;
    commentLabel.backgroundColor = AKClearColor;
    commentLabel.textAlignment = NSTextAlignmentLeft;
    commentLabel.font = AKCustomFont(17);
    [commentView addSubview:commentLabel];
    _commentLabel = commentLabel;
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = 3;
    pageControl.pageIndicatorTintColor = AKLightGray;
    pageControl.currentPageIndicatorTintColor = AKWhiteColor;
    pageControl.backgroundColor = AKClearColor;
    [self addSubview:pageControl];
    _pageControl = pageControl;
    
    [commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self);
        make.height.mas_equalTo(30);
    }];
    
    [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(14);
        make.trailing.mas_equalTo(-14);
        make.bottom.mas_equalTo(commentView);
        make.height.mas_equalTo(30);
    }];
    
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(commentView);
        make.bottom.mas_equalTo(commentView.mas_top);
    }];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3 * AKScreenWidth, 0.56 * AKScreenWidth)];
    [scrolleView addSubview:containerView];
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 * AKScreenWidth, 0, AKScreenWidth, 0.56 * AKScreenWidth)];
    UIImageView *centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1 * AKScreenWidth, 0, AKScreenWidth, 0.56 * AKScreenWidth)];
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2 * AKScreenWidth, 0, AKScreenWidth, 0.56 * AKScreenWidth)];
    
    _leftImgView = leftImageView;
    _centerImgView = centerImageView;
    _rightImgView = rightImageView;
    
    [containerView addSubview:leftImageView];
    [containerView addSubview:centerImageView];
    [containerView addSubview:rightImageView];
    
    centerImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionForGestureOnCenterImageView)];
    [_centerImgView addGestureRecognizer:tap];
    
    return self;
}

- (void)actionForGestureOnCenterImageView {
    if (_gotoWebView) {
        FeedModel *model = _feedArr[_currentIndex];
        _gotoWebView(model.entityId);
    }
}

- (void)updateImageState {
    _currentIndex = [self indexEnabled:_currentIndex++];
    [self setImageViewForScrollView];
}

- (void)setFeedArr:(NSArray<FeedModel *> *)feedArr {
    _feedArr = feedArr;
    
    _pageControl.numberOfPages = feedArr.count;
    _pageControl.currentPage = _currentIndex;
    
    [self setImageViewForScrollView];
}

- (NSInteger)indexEnabled:(NSInteger)index {
    if (index < 0) {
        return _feedArr.count - 1;
    } else if (index > _feedArr.count - 1) {
        return 0;
    } else {
        return index;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == 0) {
        _currentIndex--;
    } else if (scrollView.contentOffset.x == 2 * scrollView.frame.size.width) {
        _currentIndex++;
    }
    
    _currentIndex = [self indexEnabled:_currentIndex];
    
    [self setImageViewForScrollView];
}

- (void)setImageViewForScrollView {
    _pageControl.currentPage = _currentIndex;
    
    NSInteger leftIndex = [self indexEnabled:_currentIndex - 1];
    FeedModel *leftModel = _feedArr[leftIndex];
    [_leftImgView sd_setImageWithURL:[NSURL URLWithString:leftModel.cover]];
    
    NSInteger currentIndex = [self indexEnabled:_currentIndex];
    FeedModel *currentModel = _feedArr[currentIndex];
    [_centerImgView sd_setImageWithURL:[NSURL URLWithString:currentModel.cover]];
    _centerImgView.userInteractionEnabled = YES;
    
    NSInteger rightIndex = [self indexEnabled:_currentIndex + 1];
    FeedModel *rightModel = _feedArr[rightIndex];
    [_rightImgView sd_setImageWithURL:[NSURL URLWithString:rightModel.cover]];
    
    _commentLabel.text = currentModel.title;
    
    _scrollView.contentOffset = CGPointMake(AKScreenWidth, 0);
}

@end
