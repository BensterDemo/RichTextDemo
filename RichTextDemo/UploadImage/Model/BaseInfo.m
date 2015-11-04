//
//  BaseInfo.m
//  XiangJian
//
//  Created by holyenzou on 15/4/13.
//  Copyright (c) 2015年 31huiyi. All rights reserved.
//

#import "BaseInfo.h"
#import <objc/runtime.h>


@implementation BaseInfo

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary
{
    if (self = [super init]) {
        
    }
    return self;
}

- (NSString *)description
{
    NSDictionary *dic = [self getAllPropertiesAndVaules];
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    return [NSString stringWithFormat:@"**************%@**************\n%@", className, dic];
}

- (NSDictionary *)getAllPropertiesAndVaules
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties =class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

- (NSDictionary*)dictionaryValue
{
    return [self dictionaryWithValuesForKeys:[self allPropertyKeys]];
}

- (NSArray*)allPropertyKeys
{
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([self class], &propertyCount);
    NSMutableArray * propertyNames = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    return propertyNames;
}

@end

