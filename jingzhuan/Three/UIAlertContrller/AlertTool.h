//
//  AlertTool.h
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/26.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BlankBlock)(void);

@interface AlertTool : NSObject
+ (AlertTool *)tool;
//提示相关
- (void)alertWithTitle:(NSString *)title;
- (void)alertWithTitle:(NSString *)title message:(NSString *)message;
- (void)alertWithTitle:(NSString *)title message:(NSString *)message confirmBlock:(BlankBlock)confirmBlock;
- (void)alertWithTitle:(NSString *)title message:(NSString *)message actionTitle1:(NSString *)actionTitle1 actionTitle2:(NSString *)actionTitle2 cancelBlock:(BlankBlock)cancelBlock confirmBlock:(BlankBlock)confirmBlock;

@end

NS_ASSUME_NONNULL_END
