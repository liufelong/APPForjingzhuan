//
//  EncryptClass.m
//  ZhangZhongBao
//
//  Created by liu on 16/4/1.
//  Copyright © 2016年 Mr Du. All rights reserved.
//

#import "EncryptClass.h"
#import "GTMBase64.h"
#include <CommonCrypto/CommonCryptor.h>

static Byte iv[] = {'p','i','c','c'};//,0,0,0,0
@implementation EncryptClass

+ (NSString *)encrypWithPassWord:(NSString *)passWord{
    
    return [EncryptClass encryptUseDES:passWord];
}
+ (NSString *) encryptUseDES:(NSString *)plainText {
    NSString *ciphertext = nil;
    const char *textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          iv, kCCKeySizeDES,
                                          NULL,
                                          textBytes, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext =[EncryptClass parseByte2HexString:(Byte*)[data bytes] StringLength:[data length]];
    }
    return ciphertext;
    
}

+ (NSString *) parseByte2HexString:(Byte *) bytes StringLength:(unsigned long)alength {
    
    NSString *hexStr=@"";
    for(int i=0;i<alength;i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    //NSLog(@"bytes 的16进制数为:%@",hexStr);
    return hexStr;
}



+ (NSString *)des:(NSString *)str key:(NSString *)key{
    NSString *ciphertext = nil;
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    
    
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        NSLog(@"data = %@",data);
       NSString * ci= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"ciphertext = %@",ci);
        return ci;
    }
    return ciphertext;
}

+ (NSString *)encryptWithDictionary:(NSDictionary *)dic{
    
    NSString *key1 = @"1qaz@WSX3edc$RFV5tgb^YHN7ujm*IK<";
    NSString *key2 = @"mko0NJI(bhu8VGY&cft6XDR%zse4AW#@";
    
    NSString *dicStr = [EncryptClass dictionaryToJsonwithnotenrty:dic];
    NSString *str1 = [EncryptClass encryptUseDES:dicStr key:key1];
    NSString *str2 = [EncryptClass encryptUseDES:str1 key:key2];
    
    return str2;
    
}


+ (NSDictionary *)decryptWithString:(NSString *)string{
    NSString *key1 = @"1qaz@WSX3edc$RFV5tgb^YHN7ujm*IK<";
//    NSString *key2 = @"mko0NJI(bhu8VGY&cft6XDR%zse4AW#@";
    
//    NSString *string2 = [EncryptClass decryptUseDES:string key:key2];
    NSString *string1 = [EncryptClass decryptUseDES:string key:key1];
    NSDictionary *dic = [EncryptClass parseJSONStringToNSDictionary:string1];
    return dic;
}

+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

+ (NSString *)dictionaryToJsonwithnotenrty:(NSDictionary *)dic{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSMutableString * str1 = [[NSMutableString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString* headerData=str1;
    headerData = [headerData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    headerData = [headerData stringByReplacingOccurrencesOfString:@" " withString:@""];
    return headerData ;
}

+ (NSString*) decryptUseDES:(NSString*)cipherText key:(NSString*)key {
    // 利用 GTMBase64 解碼 Base64 字串
    NSData* cipherData = [GTMBase64 decodeString:cipherText];
    unsigned char buffer[5120];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    
    // IV 偏移量不需使用
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding| kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          nil,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          5120,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return plainText;
}
+ (NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key
{
    NSData *data = [clearText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    unsigned char buffer[5120];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding| kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          nil,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          5120,
                                          &numBytesEncrypted);
    
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData *dataTemp = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        plainText = [GTMBase64 stringByEncodingData:dataTemp];
    }else{
        NSLog(@"DES加密失败");
    }
    return plainText;
}

@end
