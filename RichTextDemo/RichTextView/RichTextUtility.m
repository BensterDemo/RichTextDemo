//
//  RichTextUtility.m
//  RichTextDemo
//
//  Created by Benster on 15/11/4.
//  Copyright © 2015年 Benster. All rights reserved.
//

#import "RichTextUtility.h"
#import "NSString+Trims.h"

@implementation RichTextUtility

+ (BOOL)isNullValue:(NSString *)value
{
    if ([value isKindOfClass:[NSNumber class]]) {
        if ([value integerValue] > 0) {
            return NO;
        } else {
            return YES;
        }
    }
    
    if (value == nil ||
        [value isKindOfClass:[NSNull class]] ||
        [value isEqualToString:@""])
    {
        return YES;
    }
    
    return NO;
}

#pragma mark - 正则出所有结果
+ (NSArray *)regexArrayWtithMatchString:(NSString *)matchString
                            regexString:(NSString *)regexString
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSArray *results = [regex matchesInString:matchString
                                      options:0
                                        range:NSMakeRange(0, [matchString length])];
    
    NSMutableArray *matchs = [[NSMutableArray alloc] init];
    
    //遍历出匹配结果
    for (NSTextCheckingResult *result in results) {
        NSMutableArray *matchResult = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < result.numberOfRanges; i ++) {
            NSRange matchRange = [result rangeAtIndex:i];
            if (matchRange.location == NSNotFound) continue;    //是否越界
            
            NSString *match = [[matchString substringWithRange:matchRange] trimmingWhitespaceAndNewlines];
            if ([RichTextUtility isNullValue:match]) continue;  //是否为空
            
            [matchResult addObject:match];
        }
        
        [matchs addObject:matchResult];
    }
    
    return matchs;
}

#pragma mark - 正则出单个结果
+ (NSString *)regexStringWtithMatchString:(NSString *)matchString
                              regexString:(NSString *)regexString
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSTextCheckingResult *result = [regex firstMatchInString:matchString
                                                     options:0
                                                       range:NSMakeRange(0, [matchString length])];
    
    if (result) {
        NSString *match = [[matchString substringWithRange:[result range]] trimmingWhitespaceAndNewlines];
        return match;
    }
    
    return nil;
}


@end
