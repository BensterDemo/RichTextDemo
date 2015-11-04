//
//  RichTextAttachment.h
//  RichTextDemo
//
//  Created by Benster on 15/11/4.
//  Copyright © 2015年 Benster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RichTextAttachment : NSTextAttachment

@property (nonatomic, strong) NSString *imageId;

@property (nonatomic, strong) NSString *imageName;          //图片名

@property (nonatomic, strong) NSString *imagePath;          //图片路径

@end
