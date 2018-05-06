//
//  VideoModel.m
//  ArkMu
//
//  Created by Sky on 2018/5/6.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "VideoModel.h"

#import "TagModel.h"

@implementation VideoModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        self.videoId = [[dict valueForKey:@"id"] integerValue];
        self.title = [dict valueForKey:@"title"];
        self.format = [dict valueForKey:@"format"];
        self.url = [dict valueForKey:@"url"];
        self.bitrate = [[dict valueForKey:@"bitrate"] integerValue];
        self.filesize = [[dict valueForKey:@"filesize"] integerValue];
        self.duration = [[dict valueForKey:@"duration"] integerValue];
        self.summary = [dict valueForKey:@"summary"];
        
        NSArray *tagsArr = [dict valueForKey:@"extraction_tags_arr"];
        if ([tagsArr isKindOfClass:[NSArray class]]) {
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dict in tagsArr) {
                TagModel *model = [TagModel modelWithDictionary:dict];
                [mArr addObject:model];
            }
            
            self.tagsArr = mArr;
        }
    }
    
    return self;
}

@end
