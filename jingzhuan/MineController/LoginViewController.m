//
//  LoginViewController.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/14.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "LoginViewController.h"
#import <TCWebCodesSDK/TCWebCodesBridge.h>

//获取IDFA
#import <AdSupport/AdSupport.h>

//获取IP
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topY;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *capthaTextField;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(0,0);
    self.bgView.layer.shadowRadius = 3;
    self.bgView.layer.shadowOpacity = 0.5;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 5;
    self.bgView.clipsToBounds = NO;
    
    self.topY.constant = -STATUS_HEIGHT;
    self.phoneTextField.text = @"13800138000";
}

//获取验证码
- (IBAction)getCodeAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [[TCWebCodesBridge sharedBridge] loadTencentCaptcha:self.view appid:@"2026296478" callback:^(NSDictionary *resultJSON) {
        NSLog(@"%@",resultJSON);
        NSString *ticket = resultJSON[@"ticket"];
        if (ticket.length > 0) {
            NSDictionary *body = @{@"phone":self.phoneTextField.text,
                                   @"ticket":ticket,
                                   @"randstr":resultJSON[@"randstr"],
                                   @"userIp":[self getIPAddress:YES],
                                   @"type":@"1"};
            [[RequestTool tool] requsetWithController:self url:@"pub/user/smsCaptcha" body:body Success:^(id  _Nonnull result) {
                [self timeDown];
                NSString *msg = result[@"msg"];
                [SVProgressHUD showSuccessWithStatus:msg];
                [SVProgressHUD dismissWithDelay:5];
            } andFailure:^(NSString * _Nonnull errorType) {
                
            }];
        }
    }];
}


- (IBAction)loginAction:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString *idfa = [UserDefaults valueForKey:@"IDFA"];
    if (idfa.length < 1) {
        idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        [UserDefaults setValue:idfa forKey:@"IDFA"];
    }
    NSString *uuid =  [[UIDevice currentDevice] identifierForVendor].UUIDString;
    NSLog(@"%@",uuid);
    if (self.phoneTextField.text.length < 1) {
        [self alertViewWithTitle:@"请输入手机号" andMessage:@""];
        return;
    }
    if (self.capthaTextField.text.length < 1) {
        [self alertViewWithTitle:@"请输入验证码" andMessage:@""];
        return;
    }
    NSDictionary *body = @{@"phone":self.phoneTextField.text,
                           @"captcha":self.capthaTextField.text,
                           @"udid":uuid,
                           @"idfa":idfa,
                           @"pushId":@"abcd1234"};//预留字段
    [[RequestTool tool] requsetWithController:self url:@"pub/user/login" body:body Success:^(id  _Nonnull result) {
        [UserDefaults setValue:result[@"userId"] forKey:@"userId"];
        [UserDefaults setValue:result[@"token"] forKey:@"token"];
        if (self.loginSuccess) {
            self.loginSuccess();
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } andFailure:^(NSString * _Nonnull errorType) {
        [SVProgressHUD showErrorWithStatus:errorType];
        [SVProgressHUD dismissWithDelay:5];
    }];
}

- (void)timeDown {
    self.getBtn.enabled = NO;
    [self.getBtn setTitleColor:RGB(0X666666) forState:UIControlStateNormal];
    WS(weakSelf);
    __block NSInteger timeout = 60; // 倒计时时间
    if (timeout!=0) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC,  0); //每秒执行
        dispatch_source_set_event_handler(timer, ^{
            if(timeout <= 1){ 
                dispatch_source_cancel(timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.getBtn.enabled = YES;
                    [weakSelf.getBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    [weakSelf.getBtn setTitleColor:RGB(0XFA8A03) forState:UIControlStateNormal];
                });
            } else { // 倒计时重新计算 时/分/秒
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *title = [NSString stringWithFormat:@"%lds",timeout];
                    [weakSelf.getBtn setTitle:title forState:UIControlStateNormal];
                });
                timeout--; // 递减 倒计时-1(总时间以秒来计算)
            }
        });
        dispatch_resume(timer);
    }
}

- (void)alertViewWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

//获取设备当前网络IP地址
- (NSString *)getIPAddress:(BOOL)preferIPv4{
    NSArray *searchArray = preferIPv4 ?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
//    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

//获取所有相关IP信息
- (NSDictionary *)getIPAddresses{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                    
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}


@end
