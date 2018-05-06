//
//  AFShareManager.m
//  ArkMu
//
//  Created by Sky on 2018/5/6.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "AFShareManager.h"

#import <AFHTTPSessionManager.h>

@interface AFShareManager ()

@end

@implementation AFShareManager

+ (instancetype)shareManager {
    static AFShareManager *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[AFShareManager alloc] init];
    });
    
    return shareManager;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.sessionManager = [AFHTTPSessionManager manager];
        self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

@end
