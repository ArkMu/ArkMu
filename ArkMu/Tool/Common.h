//
//  Common.h
//  ArkMu
//
//  Created by Sky on 2018/5/4.
//  Copyright © 2018年 Sky. All rights reserved.
//

#ifndef Common_h
#define Common_h


#define AKStreamUrl     @"https://36kr.com/lapi/app-front/feed-stream?"
#define AKFocusUrl      @"https://36kr.com/lapi/app-front/focus?"

#define AKColor(r, g, b, a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]

#define AK102Color          AKColor(102,102,102,1)
#define AK204Color          AKColor(204,204,204,1)
#define AKBlackColor        AKColor(0,0,0,1)
#define AKWhiteColor        AKColor(255,255,255,1)
#define AKClearColor        AKColor(0,0,0,0)
#define AKBlueColor         AKColor(72,118,255,1)
#define AKLightBlueColor    AKColor(188,210,238,1)

#define AKLightGray         [UIColor lightGrayColor]

#define AKCustomFont(f)     [UIFont systemFontOfSize:f]

#endif /* Common_h */
