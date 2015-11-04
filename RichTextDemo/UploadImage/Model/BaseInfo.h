//
//  BaseInfo.h
//  XiangJian
//
//  Created by holyenzou on 15/4/13.
//  Copyright (c) 2015年 31huiyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+SafeAccess.h"
#import "NSArray+SafeAccess.h"
#import "NSObject+Property.h"

@interface BaseInfo : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary;

- (NSDictionary*)dictionaryValue;

@end
