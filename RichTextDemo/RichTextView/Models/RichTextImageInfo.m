//
//  RichTextImageInfo.m
//  RichTextDemo
//
//  Created by Benster on 15/9/16.
//  Copyright (c) 2015年 Benster. All rights reserved.
//

#import "RichTextImageInfo.h"

#define kImagePathRegx      @"<\\s*img\\s+[^>]*?src\\s*=\\s*[\'\"](.*?)[\'\"]\\s*(alt=[\'\"](.*?)[\'\"])?[^>]*?\\/?\\s*>"

@implementation RichTextImageInfo

- (instancetype)initWithImageId:(long long)aImageId
                      imageName:(NSString *)aImageName
                      imagePath:(NSString *)aImagePath
{
    if (self = [super init]) {
        _imageId = aImageId;
        _imageName = aImageName;
        _imagePath = aImagePath;
    }
    
    return self;
}

- (instancetype)initWithImgTagString:(NSString *)aImgTagString
{
    NSString *imgTagString = aImgTagString;
    
    if (imgTagString && [imgTagString isKindOfClass:[NSString class]]) {
        int nowTime = [[NSDate date] timeIntervalSince1970];
        int rand = ((arc4random() % 100) + 1);
        long randNum = (nowTime * 100)  + rand;

        long long imageId = randNum;
        NSString *imageName = imgTagString;
        
        //图片路径
        NSString *imagePath = [[NSString alloc] init];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kImagePathRegx
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSTextCheckingResult *result = [regex firstMatchInString:imgTagString
                                                      options:0
                                                        range:NSMakeRange(0, [imgTagString length])];
        if (result) {
            imagePath = [imgTagString substringWithRange:[result rangeAtIndex:1]];
        }
        
        NSLog(@"ImagePath = %@", imagePath);

        return [self initWithImageId:imageId
                           imageName:imageName
                           imagePath:imagePath];
    }
    
    return nil;
}

@end
