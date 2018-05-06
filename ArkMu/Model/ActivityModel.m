//
//  ActivityModel.m
//  ArkMu
//
//  Created by Sky on 2018/5/6.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        self.activityId = [[dict valueForKey:@"id"] integerValue];
        self.state = [dict valueForKey:@"state"];
        self.cover = [dict valueForKey:@"cover"];
        self.coverPopup = [dict valueForKey:@"cover_popup"];
        self.coverPopupShow = [dict valueForKey:@"cover_popup_show"];
        self.subject = [dict valueForKey:@"subject"];
        self.url = [dict valueForKey:@"url"];
        self.publishedAt = [dict valueForKey:@"published_at"];
        self.imgsArr = [NSMutableArray array];
    }
    
    return self;
}

@end
