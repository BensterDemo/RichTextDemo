//
//  NSURL+Additions.h
//  QianDao
//
//  Created by Benster on 15/3/23.
//  Copyright (c) 2015年 31HuiYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Additions)

+ (NSDictionary *)parseURLQueryString:(NSString *)queryString;

+ (NSURL *)smartURLForString:(NSString *)str;

@end
