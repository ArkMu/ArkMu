//
//  EntityModel.h
//  ArkMu
//
//  Created by Sky on 2018/5/5.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TemplateInfoModel;

@interface EntityModel : NSObject

@property (nonatomic, assign) NSInteger entityId;
@property (nonatomic, strong) NSString *entityType;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) TemplateInfoModel *templateInfoModel;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *publishedAtTime;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
