//
//  ViewController.m
//  RichTextDemo
//
//  Created by Benster on 15/9/16.
//  Copyright (c) 2015年 Benster. All rights reserved.
//

#import "ViewController.h"
#import "RichTextParser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = [UIColor grayColor].CGColor;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"json"];
    NSString *string = [NSString stringWithContentsOfFile:path
                                                 encoding:NSUTF8StringEncoding
                                                    error:nil];
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    
    _textView.attributedText = [RichTextParser loadTemplateJson:string
                                                    imageArray:imageArray];
}

- (IBAction)pickImageButtonTap:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([info[UIImagePickerControllerMediaType] isEqual:@"public.image"]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        if (image) {
            [self insertImage:image];
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)insertImage:(UIImage *)aImage
{
    
}

@end
