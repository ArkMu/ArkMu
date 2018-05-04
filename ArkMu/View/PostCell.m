//
//  PostCell.m
//  ArkMu
//
//  Created by Sky on 2018/5/4.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "PostCell.h"

#import "Masonry.h"
#import "Common.h"

#import "StreamModel.h"
#import "ColumnModel.h"

@interface PostCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *favouriteLabel;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation PostCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    titleLabel.textColor = AK102Color;
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

- (void)setStreamModel:(StreamModel *)streamModel {
    _streamModel = streamModel;
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    CGRect rect = [streamModel.title boundingRectWithSize:CGSizeMake(frame.size.width - 28 - 8 - 112, 140) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0]} context:NULL];
    _titleLabel.text = streamModel.title;
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(rect.size.height);
    }];
    
    _descLabel.text = streamModel.columnModel.name;
    _favouriteLabel.text = [NSString stringWithFormat:@"%ld 喜欢", streamModel.favouriteNum];
    

    if (streamModel.imgsArr.count > 0) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:streamModel.imgsArr.firstObject]];
            UIImage *img = [UIImage imageWithData:data];
            UIGraphicsBeginImageContextWithOptions(img.size, NO, 0);
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, img.size.width, img.size.height) cornerRadius:12];
            [path addClip];
            [img drawAtPoint:CGPointZero];
            UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.imgView.image = clipImage;
            });
        });
    }
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
