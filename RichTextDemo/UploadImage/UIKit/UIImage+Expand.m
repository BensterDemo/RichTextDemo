//
//  UIImage+Expand.m
//  QianDao
//
//  Created by Benster on 15/3/9.
//  Copyright (c) 2015年 31HuiYi. All rights reserved.
//

#import "UIImage+Expand.h"

#define kColorWithRGB(Red, Green, Blue, Alpha) [UIColor colorWithRed:Red/255.0 green:Green/255.0 blue:Blue/255.0 alpha:Alpha]

@implementation UIImage (Expand)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return img;
}

+ (UIImage *)screenShot {
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            [[window layer] renderInContext:context];
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    //UIImage *image = [UIImage imageWithCGImage:quartzImage];
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationRight];
    CGImageRelease(quartzImage);
    
    return (image);
}

#pragma mark - 缩放图片
- (UIImage *)imagescaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *image  = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 顺时针旋转90°
- (UIImage *)rotateImage
{
    CGImageRef imgRef = self.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = self.imageOrientation;
    
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}


+ (UIImage *)imageFromText:(NSString *)text size:(CGSize)aSize font:(UIFont *)font needBack:(BOOL)aNeedBack
{
    UIImage *imageDefault = [UIImage imageNamed:@"aboutme_null_bg"];
    if (text.length <= 0) {
        return imageDefault;
    }
    UIFont *fontDe = font ? font : [UIFont systemFontOfSize:15];
//    if (fontDe.pointSize > aSize.width) {
//        fontDe = [UIFont systemFontOfSize:aSize.width*.5];
//    }
    float scale = 0.6;
    if (aSize.width < 50) {
        scale = 0.4;
    }else if (aSize.width < 70) {
        scale = 0.5;
    }
    fontDe = [UIFont systemFontOfSize:aSize.width*scale];
    
    CGRect frame = CGRectMake(0, 0, aSize.width, aSize.height);;

    NSString* initials = [text uppercaseString];

    UIGraphicsBeginImageContextWithOptions(frame.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame)-1, CGRectGetMinY(frame)-1, CGRectGetWidth(frame)+2, CGRectGetHeight(frame)+2)];
    [aNeedBack ? [UIColor whiteColor] : kColorWithRGB(0xf1, 0xf0, 0xf6, 1) setFill];
    [rectanglePath fill];
    
    if (imageDefault && aNeedBack) {
        [imageDefault drawInRect:CGRectMake(0, 0, aSize.width, aSize.height)];
    }
    
    CGRect initialsStringRect = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame));
    NSMutableParagraphStyle* initialsStringStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    initialsStringStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary* initialsStringFontAttributes = @{NSFontAttributeName: fontDe,
                                                   NSForegroundColorAttributeName: kColorWithRGB(0x99,0x99,0x99,1),
                                                   NSParagraphStyleAttributeName: initialsStringStyle};
    
    CGFloat initialsStringTextHeight = [initials boundingRectWithSize: CGSizeMake(initialsStringRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: initialsStringFontAttributes context: nil].size.height;
    CGContextSaveGState(context);
    CGContextClipToRect(context, initialsStringRect);
    [initials drawInRect: CGRectMake(CGRectGetMinX(initialsStringRect), CGRectGetMinY(initialsStringRect) + (CGRectGetHeight(initialsStringRect) - initialsStringTextHeight) / 2, CGRectGetWidth(initialsStringRect), initialsStringTextHeight) withAttributes: initialsStringFontAttributes];
    CGContextRestoreGState(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end

UIImage *ImageTextWidth(NSString* text ,CGFloat width,IconLevel level) {
    width = MAX(width, 10);

    UIFont *font = [UIFont systemFontOfSize:level == IconLevelHigh ? 82 : (level == IconLevelMiddle ? 48 : 24)];
    
    text = [[NSString stringWithFormat:@"%@",text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *string = text.length > 0 ? [text substringFromIndex:text.length-1] : @"";
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return [UIImage imageFromText:string size:CGSizeMake(width, width) font:font needBack:YES];
}

UIImage *ImageTextWidthBack(NSString* text ,CGFloat width,IconLevel level,BOOL aNeedBackImage) {
    width = MAX(width, 10);
    
    UIFont *font = [UIFont systemFontOfSize:level == IconLevelHigh ? 82 : (level == IconLevelMiddle ? 48 : 24)];
    NSString *string = text.length > 0 ? [text substringFromIndex:text.length-1] : @"";
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return [UIImage imageFromText:string size:CGSizeMake(width, width) font:font needBack:aNeedBackImage];
}
