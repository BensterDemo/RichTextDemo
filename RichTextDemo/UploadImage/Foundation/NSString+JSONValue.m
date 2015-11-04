//
//  NSString+JSONValue.m
//  QianDao
//
//  Created by Jason Cui on 14-4-18.
//  Copyright (c) 2014年 31HuiYi. All rights reserved.
//

#import "NSString+JSONValue.h"

@implementation NSString (BVJSONString)
- (id)JSONValue{
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
}
@end
