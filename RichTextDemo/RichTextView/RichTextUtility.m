//
//  RichTextUtility.m
//  RichTextDemo
//
//  Created by Benster on 15/11/4.
//  Copyright © 2015年 Benster. All rights reserved.
//

#import "RichTextUtility.h"

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

@end
