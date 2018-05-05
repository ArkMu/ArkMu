//
//  FeedModel.h
//  ArkMu
//
//  Created by Sky on 2018/5/5.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedModel : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *cover;

@property (nonatomic, strong) UIImage *coverImage;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
