//
//  ThemeCell.m
//  ArkMu
//
//  Created by Sky on 2018/5/5.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "AlbumCell.h"

#import "Common.h"
#import <Masonry.h>

#import "StreamModel.h"

#import "AlbumView.h"

@interface AlbumCell ()

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *moreLabel;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation AlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.textColor = AKBlackColor;
    typeLabel.font = AKCustomFont(20);
    [self addSubview:typeLabel];
    _typeLabel = typeLabel;
    
    UILabel *moreLabel = [[UILabel alloc] init];
    moreLabel.textColor = AKBlackColor;
    moreLabel.font = AKCustomFont(18);
    [self addSubview:moreLabel];
    _moreLabel = moreLabel;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
//    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    scrollView.layer.borderColor = [UIColor redColor].CGColor;
    scrollView.layer.borderWidth = 1.f;
    _scrollView = scrollView;
    
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(14);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    
    [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(typeLabel);
        make.trailing.mas_equalTo(-14);
        make.height.mas_equalTo(typeLabel);
        make.leading.mas_equalTo(typeLabel.mas_trailing).mas_equalTo(8);
    }];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(typeLabel);
        make.top.mas_equalTo(typeLabel.mas_bottom);
        make.trailing.mas_equalTo(moreLabel);
        make.bottom.mas_equalTo(-14);
    }];
    
    return self;
}

- (void)setStreamModel:(StreamModel *)streamModel {
    _streamModel = streamModel;
    
    _typeLabel.text = streamModel.title;
    _moreLabel.text = @"更多";
    
    if ([streamModel.entityType isEqualToString:@"theme"]) {
        NSLog(@"streamModel");
    }
    
    
    
    for (int i = 0; i < streamModel.entityArr.count; i++) {
        AlbumView *view = [self.scrollView viewWithTag:10000 + i];
        if (view == nil) {
            view = [[AlbumView alloc] initWithFrame:CGRectMake(120 * 8, 0, 120, 120)];
            view.layer.borderColor = [UIColor redColor].CGColor;
            view.layer.borderWidth = 1.f;
            [self.scrollView addSubview:view];
            view.tag = 10000 + i;
        }
        
        view.templateInfoModel = streamModel.entityArr[i];
    }
    
    _scrollView.contentSize = CGSizeMake(130 * streamModel.entityArr.count, 130);
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
