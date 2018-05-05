//
//  TypeCell.m
//  ArkMu
//
//  Created by Sky on 2018/5/5.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "TypeCell.h"

#import "Common.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "TypeModel.h"

@interface TypeCell ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation TypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(14);
        make.trailing.mas_equalTo(-14);
        make.center.height.mas_equalTo(self);
    }];
    
    return self;
}

- (void)setTypeArr:(NSArray<TypeModel *> *)typeArr {
    _typeArr = typeArr;
    
    for (int i = 0; i < typeArr.count; i++) {
        UIView *view = [self createViewWithIndex:i];
        [_scrollView addSubview:view];
    }
    
    _scrollView.contentSize = CGSizeMake(70 * typeArr.count, 81);
}

- (UIView *)createViewWithIndex:(NSInteger)index {
    TypeModel *model = _typeArr[index];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(70 * index, 0, 70, 81)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    [view addSubview:imgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, 70, 21)];
    titleLabel.textColor = AKBlackColor;
    titleLabel.font = AKCustomFont(14);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
    titleLabel.text = model.title;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(70 * index, 0, 70, 81);
    btn.tag = 1000 + index;
    [btn addTarget:self action:@selector(actionForButtonWithSender:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = AKClearColor;
    [view addSubview:btn];
    
    return view;
}

- (void)actionForButtonWithSender:(UIButton *)sender {
    if (_gotoWebView) {
        NSInteger index = sender.tag - 1000;
        TypeModel *model = self.typeArr[index];
        _gotoWebView(model.url);
    }
}

@end
