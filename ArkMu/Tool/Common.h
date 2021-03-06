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

#define AKFeedUrl       @"https://36kr.com/lapi/app-front/focus?feed_id=59&type=feed"
#define AKFeedSecond      @"https://36kr.com/lapi/app-front/focus?feed_id=59&type=feed_second_level"

#define AKPostUrlWithInfoId(infoId)   [NSString stringWithFormat:@"https://36kr.com/lapi/post/%lu?read=1", infoId]
#define AKAlbumEntityUrlWithEntityId(entityId) [NSString stringWithFormat:@"https://36kr.com/lapi/album-entity/%lu", entityId]
#define AKVideoUrlWithVideoId(videoId) [NSString stringWithFormat:@"https://36kr.com/lapi/video/%lu?read=1", videoId]
#define AKAudioUrlWithAudioId(audioId) [NSString stringWithFormat:@"https://36kr.com/lapi/audio/%lu?read=1", audioId]

#define AKActivityUrl   @"https://36kr.com/lapi/activity"

#define AKAudioBaseUrl  @"https://36kr.com/lapi/audio"

#define AKColor(r, g, b, a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]

#define AK102Color          AKColor(102,102,102,1)
#define AK204Color          AKColor(204,204,204,1)
#define AKBlackColor        AKColor(0,0,0,1)
#define AKWhiteColor        AKColor(255,255,255,1)
#define AKClearColor        AKColor(0,0,0,0)
#define AKBlueColor         AKColor(72,118,255,1)
#define AKLightBlueColor    AKColor(188,210,238,1)

#define AKSliverColor       AKColor(161,163,166,1)

#define AKAlphaColor(a)     AKColor(0,0,0,a)

#define AKLightGray         [UIColor lightGrayColor]
#define AKRedColor          [UIColor redColor]

#define AKLightCoral        AKColor(240,128,128,1)

#define AKCustomFont(f)     [UIFont systemFontOfSize:f]

#define AKScreenWidth       [[UIScreen mainScreen] bounds].size.width
#define AKScreenHeight      [[UIScreen mainScreen] bounds].size.height

#define AKScale             [[UIScreen mainScreen] scale]

#define AKTemplateSmallImage    @"small_image"
#define AKTemplateBigImage      @"big_image"
#define AKTemplateNoImage       @"no_image"
#define AKTemplateAlbum         @"album"
#define AKMultiImage            @"multi_image"

#endif /* Common_h */
