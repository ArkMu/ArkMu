//
//  MultiImageCell.m
//  ArkMu
//
//  Created by Sky on 2018/5/7.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "MultiImageCell.h"

#import "Common.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

#import "UIImage+ClipImage.h"

#import "EntityModel.h"

@interface MultiImageCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UIImageView *centerImgView;
@property (nonatomic, strong) UIImageView *rightImgView;

@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *storeLabel;

@end

@implementation MultiImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = AKBlackColor;
        titleLabel.font = AKCustomFont(17);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.numberOfLines = 0;
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        UIImageView *leftImgView = [[UIImageView alloc] init];
        [self addSubview:leftImgView];
        _leftImgView = leftImgView;
        
        UIImageView *centerImgView = [[UIImageView alloc] init];
        [self addSubview:centerImgView];
        _centerImgView = centerImgView;
        
        UIImageView *rightImgView = [[UIImageView alloc] init];
        [self addSubview:rightImgView];
        _rightImgView = rightImgView;
        
        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.textColor = AK204Color;
        descLabel.font = AKCustomFont(14);
        descLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:descLabel];
        _descLabel = descLabel;
        
        UILabel *storeLabel = [[UILabel alloc] init];
        storeLabel.textColor = AK204Color;
        storeLabel.font = AKCustomFont(14);
        storeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:storeLabel];
        _storeLabel = storeLabel;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = AKLightGray;
        [self addSubview:lineView];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.mas_equalTo(15);
            make.trailing.mas_equalTo(-15);
            make.height.mas_equalTo(21);
        }];
        
        [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(titleLabel);
            make.top.mas_equalTo(titleLabel.mas_bottom).mas_equalTo(10);
            make.height.mas_equalTo(80);
        }];
        
        [centerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(leftImgView.mas_trailing).mas_equalTo(8);
            make.size.centerY.mas_equalTo(leftImgView);
        }];
        
        [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(centerImgView.mas_trailing).mas_equalTo(8);
            make.size.centerY.mas_equalTo(leftImgView);
            make.trailing.mas_equalTo(titleLabel.mas_trailing);
        }];
        
        [storeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(titleLabel.mas_trailing);
            make.bottom.mas_equalTo(self).mas_equalTo(-15);
            make.top.mas_equalTo(rightImgView.mas_bottom);
            make.width.mas_equalTo(50);
        }];
        
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(titleLabel);
            make.centerY.height.mas_equalTo(storeLabel);
            make.trailing.mas_equalTo(storeLabel.mas_leading).mas_equalTo(-8);
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(titleLabel);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1.0 / AKScale);
        }];
    }
    
    return self;
}

- (void)setEntityModel:(EntityModel *)entityModel {
    _entityModel = entityModel;
    
    _titleLabel.text = entityModel.templateTitle;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 8;
        NSDictionary *paradict = @{NSFontAttributeName: AKCustomFont(17), NSParagraphStyleAttributeName: paragraph};
        CGRect rect = [entityModel.templateTitle boundingRectWithSize:CGSizeMake(AKScreenWidth - 30, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:paradict context:NULL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(rect.size.height);
            }];
        });
    });
    
    [_leftImgView sd_setImageWithURL:[NSURL URLWithString:[entityModel.templateCoverArr objectAtIndex:0]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *clipImage = [image clipImageWithCornerRadius:0.1 * image.size.width];
            __strong typeof(weakSelf) strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.leftImgView.image = clipImage;
            });
        });
    }];
        
    [_centerImgView sd_setImageWithURL:[NSURL URLWithString:[entityModel.templateCoverArr objectAtIndex:1]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *clipImage = [image clipImageWithCornerRadius:0.1 * image.size.width];
            __strong typeof(weakSelf) strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.centerImgView.image = clipImage;
            });
        });
    }];
        
    [_rightImgView sd_setImageWithURL:[NSURL URLWithString:[entityModel.templateCoverArr objectAtIndex:2]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *clipImage = [image clipImageWithCornerRadius:0.1 * image.size.width];
            __strong typeof(weakSelf) strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.rightImgView.image = clipImage;
            });
        });
    }];
    
    _descLabel.text = entityModel.name;
    _storeLabel.text = [NSString stringWithFormat:@"%lu收藏", entityModel.favouriteNum];
}

@end
