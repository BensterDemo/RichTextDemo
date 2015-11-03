//
//  RichTextParser.m
//  RichTextDemo
//
//  Created by Benster on 15/9/16.
//  Copyright (c) 2015年 Benster. All rights reserved.
//

#import "RichTextParser.h"
#import "RichTextInfo.h"
#import "RichTextImageInfo.h"

#define kImgPlaceholder     0xFFFC

@implementation RichTextParser

+ (NSAttributedString *)loadTemplateJson:(NSString *)aJsonString
                              imageArray:(NSMutableArray *)imageArray
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    if (aJsonString) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:[aJsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:NSJSONReadingAllowFragments
                                                           error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in array) {
                RichTextBaseInfo *baseInfo = [[RichTextBaseInfo alloc] initWithDictionary:dict];
                if (RichTextTextType == baseInfo.richTextType) {
                    /**
                     *  Text
                     */
                    RichTextInfo *richTextInfo = [[RichTextInfo alloc] initWithDictionary:dict];
                    NSAttributedString *stringAtt = [self parseAttributedContentFromRichTextInfo:richTextInfo];
                    [result appendAttributedString:stringAtt];
                } else if (RichTextImageType == baseInfo.richTextType) {
                    /**
                     *  创建 CoreTextImageData
                     */
                    RichTextImageInfo *imageData = [[RichTextImageInfo alloc] init];
                    imageData.name = dict[@"name"];
                    imageData.position = [result length];
                    [imageArray addObject:imageData];
                    // 创建空白占位符，并且设置它的CTRunDelegate信息
                    NSAttributedString *imageAtt = [self parseImageDataFromRichTextImageInfo:imageData];
                    [result appendAttributedString:imageAtt];
                }
            }
        }
    }
    
    return result;
}

#pragma mark - 转换 文本
+ (NSAttributedString *)parseAttributedContentFromRichTextInfo:(RichTextInfo *)aRichTextInfo
{
    return [[NSAttributedString alloc] initWithString:aRichTextInfo.text attributes:@{}];
}

#pragma mark - 转换 图片
+ (NSAttributedString *)parseImageDataFromRichTextImageInfo:(RichTextImageInfo *)richTextImageInfo
{
    //setImage
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:richTextImageInfo.name];
    
    //计算 图片大小
    CGFloat imageWidth = textAttachment.image.size.width;
    CGFloat imageHeight = textAttachment.image.size.height;
    
    if (imageWidth > 80) {
        imageWidth = 80;
        imageHeight = 80*textAttachment.image.size.height/textAttachment.image.size.width;
    }
    if (imageHeight > 80) {
        imageWidth = 80*textAttachment.image.size.width/textAttachment.image.size.height;
        imageHeight = 80;
    }
    textAttachment.bounds = CGRectMake(0, 0, imageWidth, imageHeight);
    
    NSMutableAttributedString *imageAttribut = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
    
    // 使用0xFFFC作为空白的占位符
    unichar objectReplacementChar = kImgPlaceholder;
    NSString * replaceString = [NSString stringWithCharacters:&objectReplacementChar length:1];
    [imageAttribut replaceCharactersInRange:NSMakeRange(0,1) withString:replaceString];
    
    return imageAttribut;
}

#pragma mark - 转换成string
+ (NSString *)parseAttributedString:(NSAttributedString *)attributedString
{
    NSMutableString *string = [[NSMutableString alloc] initWithString:attributedString.string];
    unichar objectReplacementChar = kImgPlaceholder;
    [string replaceCharactersInRange:[string rangeOfString:[NSString stringWithCharacters:&objectReplacementChar length:1]]
                          withString:@"<img>"];
    return string;
}

@end
