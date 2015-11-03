//
//  RichTextParser.h
//  RichTextDemo
//
//  Created by Benster on 15/9/16.
//  Copyright (c) 2015年 Benster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RichTextParser : NSObject

+ (NSAttributedString *)loadTemplateJson:(NSString *)aJsonString
                              imageArray:(NSMutableArray *)imageArray;

+ (NSString *)parseAttributedString:(NSAttributedString *)attributedString;

@end
