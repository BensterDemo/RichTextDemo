//
//  UITextView+RichTextView.m
//  RichTextDemo
//
//  Created by Benster on 15/11/4.
//  Copyright © 2015年 Benster. All rights reserved.
//

#import "UITextView+RichTextView.h"
#import <objc/runtime.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/SDImageCache.h>
#import "RichTextUtility.h"
#import "NSString+Trims.h"

#define kTextAttributes     @"textAttributes"

#define kImageMaxWidth      (CGRectGetWidth(self.frame) < ((CGRectGetWidth([UIScreen mainScreen].bounds)) - 10) ? CGRectGetWidth(self.frame) : (CGRectGetWidth([UIScreen mainScreen].bounds))) - (self.textContainerInset.left + self.textContainerInset.right) - 10

@implementation UITextView (RichTextView)

#pragma mark - Class Methods

#pragma mark - 转换 文本
- (NSAttributedString *)parseAttributedContentFromRichTextString:(NSString *)aRichTextString
{
    
    if ([RichTextUtility isNullValue:aRichTextString]) return nil;
    
    NSDictionary *textAttributes = self.textAttributes;
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
        
        imageAtt.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageAtt.imageName];
        if (!imageAtt.image) {
            imageAtt.image = [UIImage imageNamed:@"richTextView_empty"];
            [self downImageWithImageAtt:imageAtt];
        }
        
        [imageAtt sizeThatFits:kImageMaxWidth];
        [images addObject:imageAtt];
    }];
    
    return images;
}

#pragma mark - 下载图片
- (void)downImageWithImageAtt:(RichTextAttachment *)imageAtt
{
    NSString *imagePath = [imageAtt.imagePath trimmingWhitespaceAndNewlines];
    if ([RichTextUtility isNullValue:imagePath]) return;
    
    NSURL *imageURL = [[NSURL alloc] initWithString:imagePath];
    
    __weak typeof(self) weakSelf = self;
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    [downloader downloadImageWithURL:imageURL
                             options:0
                            progress:nil
                           completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                               __strong typeof(self) strongSelf = weakSelf;
                               if (image && finished) {
                                   [[SDImageCache sharedImageCache] storeImage:image forKey:imageAtt.imageName toDisk:YES];
                                   
                                   imageAtt.image = image;
                                   [imageAtt sizeThatFits:kImageMaxWidth];
                                   
                                   [strongSelf reFresh];
                               }
                           }];
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
                                           NSString *imageFullName = richTextAtt.imageFullName;
                                           if ([RichTextUtility isNullValue:imageFullName]) {
                                               imageFullName = [NSString stringWithFormat:@"<img src = \"%@\" />", richTextAtt.imageName];
                                           }
                                           
                                           NSAttributedString *imageAttributedString = [self parseAttributedContentFromRichTextString:imageFullName];
                                           
                                           [parseAttributedString replaceCharactersInRange:range
                                                                      withAttributedString:imageAttributedString];
                                       }
                                   }];
    // 使用0xFFFC作为空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString * replaceString = [NSString stringWithCharacters:&objectReplacementChar length:1];
    
    NSString *attString = [parseAttributedString.string stringByReplacingOccurrencesOfString:replaceString withString:@""];
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
- (NSDictionary *)textAttributes
{
    NSDictionary *textAttributes = objc_getAssociatedObject(self, kTextAttributes);
    
    return textAttributes;
}

#pragma mark - Setter textAttributes
- (void)setTextAttributes:(NSDictionary *)textAttributes
{
    objc_setAssociatedObject(self,
                             kTextAttributes,
                             textAttributes,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attributedString addAttributes:textAttributes range:NSMakeRange(0, attributedString.length)];
    self.attributedText = attributedString;
}


#pragma mark - UI

#pragma mark - Refresh TextView
- (void)reFresh
{
    __weak typeof(self) weakSelf = self;
    [[RACScheduler mainThreadScheduler] schedule:^{
        __strong typeof(self) strongSelf = weakSelf;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:strongSelf.attributedText];
        // 使用0xFFFC作为空白的占位符
        unichar objectReplacementChar = 0xFFFC;
        NSString * replaceString = [NSString stringWithCharacters:&objectReplacementChar length:1];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:replaceString]];
        strongSelf.attributedText = attributedString;
    }];
}

#pragma mark - 插入图片
- (void)insertImageToSelected:(UIImage *)image
{
    if (!image) return;
    
    RichTextAttachment *imageAtt = [[RichTextAttachment alloc] init];
    
    int nowTime = [[NSDate date] timeIntervalSince1970];
    int rand = ((arc4random() % 100) + 1);
    long randNum = (nowTime * 100)  + rand;
    
    imageAtt.imageName = [NSString stringWithFormat:@"%li", randNum];
    
    [[SDImageCache sharedImageCache] storeImage:image forKey:imageAtt.imageName toDisk:YES];
    imageAtt.image = image;
    [imageAtt sizeThatFits:kImageMaxWidth];
    
    NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:imageAtt];
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [result insertAttributedString:imageAttributedString atIndex:self.selectedRange.location];
    
    self.attributedText = result;
}

@end
