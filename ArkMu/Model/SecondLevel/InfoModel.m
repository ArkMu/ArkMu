//
//  InfoModel.m
//  ArkMu
//
//  Created by Sky on 2018/5/6.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "InfoModel.h"

@implementation InfoModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        self.infoId = [[dict valueForKey:@"id"] integerValue];
        self.infoTitle = [dict valueForKey:@"title"];
        self.summary = [dict valueForKey:@"summary"];
        self.content = [dict valueForKey:@"content"];
        self.sourceType = [dict valueForKey:@"source_type"];
        self.sourceUrls = [dict valueForKey:@"source_urls"];
        self.relatedPostIds = [dict valueForKey:@"related_post_ids"];
        self.extractionTags = [dict valueForKey:@"extraction_tags"];
    }
    
    return self;
}

@end
