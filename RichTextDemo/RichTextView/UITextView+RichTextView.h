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
 *  所有的图片（RichTextAttachment）
 */
@property (nonatomic, readonly, strong) NSArray *richTextAttachments;

/**
 *  需要上传的图片（RichTextAttachment）
 */
@property (nonatomic, readonly, strong) NSArray *needUpdloadAttachments;

/**
 *  插入图片
 *
 *  @param image <#image description#>
 */
- (void)insertImageToSelected:(UIImage *)image;

@end