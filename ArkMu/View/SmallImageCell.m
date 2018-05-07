//
//  SmallImageCell.m
//  ArkMu
//
//  Created by Sky on 2018/5/5.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "SmallImageCell.h"

#import "Masonry.h"
#import "Common.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "EntityModel.h"
#import "ColumnModel.h"

#import "EntityModel.h"

@interface SmallImageCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *favouriteLabel;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation SmallImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    titleLabel.textColor = AKBlackColor;
    titleLabel.numberOfLines = 0;
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UILabel *desclabel = [[UILabel alloc] init];
    desclabel.font = [UIFont systemFontOfSize:14.0];
    desclabel.textColor = AK204Color;
    [self addSubview:desclabel];
    _descLabel = desclabel;
    
    UILabel *favouriteLabel = [[UILabel alloc] init];
    favouriteLabel.font = [UIFont systemFontOfSize:14.0];
    favouriteLabel.textColor = AK204Color;
    [self addSubview:favouriteLabel];
    _favouriteLabel = favouriteLabel;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    [self addSubview:imgView];
    _imgView = imgView;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = AK204Color;
    [self addSubview:lineView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.bottom.mas_equalTo(-14);
        make.trailing.mas_equalTo(-14);
        make.width.mas_equalTo(112);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(14);
        make.trailing.mas_equalTo(imgView.mas_leading).mas_equalTo(-8);
        make.height.mas_equalTo(80);
    }];
    
    [favouriteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-14);
        make.trailing.mas_equalTo(imgView.mas_leading).mas_equalTo(-8);
        make.size.mas_equalTo(CGSizeMake(60, 21));
    }];
    
    [desclabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(14);
        make.bottom.mas_equalTo(favouriteLabel.mas_bottom);
        make.height.mas_equalTo(21);
    }];
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(14);
        make.trailing.mas_equalTo(-14);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1.0 / scale);
    }];
    
    return self;
}

- (void)setEntityModel:(EntityModel *)entityModel {
    _entityModel = entityModel;
    
    self.titleLabel.text = entityModel.templateTitle;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 8;
        NSDictionary *dict = @{NSFontAttributeName: AKCustomFont(17), NSParagraphStyleAttributeName: paragraph};
        
        CGRect rect = [entityModel.templateTitle boundingRectWithSize:CGSizeMake(AKScreenWidth - 112 - 28 - 8, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo( rect.size.height);
            }];
        });
    });
    
    _descLabel.text = entityModel.name;
    _favouriteLabel.text = [NSString stringWithFormat:@"%ld 喜欢", entityModel.favouriteNum];
    
    if (entityModel.imgsArr.count) {
        _imgView.image = [entityModel.imgsArr firstObject];
    } else {
        [_imgView sd_setImageWithURL:[NSURL URLWithString:entityModel.templateCover] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, image.size.width, image.size.height) cornerRadius:12];
            [path addClip];
            [image drawAtPoint:CGPointZero];
            if ([entityModel.entityType isEqualToString:@"audio"]) {
                UIImage *audioImage = [UIImage imageNamed:@"audio"];
                CGFloat originX = (image.size.width - 128) / 2.0;
                CGFloat originY = (image.size.height - 128) / 2.0;
                [audioImage drawInRect:CGRectMake(originX, originY, 128, 128)];
            } else if ([entityModel.entityType isEqualToString:@"video"]) {
                UIImage *videoImage = [UIImage imageNamed:@"video"];
                CGFloat originX = (image.size.width - 128) / 2.0;
                CGFloat originY = (image.size.height - 128) / 2.0;
                [videoImage drawInRect:CGRectMake(originX, originY, 128, 128)];
            }
            UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.imgView.image = clipImage;
            });
            entityModel.imgsArr = [NSMutableArray arrayWithObject:clipImage];
        }];
    }
}

@end
