//
//  RichTextAttachment.h
//  RichTextDemo
//
//  Created by Benster on 15/11/4.
//  Copyright © 2015年 Benster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RichTextAttachment : NSTextAttachment

@property (nonatomic, strong) NSString *imageId;            //需要上传的图片有

@property (nonatomic, strong) NSString *imageName;          //图片名

@property (nonatomic, strong) NSString *imagePath;          //图片路径

@property (nonatomic, strong) UIImage *showImage;           //显示的图片，自适应（最大宽度为屏幕宽度 - 10）

@end
