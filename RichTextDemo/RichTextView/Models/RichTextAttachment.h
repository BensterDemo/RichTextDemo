//
//  RichTextAttachment.h
//  RichTextDemo
//
//  Created by Benster on 15/11/4.
//  Copyright © 2015年 Benster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RichTextAttachment : NSTextAttachment

@property (nonatomic, strong) NSString *imageFullName;      //图片全名 <img src = "http://file.31huiyi.com/image/template.png" />

@property (nonatomic, strong) NSString *imageName;          //图片名 template.png

@property (nonatomic, strong) NSString *imagePath;          //图片路径 http://file.31huiyi.com/image/template.png


#pragma mark - Methods

/**
 *  自适应图片
 *
 *  @param maxWidth 图片最大宽度
 */
- (void)sizeThatFits:(CGFloat)maxWidth;

@end
