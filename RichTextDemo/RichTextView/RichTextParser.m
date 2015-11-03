//
//  RichTextParser.m
//  RichTextDemo
//
//  Created by Benster on 15/9/16.
//  Copyright (c) 2015年 Benster. All rights reserved.
//

#import "RichTextParser.h"
#import "RichTextImageInfo.h"

#define kImgPlaceholder     0xFFFC

#define kImagePathRegx      @"<\\s*img\\s+[^>]*?src\\s*=\\s*[\'\"](.*?)[\'\"]\\s*(alt=[\'\"](.*?)[\'\"])?[^>]*?\\/?\\s*>"

@implementation RichTextParser

+ (NSAttributedString *)loadRichTextString:(NSString *)aRichTextString
                                imageArray:(NSMutableArray *)images
{
    NSString *richTextString = aRichTextString;
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    if (richTextString && [richTextString isKindOfClass:[NSString class]]) {
        
        NSAttributedString *stringAtt = [self parseAttributedContentFromRichTextInfo:richTextString];
        [result appendAttributedString:stringAtt];
        
        [images addObjectsFromArray:[RichTextParser parseRichTextString:richTextString]];
        
        //替换所有的图片
        for (RichTextImageInfo *imageInfo in images) {
            NSAttributedString *imageAtt = [self parseImageDataFromRichTextImageInfo:imageInfo];
            NSRange imageRange = [result.string rangeOfString:imageInfo.imageName];
            NSLog(@"%@ \r range = %@", imageInfo.imageName, NSStringFromRange(imageRange));
            [result replaceCharactersInRange:imageRange withAttributedString:imageAtt];
        }
    }
    
    return result;
}

#pragma mark - 提取所有图片
+ (NSArray *)parseRichTextString:(NSString *)aRichTextString
{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kImagePathRegx
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSArray *results = [regex matchesInString:aRichTextString
                                      options:0
                                        range:NSMakeRange(0, [aRichTextString length])];
    
    for (NSTextCheckingResult *result in results) {
        if (result) {
            NSString *imageName = [aRichTextString substringWithRange:[result rangeAtIndex:0]];
            if (!imageName || [imageName isKindOfClass:[NSNull class]]) continue;
            
            NSLog(@"ImageName = %@", imageName);
            RichTextImageInfo *richTextImageInfo = [[RichTextImageInfo alloc] initWithImgTagString:imageName];
            
            [images addObject:richTextImageInfo];
        }
    }
    
    return images;
}

#pragma mark - 转换 文本
+ (NSAttributedString *)parseAttributedContentFromRichTextInfo:(NSString *)aRichTextString
{
    return [[NSAttributedString alloc] initWithString:aRichTextString attributes:@{}];
}

#pragma mark - 转换 图片
+ (NSAttributedString *)parseImageDataFromRichTextImageInfo:(RichTextImageInfo *)richTextImageInfo
{
    //setImage
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:richTextImageInfo.imagePath];
    
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
                         imageArray:(NSArray *)images
{
    NSString *attString = attributedString.string;
    if (!attString || [attString isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    NSMutableString *parseString = [[NSMutableString alloc] initWithString:attString];
    
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RichTextImageInfo *richTextImageInfo = (RichTextImageInfo *)obj;
        NSString *imageString = [NSString stringWithFormat:@"<img src = \"%@\">", richTextImageInfo.imagePath];
        
        unichar objectReplacementChar = kImgPlaceholder;
        NSString * replaceString = [NSString stringWithCharacters:&objectReplacementChar
                                                           length:1];
        
        [parseString replaceCharactersInRange:[parseString rangeOfString:replaceString]
                                   withString:imageString];
    }];
    
    return parseString;
}

@end
