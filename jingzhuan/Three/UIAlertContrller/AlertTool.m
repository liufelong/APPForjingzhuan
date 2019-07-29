//
//  AlertTool.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/26.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "AlertTool.h"
#import "ALertController.h"

@interface AlertTool ()

@end

static AlertTool *tool = nil;

@implementation AlertTool

+ (AlertTool *)tool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[AlertTool alloc] init];
    });
    return tool;
}

- (void)alertWithTitle:(NSString *)title {
    BlankBlock block;
    [self alertWithTitle:title message:@"" actionTitle1:@"确定" actionTitle2:@"" cancelBlock:block confirmBlock:block];
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    BlankBlock block;
    [self alertWithTitle:title message:message actionTitle1:@"确定" actionTitle2:@"" cancelBlock:block confirmBlock:block];
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message sureBlock:(BlankBlock)sureBlock {
    BlankBlock block;
    [self alertWithTitle:title message:message actionTitle1:@"" actionTitle2:@"确定" cancelBlock:block confirmBlock:sureBlock];
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message confirmBlock:( BlankBlock)confirmBlock {
    BlankBlock block;
    [self alertWithTitle:title message:message actionTitle1:@"取消" actionTitle2:@"确定" cancelBlock:block confirmBlock:confirmBlock];
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message actionTitle1:(NSString *)actionTitle1 actionTitle2:(NSString *)actionTitle2 cancelBlock:(BlankBlock)cancelBlock confirmBlock:(BlankBlock)confirmBlock {
    ALertController *alertController = [ALertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (actionTitle1.length > 0) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:actionTitle1 style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
            if (cancelBlock) {
                cancelBlock();
            }
        }];
        [alertController addAction:cancelAction];
    }
    if (actionTitle2.length > 0) {
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:actionTitle2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (confirmBlock) {
                confirmBlock();
            }
        }];
        [alertController addAction:confirmAction];
    }
    
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    
}

@end
