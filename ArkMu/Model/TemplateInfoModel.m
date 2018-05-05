//
//  TemplateInfoModel.m
//  ArkMu
//
//  Created by Sky on 2018/5/5.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "TemplateInfoModel.h"

@implementation TemplateInfoModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        self.templateType = [dict valueForKey:@"template_type"];
        self.templateTitle = [dict valueForKey:@"template_title"];
        self.templateTitleIsSame = [dict valueForKey:@"template_title_isSame"];
        self.templateCoverArr = [dict valueForKey:@"template_cover"];
    }
    
    return self;
}

@end
