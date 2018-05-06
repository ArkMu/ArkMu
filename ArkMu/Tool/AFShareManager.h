//
//  AFShareManager.h
//  ArkMu
//
//  Created by Sky on 2018/5/6.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFHTTPSessionManager.h>

@interface AFShareManager : NSObject

+ (instancetype)shareManager;

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end
