//
//  UploadImageModel.m
//  XiangJian
//
//  Created by Benster on 15/5/15.
//  Copyright (c) 2015年 31huiyi. All rights reserved.
//

#import "UploadImageModel.h"

#import "NSString+UrlEncode.h"
#import "NSData+GZIP.h"
#import "NSURL+Additions.h"
#import "UIImage+Expand.h"
#import "NSDictionary+BVJSONString.h"
#import "NSString+JSONValue.h"
#import "NSArray+BVJSONString.h"

#import "RichTextUtility.h"
#import "DataResult.h"

#import "UploadImageInfo.h"

#define ESWeak(var, weakVar) __weak __typeof(&*var) weakVar = var
#define ESStrong_DoNotCheckNil(weakVar, _var) __typeof(&*weakVar) _var = weakVar
#define ESStrong(weakVar, _var) ESStrong_DoNotCheckNil(weakVar, _var); if (!_var) return;

#define ESWeak_(var) ESWeak(var, weak_##var);
#define ESStrong_(var) ESStrong(weak_##var, _##var);

/** defines a weak `self` named `__weakSelf` */
#define ESWeakSelf      ESWeak(self, __weakSelf);

/** defines a strong `self` named `_self` from `__weakSelf` */
#define ESStrongSelf    ESStrong(__weakSelf, _self);


#define API_UPLOADHEADIMAGE                @"http://newapi.31huiyi.com/common/FileUploadHandler.ashx"

@implementation UploadImageModel

- (DataResult *)dataResult
{
    if (!_dataResult) {
        _dataResult = [[DataResult alloc] init];
    }
    
    return _dataResult;
}

- (NSMutableURLRequest *)requestPostWithImages:(NSArray *)aImages
                                           url:(NSString *)aUrl
                                   queryString:(NSString *)aQueryString
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL smartURLForString:aUrl]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:20.0f];
    
    //generate boundary string
    CFUUIDRef       uuid;
    CFStringRef     uuidStr;
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    NSString *boundary = [NSString stringWithFormat:@"Boundary-%@", uuidStr];
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    NSData *boundaryBytes = [[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *bodyData = [NSMutableData data];
    NSString *formDataTemplate = @"\r\n--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@";
    
    NSDictionary *listParams = [NSURL parseURLQueryString:aQueryString];
    for (NSString *key in listParams) {
        
        NSString *value = [listParams valueForKey:key];
        NSString *formItem = [NSString stringWithFormat:formDataTemplate, boundary, key, value];
        [bodyData appendData:[formItem dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [bodyData appendData:boundaryBytes];
    
    NSString *headerTemplate = @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: \"application/octet-stream\"\r\n\r\n";
    for (int i = 0; i < [aImages count]; i ++) {
        NSDictionary *imageData = [aImages objectAtIndex:i];
        NSString *imageName = [imageData objectForKey:@"name"];
        NSData *fileData = UIImageJPEGRepresentation([imageData objectForKey:@"image"], 1);
        NSString *header = [NSString stringWithFormat:headerTemplate,
                            [NSString stringWithFormat:@"%@", imageName],
                            [NSString stringWithFormat:@"%@.png", imageName]];
        
        [bodyData appendData:[header dataUsingEncoding:NSUTF8StringEncoding]];
        [bodyData appendData:fileData];
        [bodyData appendData:boundaryBytes];
    }
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[bodyData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:bodyData];
    
    return request;
}

#pragma mark - 同步上传多个文件
- (void)syncUploadImageFiles:(NSArray *)aFiles
{
    NSMutableURLRequest *request = [self requestPostWithImages:aFiles
                                                           url:API_UPLOADHEADIMAGE
                                                   queryString:@""];
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *retString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    [self parseUploadImagesResultByJsonData:retString];
}

#pragma mark - 异步上传多个文件
- (void)asyncUploadImageFiles:(NSArray *)aFiles
              completionBlock:(HttpModelCompletionBlock)completionBlock
                  failedBlock:(HttpModelFailedBlock)failedBlock
{
    NSMutableURLRequest *request = [self requestPostWithImages:aFiles
                                                           url:API_UPLOADHEADIMAGE
                                                   queryString:@""];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if ([data length] > 0 && connectionError == nil) {
                                   NSString *resultStr = [[NSString alloc] initWithData:data
                                                                               encoding:NSUTF8StringEncoding];
                                   NSLog(@"Upload Image Result = %@", resultStr);
                                   self.dataResult = [self parseUploadImagesResultByJsonData:resultStr];
                                   completionBlock(self.dataResult);
                               } else if (connectionError) {
                                   NSLog(@"error = %@", connectionError);
                                   failedBlock(nil);
                               }
                           }];
}

- (id)parseUploadImagesResultByJsonData:(NSString *)aResultStr
{
    NSArray *dataArray = [NSArray arrayWithArray:[[aResultStr JSONValue] objectForKey:@"data"]];
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dict in dataArray) {
        UploadImageInfo *uploadImageInfo = [[UploadImageInfo alloc] initWithDictionary:dict];
        
        [array addObject:uploadImageInfo];
    }
    
    self.dataResult.dataInfosArray = array;
    
    return self.dataResult;
}

#pragma mark - 同步上传单个文件
- (void)syncUploadImageFile:(UIImage *)aImage
{
    NSMutableURLRequest *request = [self requestPostWithImages:@[aImage]
                                                           url:API_UPLOADHEADIMAGE
                                                   queryString:@""];
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *retString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];

    [self parseUploadImageResultByJsonData:retString];
}

