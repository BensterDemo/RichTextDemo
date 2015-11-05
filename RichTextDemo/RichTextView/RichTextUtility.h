//
//  RichTextUtility.h
//  RichTextDemo
//
//  Created by Benster on 15/11/4.
//  Copyright © 2015年 Benster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RichTextUtility : NSObject

/**
 *  判断String是否为空
 *
 *  @param value <#value description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)isNullValue:(NSString *)value;

/**
 *  正则出所有结果
 *
 *  @param matchString <#matchString description#>
 *  @param regexString <#regexString description#>
 *
 *  @return <#return value description#>
 */
+ (NSArray *)regexArrayWtithMatchString:(NSString *)matchString
                            regexString:(NSString *)regexString;

/**
 *  正则出单个结果
 *
 *  @param matchString 正则String
 *  @param regexString 要匹配的String
 *
 *  @return <#return value description#>
 */
+ (NSString *)regexStringWtithMatchString:(NSString *)matchString
                              regexString:(NSString *)regexString;

@end
