//
//  RichTextUtils.h
//  RichTextDemo
//
//  Created by Benster on 15/9/16.
//  Copyright (c) 2015年 Benster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "RichTextData.h"
#import "RichTextLinkInfo.h"

@interface RichTextUtils : NSObject

//+ (RichTextLinkInfo *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(RichTextData *)data;

+ (CFIndex)touchContentOffsetInView:(UIView *)view atPoint:(CGPoint)point data:(RichTextData *)data;

@end
