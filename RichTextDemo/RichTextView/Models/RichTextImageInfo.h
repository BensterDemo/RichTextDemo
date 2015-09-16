//
//  RichTextImageInfo.h
//  RichTextDemo
//
//  Created by Benster on 15/9/16.
//  Copyright (c) 2015年 Benster. All rights reserved.
//

#import "RichTextBaseInfo.h"

@interface RichTextImageInfo : RichTextBaseInfo

@property (strong, nonatomic) NSString * name;

@property (nonatomic, assign) NSInteger position;

// 此坐标是 CoreText 的坐标系，而不是UIKit的坐标系
@property (nonatomic, assign) CGRect imagePosition;

@end
