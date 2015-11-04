//
//  NSDictionary+BVJSONString.h
//  QianDao
//
//  Created by Jason Cui on 14-4-18.
//  Copyright (c) 2014年 31HuiYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (BVJSONString)
-(NSString*) JsonStringWithPrettyPrint:(BOOL) prettyPrint;
@end