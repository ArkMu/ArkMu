//
//  StreamModel.h
//  ArkMu
//
//  Created by Sky on 2018/5/4.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EntityModel;
@class ColumnModel;

@interface StreamModel : NSObject

@property (nonatomic, assign) NSInteger streamId;
@property (nonatomic, assign) NSInteger feedId;
@property (nonatomic, strong) NSString *entityType;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *templateType;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *imgsArr;
@property (nonatomic, strong) NSArray *entityArr;
@property (nonatomic, assign) NSInteger entityId;
@property (nonatomic, strong) ColumnModel *columnModel;
@property (nonatomic, assign) NSInteger favouriteNum;
@property (nonatomic, strong) NSString *publishedAtTime;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
