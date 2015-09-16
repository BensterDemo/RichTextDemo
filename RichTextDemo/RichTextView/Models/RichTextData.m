//
//  RichTextData.m
//  RichTextDemo
//
//  Created by Benster on 15/9/16.
//  Copyright (c) 2015年 Benster. All rights reserved.
//

#import "RichTextData.h"
#import "RichTextParser.h"

@implementation RichTextData

- (instancetype)init
{
    if (self = [super init]) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)setJsonContent:(NSString *)jsonContent
{
    _jsonContent = jsonContent;
    
    _attributString = [RichTextParser loadTemplateJson:_jsonContent imageArray:_imageArray];
}

@end