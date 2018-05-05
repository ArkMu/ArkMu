//
//  AlbumView.m
//  ArkMu
//
//  Created by Sky on 2018/5/5.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "AlbumView.h"

#import "Common.h"
#import <Masonry.h>
#import "TemplateInfoModel.h"

@interface AlbumView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation AlbumView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    UIImageView *imgView = [[UIImageView alloc] init];
    [self addSubview:imgView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
}

- (void)setTemplateInfoModel:(TemplateInfoModel *)templateInfoModel {
    _templateInfoModel = templateInfoModel;
    
    if ([templateInfoModel.templateCoverArr.firstObject isKindOfClass:[NSString class]]) {
        __weak typeof(self) weakSelf = self;
        __block TemplateInfoModel *blockModel = templateInfoModel;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *urlStr = templateInfoModel.templateCoverArr.firstObject;
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
            UIImage *img = [UIImage imageWithData:imgData];
            UIGraphicsBeginImageContextWithOptions(img.size, NO, 0);
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, img.size.width, img.size.height) cornerRadius:8];
            [path addClip];
            [img drawAtPoint:CGPointMake(0, 0)];
            UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            dispatch_async(dispatch_get_main_queue(), ^{
                __weak typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.imgView.image = clipImage;
                blockModel.templateCoverArr = [NSArray arrayWithObject:clipImage];
            });
        });
    } else {
        self.imgView.image = templateInfoModel.templateCoverArr.firstObject;
    }
    
    _titleLabel.text = templateInfoModel.templateTitle;
}


@end
