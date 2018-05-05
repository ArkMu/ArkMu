//
//  TemplateInfoModel.h
//  ArkMu
//
//  Created by Sky on 2018/5/5.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemplateInfoModel : NSObject

@property (nonatomic, strong) NSString *templateType;
@property (nonatomic, strong) NSString *templateTitle;
@property (nonatomic, strong) NSString *templateTitleIsSame;
@property (nonatomic, strong) NSArray *templateCoverArr;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