#pragma mark - 异步上传单个文件(压缩图 宽度为500 高度按比例缩放)
- (void)asyncUploadOriginalImage:(UIImage *)aImage
                 completionBlock:(HttpModelCompletionBlock)completionBlock
                     failedBlock:(HttpModelFailedBlock)failedBlock
{
    NSMutableURLRequest *request = [self requestPostWithImages:@[aImage]
                                                           url:API_UPLOADHEADIMAGE
                                                   queryString:@""];
    
    ESWeakSelf;
    __block HttpModelCompletionBlock weakCompletionBlock = completionBlock;
    __block HttpModelFailedBlock weakFailedBlock = failedBlock;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if ([data length] > 0 && connectionError == nil) {
                                   NSString *resultStr = [[NSString alloc] initWithData:data
                                                                               encoding:NSUTF8StringEncoding];
                                   NSLog(@"Upload Image Result = %@", resultStr);
                                   __weakSelf.dataResult = [self parseUploadImageResultByJsonData:resultStr];
                                   weakCompletionBlock(__weakSelf.dataResult);
                               } else if (connectionError) {
                                   NSLog(@"error = %@", connectionError);
                                   weakFailedBlock(nil);
                               }
                           }];
}

#pragma mark - 异步上传单个文件(压缩图 宽度为500比例缩小)
- (void)asyncUploadImage:(UIImage *)aImage
              uploadType:(UploadType)aType
         completionBlock:(HttpModelCompletionBlock)completionBlock
             failedBlock:(HttpModelFailedBlock)failedBlock
{
    UIImage *compress1Image = [aImage imagescaledToSize:CGSizeMake(500, 500*aImage.size.height/aImage.size.width)];
    UIImage *compressImage = [UIImage imageWithData:UIImageJPEGRepresentation(compress1Image, 0.5)];
    
    
    NSMutableURLRequest *request = [self requestPostWithImages:@[compressImage ? compressImage :aImage]
                                                           url:API_UPLOADHEADIMAGE
                                                   queryString:@""];
    ESWeakSelf;
    __block HttpModelCompletionBlock weakCompletionBlock = completionBlock;
    __block HttpModelFailedBlock weakFailedBlock = failedBlock;
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if ([data length] > 0 && connectionError == nil) {
                                   NSString *resultStr = [[NSString alloc] initWithData:data
                                                                               encoding:NSUTF8StringEncoding];
                                   NSLog(@"Upload Image Result = %@", resultStr);
                                   __weakSelf.dataResult = [__weakSelf parseUploadImageResultByJsonData:resultStr];
                                   weakCompletionBlock(__weakSelf.dataResult);
                                   
                               } else if (connectionError) {
                                   NSLog(@"error = %@", connectionError);
                                   weakFailedBlock(nil);
                               }
                           }];
}

- (id)parseUploadImageResultByJsonData:(NSString *)aResultStr
{
    NSArray *dataArray = [NSArray arrayWithArray:[[aResultStr JSONValue] objectForKey:@"data"]];
    NSDictionary *dataDict = [dataArray objectAtIndex:0];
    if (!dataDict) {
        return nil;
    }
    
    UploadImageInfo *uploadImageInfo = [[UploadImageInfo alloc] initWithDictionary:dataDict];
    
    self.dataResult.dataInfo = uploadImageInfo;
    
    return self.dataResult;
}

- (id)parseXiangJianNoByJsonData:(NSDictionary *)aJsonData
{
    NSDictionary *dict  = aJsonData[@"Data"];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        BaseInfo *info = self.dataResult.dataInfo;
        self.dataResult.code = [dict[@"Code"] integerValue];
        self.dataResult.boolInfo = [BoolInfo new];
        self.dataResult.boolInfo.resultBool = ([dict[@"Code"] integerValue] == 200);
        if ([info isKindOfClass:[UploadImageInfo class]]) {
            NSString *urlData = dict[@"Data"];
            ((UploadImageInfo *)info).Path = urlData;
        }
    }
    return self.dataResult;
}

@end
