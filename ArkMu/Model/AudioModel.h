//
//  AudioModel.h
//  ArkMu
//
//  Created by Sky on 2018/5/7.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioModel : NSObject

@property (nonatomic, assign) NSInteger audioId;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *format;
@property (nonatomic, strong) NSString  *cover;
@property (nonatomic, strong) NSString  *url;
@property (nonatomic, assign) NSInteger filesize;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSString  *userName;
@property (nonatomic, strong) NSString  *userAvtarUrl;

@property (nonatomic, strong) NSArray *coverArr;
@property (nonatomic, strong) NSArray *avtarArr;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
