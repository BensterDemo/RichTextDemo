//
//  RichTextBaseInfo.m
//  RichTextDemo
//
//  Created by Benster on 15/9/16.
//  Copyright (c) 2015年 Benster. All rights reserved.
//

#import "RichTextBaseInfo.h"

@implementation RichTextBaseInfo

- (instancetype)initWithRichTextType:(RichTextType)aRichTextType
{
    if (self = [super init]) {
        self.richTextType = aRichTextType;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary
{
    if (aDictionary && [aDictionary isKindOfClass:[NSDictionary class]]) {
        NSString *type = [aDictionary objectForKey:@"type"];
        
        RichTextType richtextType = RichTextTextType;
        
        if ([@"txt" isEqualToString:type]) {
            richtextType = RichTextTextType;
        } else if ([@"link" isEqualToString:type]) {
            richtextType = RichTextLinkTextType;
        } else if ([@"img" isEqualToString:type]) {
            richtextType = RichTextImageType;
        }
        
        return [self initWithRichTextType:richtextType];
    }
    
    return nil;
}

@end
