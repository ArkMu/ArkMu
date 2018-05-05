//
//  MonoGraphicCell.m
//  ArkMu
//
//  Created by Sky on 2018/5/5.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "MonoGraphicCell.h"

#import "Common.h"
#import "StreamModel.h"
#import <Masonry.h>

@interface MonoGraphicCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation MonoGraphicCell

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
        CGRect rect = [streamModel.title boundingRectWithSize:CGSizeMake(frame.size.width - 28, 80) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: AKCustomFont(17)} context:nil];
        __weak typeof(weakSelf) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(rect.size.height);
            }];
        });
    });
    
    NSString *urlStr = streamModel.imgsArr.firstObject;
    if ([urlStr isKindOfClass:[NSString class]]) {
        __weak typeof(self) weakSelf = self;
        __block StreamModel *blockModel = streamModel;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
            UIImage *img = [UIImage imageWithData:imgData];
            UIGraphicsBeginImageContextWithOptions(img.size, NO, 0);
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, frame.size.width - 28, img.size.height) cornerRadius:12];
            [path addClip];
            [img drawAtPoint:CGPointZero];
            UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.imgView.image = clipImage;
                blockModel.imgsArr = [NSArray arrayWithObject:clipImage];
            });
        });
    } else {
        self.imgView.image = (UIImage *)streamModel.imgsArr.firstObject;
    }
    
    _timeLabel.text = [NSString stringWithFormat:@"%@", streamModel.publishedAtTime];
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
