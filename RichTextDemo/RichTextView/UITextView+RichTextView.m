//
//  UITextView+RichTextView.m
//  RichTextDemo
//
//  Created by Benster on 15/11/4.
//  Copyright © 2015年 Benster. All rights reserved.
//

#import "UITextView+RichTextView.h"
#import "RichTextUtility.h"

#define kImagePathRegx      @"<\\s*img\\s+[^>]*?src\\s*=\\s*[\'\"](.*?)[\'\"]\\s*(alt=[\'\"](.*?)[\'\"])?[^>]*?\\/?\\s*>"

@implementation UITextView (RichTextView)

#pragma mark - Class Methods

#pragma mark - 转换 文本
- (NSAttributedString *)parseAttributedContentFromRichTextString:(NSString *)aRichTextString
{
    if ([RichTextUtility isNullValue:aRichTextString]) return nil;
    
    NSDictionary *textAttributes = @{};
    NSMutableAttributedString *textAttributedString = [[NSMutableAttributedString alloc] initWithString:aRichTextString attributes:textAttributes];
    
    return textAttributedString;
}

#pragma mark - 转换 图片
- (NSAttributedString *)parseImageDataFromRichTextImageInfo:(RichTextAttachment *)richTextAtt
{
    NSMutableAttributedString *imageAttribut = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:richTextAtt]];
    
    return imageAttribut;
}

#pragma mark - 解析所有图片
- (NSArray *)parseImageRichString:(NSString *)aRichTextString
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
            NSString *imagePath = [aRichTextString substringWithRange:[result rangeAtIndex:1]];
            if (!imageName || [imageName isKindOfClass:[NSNull class]]) continue;
            if (!imagePath || [imagePath isKindOfClass:[NSNull class]]) continue;
            
            NSLog(@"ImageName = %@\rImagePath = %@", imageName, imagePath);
            RichTextAttachment *imageAtt = [[RichTextAttachment alloc] init];
            imageAtt.imageName = imageName;
            imageAtt.imagePath = imagePath;
            imageAtt.image = [UIImage imageNamed:imageAtt.imagePath];
            
            //计算 图片大小
            CGFloat imageWidth = imageAtt.image.size.width;
            CGFloat imageHeight = imageAtt.image.size.height;
            
            CGFloat imageMaxWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - 10;
            
            if (imageWidth > imageMaxWidth) {
                imageWidth = imageMaxWidth;
                imageHeight = imageMaxWidth*imageAtt.image.size.height / imageAtt.image.size.width;
            }
            
            imageAtt.bounds = CGRectMake(0, 0, imageWidth, imageHeight);
            
            [images addObject:imageAtt];
        }
    }
    
    return images;
}

#pragma mark - Attributes Getter

#pragma mark - Getter 所有的图片（RichTextAttachment）
- (NSArray *)richTextAttachments
{
    NSMutableArray *richTextAttachments = [[NSMutableArray alloc] init];
    
    [self.attributedText enumerateAttribute:NSAttachmentAttributeName
                                    inRange:NSMakeRange(0, self.attributedText.length)
                                    options:0
                                 usingBlock:^(id value, NSRange range, BOOL *stop) {
                                     if (value && [value isKindOfClass:[RichTextAttachment class]]) {
                                         [richTextAttachments addObject:value];
                                     }
                                 }];
    
    return richTextAttachments;
}

#pragma mark - Getter 需要上传的图片（RichTextAttachment）
- (NSArray *)needUpdloadAttachments
{
    NSMutableArray *needUploadTextAttachments = [[NSMutableArray alloc] init];
    
    [self.richTextAttachments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RichTextAttachment *richTextAttachment = (RichTextAttachment *)obj;
        if ([RichTextUtility isNullValue:richTextAttachment.imagePath]) {
            [needUploadTextAttachments addObject:richTextAttachment];
        }
    }];
    
    return needUploadTextAttachments;
}

#pragma mark - Getter attributesString
- (NSString *)attributedString
{
    NSMutableAttributedString *parseAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    [parseAttributedString enumerateAttribute:NSAttachmentAttributeName
                                      inRange:NSMakeRange(0, parseAttributedString.length)
                                      options:0
                                   usingBlock:^(id value, NSRange range, BOOL *stop) {
                                       if (value && [value isKindOfClass:[RichTextAttachment class]]) {
                                           RichTextAttachment *richTextAtt = (RichTextAttachment *)value;
                                           NSString *imageName = richTextAtt.imageName;
                                           
                                           if ([RichTextUtility isNullValue:imageName]) {
                                               imageName = [NSString stringWithFormat:@"%@", imageName];
                                           }
                                           
                                           NSAttributedString *imageAttributedString = [self parseAttributedContentFromRichTextString:imageName];
                                           
                                           [parseAttributedString replaceCharactersInRange:range
                                                                      withAttributedString:imageAttributedString];
                                       }
                                   }];
    
    NSString *attString = parseAttributedString.string;
    if (!attString || [attString isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    NSMutableString *parseString = [[NSMutableString alloc] initWithString:attString];
    
    return parseString;
}

- (void)setAttributedString:(NSString *)attributedString
{
    NSString *richTextString = attributedString;
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    if (richTextString && [richTextString isKindOfClass:[NSString class]]) {
        
        NSAttributedString *stringAtt = [self parseAttributedContentFromRichTextString:richTextString];
        [result appendAttributedString:stringAtt];
        
        NSArray *images = [NSArray arrayWithArray:[self parseImageRichString:richTextString]];
        
        //替换所有的图片
        for (RichTextAttachment *imageAtt in images) {
            NSAttributedString *imageAttString = [self parseImageDataFromRichTextImageInfo:imageAtt];
            NSRange imageRange = [result.string rangeOfString:imageAtt.imageName];
            //            NSLog(@"%@ \r range = %@", imageAtt.imageName, NSStringFromRange(imageRange));
            [result replaceCharactersInRange:imageRange withAttributedString:imageAttString];
        }
    }
    
    self.attributedText = result;
}

#pragma mark -
#pragma mark - 插入图片
- (void)insertImageToSelected:(UIImage *)image
{
    RichTextAttachment *imageAtt = [[RichTextAttachment alloc] init];
    
    int nowTime = [[NSDate date] timeIntervalSince1970];
    int rand = ((arc4random() % 100) + 1);
    long randNum = (nowTime * 100)  + rand;
    
    imageAtt.imageId = [NSString stringWithFormat:@"%li", randNum];
    
    imageAtt.image = image;
    
    //计算 图片大小
    CGFloat imageWidth = imageAtt.image.size.width;
    CGFloat imageHeight = imageAtt.image.size.height;
    
    CGFloat imageMaxWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - 10;
    
    if (imageWidth > imageMaxWidth) {
        imageWidth = imageMaxWidth;
        imageHeight = imageMaxWidth*imageAtt.image.size.height / imageAtt.image.size.width;
    }
    
    imageAtt.bounds = CGRectMake(0, 0, imageWidth, imageHeight);
    
    NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:imageAtt];
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [result insertAttributedString:imageAttributedString atIndex:self.selectedRange.location];
    
    self.attributedText = result;
}

@end
