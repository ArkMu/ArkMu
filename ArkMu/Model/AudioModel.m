//
//  AudioModel.m
//  ArkMu
//
//  Created by Sky on 2018/5/7.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "AudioModel.h"

@implementation AudioModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        self.audioId = [[dict valueForKey:@"id"] integerValue];
        self.title = [dict valueForKey:@"title"];
        self.format = [dict valueForKey:@"format"];
        self.cover = [dict valueForKey:@"cover"];
        self.url = [dict valueForKey:@"url"];
        self.filesize = [[dict valueForKey:@"filesize"] integerValue];
        self.duration = [[dict valueForKey:@"duration"] integerValue];
        self.createdAt = [dict valueForKey:@"created_at"];
        self.updatedAt = [dict valueForKey:@"updated_at"];
        NSDictionary *userDict = [dict valueForKey:@"column"];
        if ([userDict isKindOfClass:[NSDictionary class]]) {
            self.userName = [userDict valueForKey:@"name"];
            self.userAvtarUrl = [userDict valueForKey:@"cover"];
        } else {
            self.userName = @"";
            self.userAvtarUrl = @"";
        }
        
        self.coverArr = [NSArray array];
        self.avtarArr = [NSArray array];
    }
    
    return self;
}

@end
