//
//  NoImageCell.m
//  ArkMu
//
//  Created by Sky on 2018/5/5.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "NoImageCell.h"

#import "Common.h"
#import <Masonry.h>

#import "StreamModel.h"

@interface NoImageCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *typeLabel;

@end

@implementation NoImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = AKCustomFont(17);
    titleLabel.textColor = AKBlackColor;
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = AKCustomFont(14);
    timeLabel.textColor = AK102Color;
    [self addSubview:timeLabel];
    _timeLabel = timeLabel;
    
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.font = AKCustomFont(14);
    typeLabel.textColor = AKBlackColor;
    typeLabel.text = @"快讯";
    typeLabel.backgroundColor = AKLightBlueColor;
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.layer.cornerRadius = 4;
    typeLabel.layer.masksToBounds = YES;
    [self addSubview:typeLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = AK204Color;
    [self addSubview:lineView];
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(14);
        make.trailing.bottom.mas_equalTo(-14);
        make.height.mas_equalTo(1.0 / scale);
    }];
    
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(lineView);
        make.bottom.mas_equalTo(lineView.mas_top).mas_equalTo(-14 + 1.0 / scale);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(21);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(lineView);
        make.top.bottom.mas_equalTo(typeLabel);
        make.trailing.mas_equalTo(typeLabel.mas_leading).mas_equalTo(-8);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(14);
        make.trailing.mas_equalTo(-14);
        make.height.mas_equalTo(60).priority(1000);
        make.bottom.mas_equalTo(typeLabel.mas_top).mas_equalTo(-8).priority(100);
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
        paragraph.lineSpacing = 8;
        paragraph.firstLineHeadIndent = 0.0;
        paragraph.paragraphSpacingBefore = 0.0;
        paragraph.headIndent = 0.0;
        paragraph.tailIndent = 0.0;
        NSDictionary *dict = @{NSFontAttributeName: AKCustomFont(17), NSParagraphStyleAttributeName: paragraph};
        CGRect rect = [streamModel.title boundingRectWithSize:CGSizeMake(frame.size.width - 28 - 10, 80) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(rect.size.height).priority(1000);
            }];
        });
    });
    
    _timeLabel.text = streamModel.publishedAtTime;
}

@end
