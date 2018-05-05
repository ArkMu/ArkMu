//
//  BigImageCell.m
//  ArkMu
//
//  Created by Sky on 2018/5/5.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "BigImageCell.h"

#import "Common.h"
#import "StreamModel.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface BigImageCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation BigImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = AKCustomFont(17);
    titleLabel.textColor = AKBlackColor;
    titleLabel.numberOfLines = 0;
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    [self addSubview:imgView];
    _imgView = imgView;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = AKCustomFont(14);
    timeLabel.textColor = AK102Color;
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:timeLabel];
    _timeLabel = timeLabel;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = AK204Color;
    [self addSubview:lineView];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(14);
        make.trailing.bottom.mas_equalTo(-14);
        make.height.mas_equalTo(21);
    }];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(timeLabel);
        make.bottom.mas_equalTo(timeLabel.mas_top).mas_equalTo(-14);
        make.height.mas_equalTo(100);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(14);
        make.trailing.mas_equalTo(-14);
        make.height.mas_equalTo(60).priority(1000);
        make.bottom.mas_equalTo(imgView.mas_top).mas_equalTo(8).priority(100);
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

- (void)setStreamModel:(StreamModel *)streamModel {
    _streamModel = streamModel;
    
    _titleLabel.text = streamModel.title;
    CGRect frame = [[UIScreen mainScreen] bounds];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByCharWrapping;
        paragraph.alignment = NSTextAlignmentLeft;
        paragraph.lineSpacing = 6;
        paragraph.firstLineHeadIndent = 0.0;
        paragraph.paragraphSpacingBefore = 0.0;
        paragraph.headIndent = 0.0;
        paragraph.tailIndent = 0.0;
        NSDictionary *dict = @{NSFontAttributeName: AKCustomFont(17), NSParagraphStyleAttributeName: paragraph};
        CGRect rect = [streamModel.title boundingRectWithSize:CGSizeMake(frame.size.width - 28, 80) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        __weak typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(rect.size.height);
            }];
        });
    });
    
    NSString *urlStr = streamModel.imgsArr.firstObject;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, image.size.width, image.size.height) cornerRadius:12];
        [path addClip];
        [image drawAtPoint:CGPointZero];
        UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.imgView.image = clipImage;
            [strongSelf.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo((AKScreenWidth - 28) / clipImage.size.width * clipImage.size.height);
            }];
        });
    }];
    
    _timeLabel.text = [NSString stringWithFormat:@"%@", streamModel.publishedAtTime];
}

@end
