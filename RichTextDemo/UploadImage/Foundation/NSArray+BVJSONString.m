//
//  NSArray+BVJSONString.m
//  QianDao
//
//  Created by Jason Cui on 14-4-18.
//  Copyright (c) 2014年 31HuiYi. All rights reserved.
//

#import "NSArray+BVJSONString.h"

@implementation NSArray (BVJSONString)
-(NSString*) JsonStringWithPrettyPrint:(BOOL) prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions) (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"[]";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
@end