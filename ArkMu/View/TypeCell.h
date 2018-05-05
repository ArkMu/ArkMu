//
//  TypeCell.h
//  ArkMu
//
//  Created by Sky on 2018/5/5.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TypeModel;

@interface TypeCell : UITableViewCell

@property (nonatomic, strong) NSArray <TypeModel *> *typeArr;

@property (nonatomic, copy) void (^gotoWebView)(NSString *urlStr);

@end
