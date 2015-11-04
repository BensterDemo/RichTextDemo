//
//  NSObject+Property.m
//  IOS-Categories
//
//  Created by Jakey on 14/12/20.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "NSObject+Property.h"
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@implementation NSObject (Property)

+ (Class)classByProperty:(objc_property_t)property
{
    Class propertyClass = nil;
    char *typeEncoding = property_copyAttributeValue(property, "T");
    switch (typeEncoding[0])
    {
        case '@':
        {
            if (strlen(typeEncoding) >= 3)
            {
                char *className = strndup(typeEncoding + 2, strlen(typeEncoding) - 3);
                __autoreleasing NSString *name = @(className);
                NSRange range = [name rangeOfString:@"<"];
                if (range.location != NSNotFound)
                {
                    name = [name substringToIndex:range.location];
                }
                propertyClass = NSClassFromString(name) ?: [NSObject class];
                free(className);
            }
            break;
        }
        case 'c':
        case 'i':
        case 's':
        case 'l':
        case 'q':
        case 'C':
        case 'I':
        case 'S':
        case 'L':
        case 'Q':
        case 'f':
        case 'd':
        case 'B':
        {
            propertyClass = [NSNumber class];
            break;
        }
        case '{':
        {
            propertyClass = [NSValue class];
            break;
        }
    }
    free(typeEncoding);
    return propertyClass;
}

- (NSDictionary *)propertyDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned int outCount;
    objc_property_t *props = class_copyPropertyList([self class], &outCount);
    for(int i=0;i<outCount;i++){
        objc_property_t prop = props[i];
        NSString *propName = [[NSString alloc]initWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
        id propValue = [self valueForKey:propName];
        if(propValue){
            [dict setObject:propValue forKey:propName];
        } else {
            [dict setObject:[[[NSObject classByProperty:prop] alloc] init] forKey:propName];
        }
    }
    
    free(props);
    return dict;
}


#pragma mark - 把Dictionary和array转化为Data
- (NSDictionary *)sqlPropertyDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned int outCount;
    objc_property_t *props = class_copyPropertyList([self class], &outCount);
    for(int i=0;i<outCount;i++){
        objc_property_t prop = props[i];
        NSString *propName = [[NSString alloc]initWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
        id propValue = [self valueForKey:propName];
        Class propClass = [NSObject classByProperty:prop];
        
        if (![propClass isSubclassOfClass:[NSNumber class]] &&
            ![propClass isSubclassOfClass:[NSString class]] &&
            ![propClass isSubclassOfClass:[NSDate class]])
        {
            if(propValue){
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:propValue];
                [dict setObject:data forKey:propName];
            } else {
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[[propClass alloc] init]];
                [dict setObject:data forKey:propName];
            }
        } else {
            if(propValue){
                [dict setObject:propValue forKey:propName];
            } else {
                [dict setObject:[[propClass alloc] init] forKey:propName];
            }
        }
    }
    
    free(props);
    return dict;
}

+ (NSArray *)classPropertyList
{
    NSMutableArray *allProperties = [[NSMutableArray alloc] init];
    
    unsigned int outCount;
    objc_property_t *props = class_copyPropertyList(self, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t prop = props[i];
        
        NSString *propName = [[NSString alloc]initWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];

        if (propName) {
            [allProperties addObject:propName];
        }
    }
    free(props);
    return [NSArray arrayWithArray:allProperties];
}

@end
