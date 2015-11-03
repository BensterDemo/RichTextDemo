//
//  RichTextImageInfo.h
//  RichTextDemo
//
//  Created by Benster on 15/9/16.
//  Copyright (c) 2015年 Benster. All rights reserved.
//

#import "RichTextBaseInfo.h"

@interface RichTextImageInfo : RichTextBaseInfo

@property (nonatomic, assign) long long imageId;

@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, strong) NSString *imagePath;


#pragma mark - Methods
- (instancetype)initWithImgTagString:(NSString *)aImgTagString;

@end
