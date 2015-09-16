//
//  RichTextLinkInfo.h
//  RichTextDemo
//
//  Created by Benster on 15/9/16.
//  Copyright (c) 2015年 Benster. All rights reserved.
//

#import "RichTextBaseInfo.h"

@interface RichTextLinkInfo : RichTextBaseInfo

@property (strong, nonatomic) NSString * title;

@property (strong, nonatomic) NSString * url;

@property (assign, nonatomic) NSRange range;

@end
