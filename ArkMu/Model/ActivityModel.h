//
//  ActivityModel.h
//  ArkMu
//
//  Created by Sky on 2018/5/6.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject

@property (nonatomic, assign) NSInteger activityId;
@property (nonatomic, strong) NSString  *state;
@property (nonatomic, strong) NSString  *subject;
@property (nonatomic, strong) NSString  *cover;
@property (nonatomic, strong) NSString  *coverPopup;
@property (nonatomic, assign) BOOL      coverPopupShow;
@property (nonatomic, strong) NSString  *url;
@property (nonatomic, strong) NSString  *publishedAt;

@property (nonatomic, strong) NSMutableArray *imgsArr;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
