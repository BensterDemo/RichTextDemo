//
//  RichTextAttachment.m
//  RichTextDemo
//
//  Created by Benster on 15/11/4.
//  Copyright © 2015年 Benster. All rights reserved.
//

#import "RichTextAttachment.h"

@implementation RichTextAttachment

- (void)setShowImage:(UIImage *)showImage
{
    self.image = showImage;

    //计算 图片大小
    CGFloat imageWidth = self.image.size.width;
    CGFloat imageHeight = self.image.size.height;
    
    //最大宽度，两边默认有白边
    CGFloat imageMaxWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - 10;
    
    if (imageWidth > imageMaxWidth) {
        imageWidth = imageMaxWidth;
        imageHeight = imageMaxWidth*self.image.size.height / self.image.size.width;
    }
    
    self.bounds = CGRectMake(0, 0, imageWidth, imageHeight);
}

@end
