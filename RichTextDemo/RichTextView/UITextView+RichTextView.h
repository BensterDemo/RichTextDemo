//
//  UITextView+RichTextView.h
//  RichTextDemo
//
//  Created by Benster on 15/11/4.
//  Copyright © 2015年 Benster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RichTextAttachment.h"

@interface UITextView (RichTextView)

#pragma mark - Attributes

/**
 *  富文本
 */
@property (nonatomic, strong) NSString *attributedString;

/**
 *  文本样式
 */
@property (nonatomic, strong) NSDictionary *textAttributes;

/**
 *  所有的图片（RichTextAttachment）
 */
@property (nonatomic, readonly, strong) NSArray *richTextAttachments;

/**
 *  插入图片
 *
 *  @param image <#image description#>
 */
- (void)insertImageToSelected:(UIImage *)image;

@end
