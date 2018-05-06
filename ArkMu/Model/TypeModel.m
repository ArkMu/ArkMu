//
//  TypeModel.m
//  ArkMu
//
//  Created by Sky on 2018/5/5.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "TypeModel.h"

@implementation TypeModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        self.type = [dict valueForKey:@"type"];
        self.title = [dict valueForKey:@"title"];
        self.url = [dict valueForKey:@"url"];
        self.cover = [dict valueForKey:@"cover"];
        
        self.coverArr = [NSArray array];
        
        self.entityId = [[dict valueForKey:@"entity_id"] integerValue];
    }
    
    return self;
}

@end
