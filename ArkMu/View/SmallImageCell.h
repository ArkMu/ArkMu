//
//  SmallImageCell.h
//  ArkMu
//
//  Created by Sky on 2018/5/5.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StreamModel;

@class EntityModel;

@interface SmallImageCell : UITableViewCell

@property (nonatomic, strong) StreamModel *streamModel;

@property (nonatomic, strong) EntityModel *entityModel;

@end
