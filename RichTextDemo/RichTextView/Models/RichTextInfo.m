//
//  RichTextInfo.m
//  RichTextDemo
//
//  Created by Benster on 15/9/16.
//  Copyright (c) 2015年 Benster. All rights reserved.
//

#import "RichTextInfo.h"

#define kColorWithHexStr(HexStr) [UIColor colorWithHexString:HexStr]

@implementation RichTextInfo

- (instancetype)initWithTextSize:(CGFloat)aSize
                       fontColor:(UIColor *)aColor
                            text:(NSString *)aText
{
    if (self = [super init]) {
        self.size = aSize;
        self.color = aColor;
        self.text = aText;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary
{
    if (aDictionary) {
        CGFloat fontSize = [[aDictionary objectForKey:@"size"] floatValue];
        UIColor *fontColor = [self colorWithHexString:[aDictionary objectForKey:@"color"]];
        NSString *context = [aDictionary objectForKey:@"content"];
        
        return [self initWithTextSize:fontSize
                            fontColor:fontColor
                                 text:context];
    }
    
    return nil;
}

#pragma mark - color Mehods
- (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [self colorWithRGBHex:hexNum];
}

- (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

@end
