//
//  ActivityCell.m
//  ArkMu
//
//  Created by Sky on 2018/5/6.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "ActivityCell.h"

#import "Common.h"
#import "ActivityModel.h"

#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface ActivityCell ()

@property (nonatomic, strong) UIImageView   *imgView;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UIView        *lineView;

@end

@implementation ActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    [self addSubview:imgView];
    _imgView = imgView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = AKBlackColor;
    titleLabel.font = AKCustomFont(17);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = AKAlphaColor(0.3);
    [self addSubview:lineView];
    _lineView = lineView;
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(14);
        make.trailing.mas_equalTo(-14);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1.0 / AKScale);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(lineView);
        make.bottom.mas_equalTo(lineView.mas_bottom).mas_equalTo(-14);
        make.height.mas_equalTo(21);
    }];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(14);
        make.trailing.mas_equalTo(-14);
        make.bottom.mas_equalTo(titleLabel.mas_top).mas_equalTo(-8);
    }];
    
    return self;
}

- (void)setActivityModel:(ActivityModel *)activityModel {
    _activityModel = activityModel;
    
    __weak typeof(self) weakSelf = self;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:activityModel.cover] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, image.size.width, image.size.height) cornerRadius:12];
        [path addClip];
        [image drawAtPoint:CGPointZero];
        UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.imgView.image = clipImage;
        });
    }];
    
    _titleLabel.text = activityModel.subject;
}

@end
