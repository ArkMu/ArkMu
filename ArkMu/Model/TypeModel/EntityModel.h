//
//  EntityModel.h
//  ArkMu
//
//  Created by Sky on 2018/5/6.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntityModel : NSObject

@property (nonatomic, assign) NSInteger tempId;
@property (nonatomic, assign) NSInteger entityId;
@property (nonatomic, strong) NSString  *entityType;
@property (nonatomic, strong) NSString  *templateType;
@property (nonatomic, strong) NSString  *templateTitle;
@property (nonatomic, strong) NSString  *templateCover;

@property (nonatomic, strong) NSMutableArray *imgsArr;

@property (nonatomic, strong) NSString  *name;
@property (nonatomic, assign) NSInteger favouriteNum;

@property (nonatomic, strong) NSArray *entityArr;

@property (nonatomic, strong) NSString *publishedAt;
+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
