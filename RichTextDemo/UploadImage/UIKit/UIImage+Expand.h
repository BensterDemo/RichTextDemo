//
//  UIImage+Expand.h
//  QianDao
//
//  Created by Benster on 15/3/9.
//  Copyright (c) 2015年 31HuiYi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface UIImage (Expand)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)screenShot;

+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/**
 *  缩放图片
 *
 *  @param newSize 目标图片大小
 *
 *  @return <#return value description#>
 */
- (UIImage *)imagescaledToSize:(CGSize)newSize;

/**
 *  顺时针旋转90°
 *
 *  @return <#return value description#>
 */
- (UIImage *)rotateImage;



@end

typedef NS_ENUM(NSInteger, IconLevel){
    IconLevelHigh,
    IconLevelMiddle,
    IconLevelLow
};

extern UIImage *ImageTextWidth(NSString* text ,CGFloat width,IconLevel level);
extern UIImage *ImageTextWidthBack(NSString* text ,CGFloat width,IconLevel level,BOOL aNeedBackImage);
