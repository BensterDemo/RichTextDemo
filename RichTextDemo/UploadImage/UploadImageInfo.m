//
//  UploadImageInfo.m
//  XiangJian
//
//  Created by Benster on 15/5/17.
//  Copyright (c) 2015年 31huiyi. All rights reserved.
//

#import "UploadImageInfo.h"

@implementation UploadImageInfo

- (instancetype)initWithImageName:(NSString *)aName
                          Path:(NSString *)aPath
{
    if (self = [super init]) {
        self.Name = aName;
        self.Path = aPath;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary
{
    if (aDictionary) {
        NSString *Name = [aDictionary objectForKey:@"Name"];
        NSString *Path = [aDictionary objectForKey:@"Path"];
        
        return [self initWithImageName:Name
                                  Path:Path];
    } else {
        return nil;
    }
}

@end
