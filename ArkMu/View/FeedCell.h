//
//  FeedCell.h
//  ArkMu
//
//  Created by Sky on 2018/5/5.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeedModel;

@interface FeedCell : UITableViewCell

@property (nonatomic, strong) NSArray<FeedModel *>  *feedArr;

@property (nonatomic, copy) void (^gotoWebView)(NSInteger entityId);

- (void)updateImageState;

@end
