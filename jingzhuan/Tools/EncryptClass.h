//
//  EncryptClass.h
//  ZhangZhongBao
//
//  Created by liu on 16/4/1.
//  Copyright © 2016年 Mr Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptClass : NSObject

//激活卡密码加密
+ (NSString *)encrypWithPassWord:(NSString *)passWord;

//加密方法
+ (NSString *)encryptWithDictionary:(NSDictionary *)dic;

+ (NSDictionary *)decryptWithString:(NSString *)string;

@end
