//
//  UIImage+ClipImage.m
//  ArkMu
//
//  Created by Sky on 2018/5/7.
//  Copyright © 2018年 Sky. All rights reserved.
//

#import "UIImage+ClipImage.h"

@implementation UIImage (ClipImage)

- (UIImage *)clipImageWithCornerRadius:(CGFloat)radius {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.size.width, self.size.height) cornerRadius:radius];
    [path addClip];
    [self drawAtPoint:CGPointZero];
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return clipImage;
}

@end
