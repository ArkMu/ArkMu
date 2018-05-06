//
//  VideoModel.h
//  ArkMu
//
//  Created by Sky on 2018/5/6.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TagModel;

@interface VideoModel : NSObject

@property (nonatomic, assign) NSInteger videoId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *format;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) NSInteger bitrate;
@property (nonatomic, assign) NSInteger filesize;
@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, strong) NSString *summary;

@property (nonatomic, strong) NSArray <TagModel *> *tagsArr;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
