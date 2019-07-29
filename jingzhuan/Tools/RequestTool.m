//
//  RequestTool.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/23.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "RequestTool.h"
#import "LoginViewController.h"
#import <AFNetworking.h>
#import "EncryptClass.h"

#define urlSheme @"http://115.159.42.248:8081/" //服务器
//#define urlSheme @"http://n2ubqp.natappfree.cc/"//本地

static AFHTTPSessionManager *manager = nil;
static RequestTool *requestTool = nil;
@implementation RequestTool

+ (RequestTool *)tool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        requestTool = [[self alloc] init];
        [requestTool checkInterNet];
    });
    return requestTool;
}

- (void)requsetWithController:(UIViewController *)vc
                           url:(NSString *)url
                          body:(NSDictionary *)body
                       Success:(void (^)(NSDictionary * result))success
                    andFailure:(void(^)(NSString *errorType))failure {
    
    NSDate * today = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:today];
    // 转换成当地时间
    NSDate *localeDate = [today dateByAddingTimeInterval:interval];
    // 时间转换成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:body];
    [parameters setValue:timeSp forKey:@"timestamp"];
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    
    if (url.length < 1) {
        url = @"pub/config/advert";
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",urlSheme,url];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"请稍后..."];
    [manager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSString *resultString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@--->%@",urlStr,resultString);
//        NSString *jsADS = @"W8XX9RmxnwSZ26C0zDp7DIgxySvpymdrlRUJ76Pcfgy5Gd/lt5gsJP39Lrpm MEEk";
//        NSDictionary *adsDict = [EncryptClass decryptWithString:jsADS];
//        NSLog(@"解密 %@",adsDict);
        NSString *code = dict[@"code"];
        if ([code isEqualToString:@"1111"]) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [vc presentViewController:loginVC animated:YES completion:nil];
        }else if ([code isEqualToString:@"0000"]){
            success(dict);
        }else {//if ([code isEqualToString:@"0001"])
            NSString *massage = dict[@"msg"];
            NSInteger time = 3;
            if (massage.length > 10) {
                time = 5;
            }
            [SVProgressHUD showErrorWithStatus:massage];
            [SVProgressHUD dismissWithDelay:time];
            failure(massage);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
        [SVProgressHUD dismissWithDelay:1.0];
        failure(@"网络错误");
    }];
}

- (void)checkInterNet {
    //网络状态
    AFNetworkReachabilityManager *networkReachbilityManager=[AFNetworkReachabilityManager sharedManager];
    [networkReachbilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"断网");
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showErrorWithStatus:@"网络出现问题"];
                [SVProgressHUD dismissWithDelay:2];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝数据");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi网络");
                break;
            default:
                break;
        }
    }];
    [networkReachbilityManager startMonitoring];
}


@end
