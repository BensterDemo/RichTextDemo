//
//  DataResult.h
//  XiangJian
//
//  Created by holyenzou on 15/4/21.
//  Copyright (c) 2015年 31huiyi. All rights reserved.
//

#import "BaseInfo.h"
#import "BoolInfo.h"
#import "StringInfo.h"

@interface DataResult : BaseInfo

@property (nonatomic, strong) BaseInfo     *dataInfo;

@property (nonatomic, strong) NSArray      *dataInfosArray;

@property (nonatomic, strong) NSDictionary *dataInfoDictionary;

@property (nonatomic, strong) BoolInfo     *boolInfo;

@property (nonatomic, strong) StringInfo   *stringInfo;


@property (nonatomic, assign) NSInteger code;

@property (nonatomic, strong) NSError   *error;

@property (nonatomic, strong) NSString  *message;

@end
