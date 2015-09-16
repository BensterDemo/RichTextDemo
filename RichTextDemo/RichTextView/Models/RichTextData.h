//
//  RichTextData.h
//  RichTextDemo
//
//  Created by Benster on 15/9/16.
//  Copyright (c) 2015年 Benster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "RichTextImageInfo.h"

@interface RichTextData : NSObject

@property (nonatomic, assign) CTFrameRef ctFrame;

@property (nonatomic, strong) NSString *jsonContent;

@property (nonatomic, strong) NSString *contentString;

@property (nonatomic, strong) NSMutableArray *contentArray;

@property (nonatomic, strong) NSAttributedString *attributString;

@property (nonatomic, strong) NSMutableArray *imageArray;

@end
