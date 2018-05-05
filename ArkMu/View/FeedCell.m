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
    
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
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
