
//
//  TagModel.m
//  ArkMu
//
//  Created by Sky on 2018/5/6.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "TagModel.h"

@implementation TagModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        self.tagId = [[dict valueForKey:@"id"] integerValue];
        self.tagName = [dict valueForKey:@"name"];
    }
    
    return self;
}

@end
