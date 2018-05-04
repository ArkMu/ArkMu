//
//  ColumnModel.h
//  ArkMu
//
//  Created by Sky on 2018/5/4.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColumnModel : NSObject

@property (nonatomic, assign) NSInteger columnId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *bgcolor;
@property (nonatomic, strong) NSString *type;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
