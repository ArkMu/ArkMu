//
//  StreamModel.m
//  ArkMu
//
//  Created by Sky on 2018/5/4.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "StreamModel.h"

#import "EntityModel.h"
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
        self.entityArr = [NSArray array];
        NSArray *entityArr = [[dict valueForKey:@"extra"] valueForKey:@"entity_list"];
        if (![entityArr isKindOfClass:[NSNull class]]) {
            NSMutableArray *mArr = [NSMutableArray array];
            for (int i = 0; i < entityArr.count; i++) {
                NSDictionary *dict = entityArr[i];
                EntityModel *model = [EntityModel modelWithDictionary:dict];
                [mArr addObject:model];
            }
            self.entityArr = mArr;
        }
        
        self.columnModel = NULL;
        NSDictionary *columnDict = [dict valueForKey:@"column"];
        if (![columnDict isKindOfClass:[NSNull class]]) {
            self.columnModel = [ColumnModel modelWithDictionary:columnDict];
        }
        self.favouriteNum = [[dict valueForKey:@"favourite_num"] integerValue];
        self.publishedAtTime = [dict valueForKey:@"published_at"];
    }
    
    return self;
}

@end
