//
//  UploadImageModel.h
//  XiangJian
//
//  Created by Benster on 15/5/15.
//  Copyright (c) 2015年 31huiyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UploadType) {
    UploadTypeIcon,//个人头像
    UploadTypeIconBack//个人顶部背景
};

typedef void (^HttpModelCompletionBlock) (id responseObject);
typedef void (^HttpModelFailedBlock) (NSError *error);


@class DataResult;

@interface UploadImageModel : NSObject

@property (nonatomic, strong) DataResult *dataResult;

/**
 *  异步上传图片
 *
 *  @param aImage          <#aImage description#>
 *  @param completionBlock <#completionBlock description#>
 *  @param failedBlock     <#failedBlock description#>
 */
- (void)asyncUploadOriginalImage:(UIImage *)aImage
                 completionBlock:(HttpModelCompletionBlock)completionBlock
                     failedBlock:(HttpModelFailedBlock)failedBlock;

/**
 *  异步上传单个文件(压缩图 宽度为500 高度按比例缩放)
 *
 *  @param aImage          <#aImage description#>
 *  @param completionBlock <#completionBlock description#>
 *  @param failedBlock     <#failedBlock description#>
 */
- (void)asyncUploadImage:(UIImage *)aImage
              uploadType:(UploadType)aType
         completionBlock:(HttpModelCompletionBlock)completionBlock
             failedBlock:(HttpModelFailedBlock)failedBlock;

/**
 *  异步上传多个文件
 *
 *  @param aFiles          <#aFiles description#>
 *  @param completionBlock <#completionBlock description#>
 *  @param failedBlock     <#failedBlock description#>
 */
- (void)asyncUploadImageFiles:(NSArray *)aFiles
              completionBlock:(HttpModelCompletionBlock)completionBlock
                  failedBlock:(HttpModelFailedBlock)failedBlock;

@end
