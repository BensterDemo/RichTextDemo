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

@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = [UIColor grayColor].CGColor;
    
    NSString *string = @"<img src = \"coretext-image-1\">\n美国导弹防御局网站公布，美国东部时间10月31日晚11时03分(北京时间11月1日中午11时03分)，美国海军在威克岛附近海域进行了一次反导试验，试验中验证了“宙斯盾”系统和THAAD系统互相配合，<img src = \"coretext-image-2\">同时进行防空反导作战的能力。美《大众机械师》网站报道，网络照片显示，北京时间11月1日早晨7时前后，中国新疆库尔勒附近出现“异常天象”，据推断一次反导试验，测试的可能是红旗-19系统。中美这两次反导试验的时间相差仅4小时，这或许是一次巧合。而2013年1月27日，中美也在同日进行了中段反导试验。\n 新疆库尔勒地区附近目击的异常天象\n";
    
    _images = [[NSMutableArray alloc] init];
    

    
    _textView.attributedText = [RichTextParser loadRichTextString:string
                                                       imageArray:_images];
}

#pragma mark - 保存
- (IBAction)richTextSave:(UIButton *)sender
{
    NSString *richTextString = [RichTextParser parseAttributedString:_textView.attributedText imageArray:_images];
    NSLog(@"richTextString  = %@", richTextString);
}

#pragma mark - 选择图片
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
