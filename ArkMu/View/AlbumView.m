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


@end
