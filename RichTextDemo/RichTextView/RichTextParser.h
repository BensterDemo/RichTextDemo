//
//  RichTextParser.h
//  RichTextDemo
//
//  Created by Benster on 15/9/16.
//  Copyright (c) 2015年 Benster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RichTextParser : NSObject

+ (NSAttributedString *)loadRichTextString:(NSString *)aRichTextString
                                imageArray:(NSMutableArray *)images;

+ (NSString *)parseAttributedString:(NSAttributedString *)attributedString
                         imageArray:(NSArray *)images;
@end
