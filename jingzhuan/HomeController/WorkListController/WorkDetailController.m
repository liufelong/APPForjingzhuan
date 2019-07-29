//
//  WorkDetailController.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/9.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "WorkDetailController.h"

#import "WorkStepView.h"

#include <objc/runtime.h>

@interface WorkDetailController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation WorkDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGB(0XFEA403);
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 1160);
    UIImageView *bgImag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1160)];
    bgImag.image = [UIImage imageNamed:@"work_detail_bg"];
    [self.scrollView addSubview:bgImag];
    
    WorkStepView *first = [WorkStepView viewForFirstView];
    first.frame = CGRectMake(0, 0, SCREEN_WIDTH, 330);
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 250, SCREEN_WIDTH, 330)];
    [firstView addSubview:first];
    first.buttonBlock = ^{
        [[UIPasteboard generalPasteboard] setString:@"今日头条"];
        NSString *str =@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/search";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
    };
    [self.scrollView addSubview:firstView];
    
    WorkStepView *second = [WorkStepView viewForSecondView];
    second.frame = CGRectMake(0, 0, SCREEN_WIDTH, 230);
    second.buttonBlock = ^{
        NSString *str =@"snssdk141://";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
            if (!success) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"您尚未按装今日头条请通过第一步下载安装" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    };
    UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 600, SCREEN_WIDTH, 230)];
    [secondView addSubview:second];
    [self.scrollView addSubview:secondView];
    
    WorkStepView *third = [WorkStepView viewForThirdView];
    third.frame = CGRectMake(0, 0, SCREEN_WIDTH, 270);
    third.buttonBlock = ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"领取成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    };
    UIView *thirdView = [[UIView alloc] initWithFrame:CGRectMake(0, 850, SCREEN_WIDTH, 270)];
    [thirdView addSubview:third];
    [self.scrollView addSubview:thirdView];
    
    [self getAllApp];
}

- (void)getAllApp {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
