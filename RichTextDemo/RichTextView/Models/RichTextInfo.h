//
//  RichTextInfo.h
//  RichTextDemo
//
//  Created by Benster on 15/9/16.
//  Copyright (c) 2015年 Benster. All rights reserved.
//

#import "RichTextBaseInfo.h"

@interface RichTextInfo : RichTextBaseInfo

@property (nonatomic, assign) CGFloat size;         //字体大小

@property (nonatomic, strong) UIColor *color;       //字体颜色

@property (nonatomic, strong) NSString *text;       //文本

@end
