//
//  StreamModel.m
//  ArkMu
//
//  Created by Sky on 2018/5/4.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "StreamModel.h"

#import "ColumnModel.h"

@implementation StreamModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.streamId = [[dict valueForKey:@"id"] integerValue];
        self.feedId = [[dict valueForKey:@"feed_id"] integerValue];
        self.entityType = [dict valueForKey:@"entity_type"];
        self.state = [dict valueForKey:@"state"];
        self.templateType = [dict valueForKey:@"template"];
        self.title = [dict valueForKey:@"title"];
        self.imgsArr = [dict valueForKey:@"images"];
        self.columnModel = NULL;
        NSDictionary *columnDict = [dict valueForKey:@"column"];
        if (![columnDict isKindOfClass:[NSNull class]]) {
            self.columnModel = [ColumnModel modelWithDictionary:columnDict];
        }
        self.favouriteNum = [[dict valueForKey:@"favourite_num"] integerValue];
    }
    
    return self;
}

@end
