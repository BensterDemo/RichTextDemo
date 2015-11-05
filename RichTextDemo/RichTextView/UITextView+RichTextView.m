//
//  UITextView+RichTextView.m
//  RichTextDemo
//
//  Created by Benster on 15/11/4.
//  Copyright © 2015年 Benster. All rights reserved.
//

#import "UITextView+RichTextView.h"
#import "RichTextUtility.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#define kImagePathRegx      @"<\\s*img\\s+[^>]*?src\\s*=\\s*[\'\"](.*?)[\'\"]\\s*(alt=[\'\"](.*?)[\'\"])?[^>]*?\\/?\\s*>"
#define kImageNameRegx      @"[^/\\\\]+(\\.*?)$"

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
    NSArray *matchs = [RichTextUtility regexArrayWtithMatchString:aRichTextString
                                                      regexString:kImagePathRegx];
    [matchs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *matchResult = [[NSMutableArray alloc] initWithArray:obj];
        RichTextAttachment *imageAtt = [[RichTextAttachment alloc] init];

        for (int i = 0; i < [matchResult count]; i ++) {
            NSString *result = [matchResult objectAtIndex:i];
            if ([RichTextUtility isNullValue:result]) continue;
            
            switch (i) {
                case 0:
                    NSLog(@"case 0 = %@", result);
                    imageAtt.imageFullName = result;
                    break;
                case 1: {
                    NSLog(@"case 1 = %@", result);

                    imageAtt.imagePath = result;
                    NSString *imageName = [RichTextUtility regexStringWtithMatchString:imageAtt.imagePath
                                                                         regexString:kImageNameRegx];
                    NSLog(@"case 1:imageName = %@", imageName);
                    if (![RichTextUtility isNullValue:imageName]) {
                        imageAtt.imageName = imageName;
                    }
                }
                    break;
                default:
                    NSLog(@"Default Result = %@", result);
                    break;
            }
        };
        
        imageAtt.showImage = [UIImage imageNamed:imageAtt.imagePath];
        if (!imageAtt.image) {
            __weak typeof(self) weakSelf = self;
            [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
                __strong typeof(self) strongSelf = weakSelf;
                imageAtt.image = [UIImage imageNamed:@"empty"];
                
                NSMutableAttributedString *parseAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:strongSelf.attributedText];
                [parseAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
                strongSelf.attributedText = parseAttributedString;
            }];
        }
        
        [images addObject:imageAtt];
    }];
    
    return images;
}

#pragma mark - 把带有图片信息的NSAttributedString转换成String
- (NSString *)parseAttributedStringToString:(NSAttributedString *)attributedString
{
    NSMutableAttributedString *parseAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    
    [parseAttributedString enumerateAttribute:NSAttachmentAttributeName
                                      inRange:NSMakeRange(0, parseAttributedString.length)
                                      options:0
                                   usingBlock:^(id value, NSRange range, BOOL *stop) {
                                       if (value && [value isKindOfClass:[RichTextAttachment class]]) {
                                           RichTextAttachment *richTextAtt = (RichTextAttachment *)value;
                                           NSString *imageFullName = [NSString stringWithFormat:@"%@", richTextAtt.imageFullName];
                                           
                                           NSAttributedString *imageAttributedString = [self parseAttributedContentFromRichTextString:imageFullName];
                                           
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

#pragma mark - 把String转换成带有图片信息的NSAttributedString
- (NSAttributedString *)parseStringToAttributedString:(NSString *)aRichString
{
    NSString *richTextString = aRichString;
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    if (richTextString && [richTextString isKindOfClass:[NSString class]]) {
        //文本
        NSAttributedString *stringAtt = [self parseAttributedContentFromRichTextString:richTextString];
        [result appendAttributedString:stringAtt];
        
        NSArray *images = [NSArray arrayWithArray:[self parseImageRichString:richTextString]];
        
        //替换所有的图片
        for (RichTextAttachment *imageAtt in images) {
            NSAttributedString *imageAttributedString = [self parseImageDataFromRichTextImageInfo:imageAtt];
            NSRange imageRange = [result.string rangeOfString:imageAtt.imageFullName];
            
            [result replaceCharactersInRange:imageRange withAttributedString:imageAttributedString];
        }
    }
    
    return result;
}

#pragma mark - Attributes Getter And Setter

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
    return [self parseAttributedStringToString:self.attributedText];
}

#pragma mark - Setter attributesString
- (void)setAttributedString:(NSString *)attributedString
{
    self.attributedText = [self parseStringToAttributedString:attributedString];
}

#pragma mark -
#pragma mark - 插入图片
- (void)insertImageToSelected:(UIImage *)image
{
    RichTextAttachment *imageAtt = [[RichTextAttachment alloc] init];
    
    int nowTime = [[NSDate date] timeIntervalSince1970];
    int rand = ((arc4random() % 100) + 1);
    long randNum = (nowTime * 100)  + rand;
    
    imageAtt.imageName = [NSString stringWithFormat:@"%li", randNum];
    imageAtt.showImage = image;
    
    NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:imageAtt];
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [result insertAttributedString:imageAttributedString atIndex:self.selectedRange.location];
    
    self.attributedText = result;
}

@end
