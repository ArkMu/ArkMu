//
//  InfoModel.h
//  ArkMu
//
//  Created by Sky on 2018/5/6.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoModel : NSObject

@property (nonatomic, assign) NSInteger infoId;
@property (nonatomic, strong) NSString  *infoTitle;
@property (nonatomic, strong) NSString  *summary;
@property (nonatomic, strong) NSString  *content;
@property (nonatomic, strong) NSString  *cover;
@property (nonatomic, strong) NSString  *sourceType;
@property (nonatomic, strong) NSString  *sourceUrls;
@property (nonatomic, strong) NSArray  *relatedPostIds;
@property (nonatomic, strong) NSArray  *extractionTags;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
