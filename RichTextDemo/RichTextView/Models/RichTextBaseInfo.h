//
//  RichTextBaseInfo.h
//  RichTextDemo
//
//  Created by Benster on 15/9/16.
//  Copyright (c) 2015年 Benster. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RichTextTextType     = 0,           //文本
    RichTextImageType    = 1,           //图片
    RichTextLinkTextType = 2            //链接
    
} RichTextType;

@interface RichTextBaseInfo : NSObject

@property (nonatomic, assign) RichTextType richTextType;        //富文本类型类型

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary *)aDictionary;

@end
