//
//  EntityModel.m
//  ArkMu
//
//  Created by Sky on 2018/5/5.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "EntityModel.h"

#import "TemplateInfoModel.h"

@implementation EntityModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        self.entityId = [[dict valueForKey:@"id"] integerValue];
        self.entityType = [dict valueForKey:@"entity_type"];
        self.title = [dict valueForKey:@"title"];
        self.templateInfoModel = [TemplateInfoModel modelWithDictionary:[dict valueForKey:@"template_info"]];
        self.cover = [dict valueForKey:@"cover"];
        self.publishedAtTime = [dict valueForKey:@"published_at"];
    }
    
    return self;
}

@end
