//
//  ColumnModel.m
//  ArkMu
//
//  Created by Sky on 2018/5/4.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "ColumnModel.h"

@implementation ColumnModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.columnId = [[dict valueForKey:@"id"] integerValue];
        self.name = [dict valueForKey:@"name"];
        self.bgcolor = [dict valueForKey:@"bg_color"];
        self.type = [dict valueForKey:@"type"];
    }
    
    return self;
}

@end
