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
    
    UIScrollView *scrolleView = [[UIScrollView alloc] init];
    [self addSubview:scrolleView];
    scrolleView.delegate = self;
    scrolleView.pagingEnabled = YES;
    scrolleView.showsHorizontalScrollIndicator = NO;
    _scrollView = scrolleView;
    
    UILabel *commentLabel = [[UILabel alloc] init];
    commentLabel.textColor = AKWhiteColor;
    commentLabel.backgroundColor = AKColor(0, 0, 0, 0.5);
    commentLabel.textAlignment = NSTextAlignmentLeft;
    commentLabel.font = AKCustomFont(17);
    [self addSubview:commentLabel];
    _commentLabel = commentLabel;
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = 3;
    pageControl.pageIndicatorTintColor = AKLightGray;
    pageControl.currentPageIndicatorTintColor = AKWhiteColor;
    pageControl.backgroundColor = AKClearColor;
    [self addSubview:pageControl];
    _pageControl = pageControl;
    
    [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(14);
        make.trailing.bottom.mas_equalTo(-14);
        make.height.mas_equalTo(30);
    }];
    
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(commentLabel);
        make.bottom.mas_equalTo(commentLabel.mas_top);
    }];
    
    [scrolleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(self);
    }];
    
    UIView *containerView = [[UIView alloc] init];
    [scrolleView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(scrolleView);
        make.size.mas_equalTo(scrolleView);
    }];
    
    UIImageView *leftImageView = [[UIImageView alloc] init];
    UIImageView *centerImageView = [[UIImageView alloc] init];
    UIImageView *rightImageView = [[UIImageView alloc] init];
    
    [containerView addSubview:leftImageView];
    [containerView addSubview:centerImageView];
    [containerView addSubview:rightImageView];
    
    centerImageView.userInteractionEnabled = YES;
    
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(containerView);
        make.size.mas_equalTo(containerView);
        make.trailing.mas_equalTo(containerView.mas_leading);
    }];
    
    [centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(containerView);
        make.center.mas_equalTo(containerView);
    }];
    
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(containerView);
        make.top.mas_equalTo(containerView);
        make.leading.mas_equalTo(containerView.mas_trailing);
    }];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionForGestureOnCenterImageView)];
    [_centerImgView addGestureRecognizer:tap];
    
    return self;
}

- (void)actionForGestureOnCenterImageView {
    if (_gotoWebView) {
        FeedModel *model = _feedArr[_currentIndex];
        _gotoWebView(model.url);
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < feedArr.count; i++) {
            FeedModel *model = feedArr[i];
            if (model.coverImage == nil) {
                NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.cover]];
                UIImage *image = [UIImage imageWithData:imgData];
                model.coverImage = image;
            }
        }
    });
    
    
}

- (NSInteger)indexEnabled:(NSInteger)index {
    if (index < 0) {
        return _feedArr.count - 1;
    } else if (index > _feedArr.count) {
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
    _leftImgView.image = leftModel.coverImage;
    
    NSInteger currentIndex = [self indexEnabled:_currentIndex];
    FeedModel *currentModel = _feedArr[currentIndex];
    _centerImgView.image = currentModel.coverImage;
    
    NSInteger rightIndex = [self indexEnabled:_currentIndex + 1];
    FeedModel *rightModel = _feedArr[rightIndex];
    _rightImgView.image = rightModel.coverImage;
    
    _commentLabel.text = currentModel.title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
