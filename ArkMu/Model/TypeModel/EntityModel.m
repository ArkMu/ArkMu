//
//  EntityModel.m
//  ArkMu
//
//  Created by Sky on 2018/5/6.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "EntityModel.h"

@implementation EntityModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        self.tempId = [[dict valueForKey:@"id"] integerValue];
        self.entityId = [[dict valueForKey:@"entity_id"] integerValue];
        self.entityType = [dict valueForKey:@"entity_type"];
        NSDictionary *templateDict = [dict valueForKey:@"template_info"];
        self.templateTitle = [templateDict valueForKey:@"template_title"];
        self.templateType = [templateDict valueForKey:@"template_type"];
        self.templateCover = [[templateDict valueForKey:@"template_cover"] firstObject];
        NSDictionary *columnDic = [dict valueForKey:@"column"];
        if ([columnDic isKindOfClass:[NSDictionary class]]) {
            self.name = [columnDic valueForKey:@"name"];
        }
        self.publishedAt = [dict valueForKey:@"published_at"];
        self.favouriteNum = [[dict valueForKey:@"favourite_num"] integerValue];
        self.entityArr = [NSArray array];
    }
    
    return self;
}

@end
