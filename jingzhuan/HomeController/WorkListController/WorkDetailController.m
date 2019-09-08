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

//获取Mac地址
#import <sys/sysctl.h>
//#import <net/if.h>
#import <net/if_dl.h>

@interface WorkDetailController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/*!body*/
@property (strong, nonatomic) NSDictionary *body;

@end

@implementation WorkDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGB(0XFEA403);
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 60, 40);
    [cancelBtn setTitle:@"取消任务" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitleColor:RGB(0X666666) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelWorkAction) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 1160);
    UIImageView *bgImag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1160)];
    bgImag.image = [UIImage imageNamed:@"work_detail_bg"];
    [self.scrollView addSubview:bgImag];
    
    WorkStepView *first = [WorkStepView viewForFirstView];
    first.frame = CGRectMake(0, 0, SCREEN_WIDTH, 330);
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 250, SCREEN_WIDTH, 330)];
    [firstView addSubview:first];
    [first.logoImage sd_setImageWithURL:[NSURL URLWithString:self.model.appicon] placeholderImage:[UIImage imageNamed:@"work_logo"]];
    first.wordLabel.text = self.model.keyword;
    CGFloat width = [self.model.keyword sizeWithAttributes:@{NSFontAttributeName:first.wordLabel.font}].width;
    first.firstBgViewWith.constant = width + 200;
    
    first.buttonBlock = ^{
        [[UIPasteboard generalPasteboard] setString:self.model.keyword];
        NSString *str =@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/search";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
    };
    [self.scrollView addSubview:firstView];
    
    WorkStepView *second = [WorkStepView viewForSecondView];
    second.frame = CGRectMake(0, 0, SCREEN_WIDTH, 230);
    second.buttonBlock = ^{
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.model.appid] options:@{} completionHandler:^(BOOL success) {
//            if (!success) {
//                NSString *message = [NSString stringWithFormat:@"您尚未按装%@请通过第一步下载安装",self.model.appname];
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//                [alert addAction:okAction];
//                [self presentViewController:alert animated:YES completion:nil];
//            }else {
//                [self updateWorkProgress];
//            }
//        }];
        [self updateWorkProgress];
    };
    UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 600, SCREEN_WIDTH, 230)];
    [secondView addSubview:second];
    [self.scrollView addSubview:secondView];
    
    WorkStepView *third = [WorkStepView viewForThirdView];
    third.frame = CGRectMake(0, 0, SCREEN_WIDTH, 270);
    third.buttonBlock = ^{

        [self taskActive];
    };
    UIView *thirdView = [[UIView alloc] initWithFrame:CGRectMake(0, 850, SCREEN_WIDTH, 270)];
    [thirdView addSubview:third];
    [self.scrollView addSubview:thirdView];
    
}

- (void)cancelWorkAction {
    NSDictionary *body = @{@"token":[UserDefaults valueForKey:@"token"],
                           @"userId":[UserDefaults valueForKey:@"userId"],
                           @"tId":self.model.tid};
    [[RequestTool tool] requsetWithController:self url:@"pub/task/taskQuit" body:body Success:^(id  _Nonnull result) {
        
        [self.navigationController popViewControllerAnimated:YES];
    } andFailure:^(NSString * _Nonnull errorType) {
        [SVProgressHUD showErrorWithStatus:errorType];
        [SVProgressHUD dismissWithDelay:5];
    }];
}

//打开APP上报信息
- (void)updateWorkProgress {
    
    NSString *idfa = [UserDefaults valueForKey:@"IDFA"];
    if (idfa.length < 1) {
        idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        [UserDefaults setValue:idfa forKey:@"IDFA"];
    }
    
    self.body = @{@"token":[UserDefaults valueForKey:@"token"],
                           @"userId":[UserDefaults valueForKey:@"userId"],
                           @"udid":[[UIDevice currentDevice] identifierForVendor].UUIDString,
                           @"idfa":idfa,
                           @"tId":self.model.tid,
                           @"interfaceType":self.model.interfacetype,
                           @"advertiserId":self.model.advertiserid,
                           @"ip":[self getIPAddress:YES],
                           @"os": [[UIDevice currentDevice] systemVersion],
                           @"device":@"iphone",
                           @"keyword":self.model.keyword,
                           @"appid":self.model.appid,
                           @"mac":[self macaddress]};
    [[RequestTool tool] requsetWithController:self url:@"pub/task/taskClick" body:self.body Success:^(id  _Nonnull result) {
        
    } andFailure:^(NSString * _Nonnull errorType) {
        [SVProgressHUD showErrorWithStatus:errorType];
        [SVProgressHUD dismissWithDelay:5];
    }];
    
}

//领取红包
- (void)taskActive {
    if (!self.body) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请通过第二步打开APP" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [[RequestTool tool] requsetWithController:self url:@"pub/task/taskActive" body:self.body Success:^(id  _Nonnull result) {
        [SVProgressHUD showSuccessWithStatus:@"领取成功"];
        [SVProgressHUD dismissWithDelay:3 completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updataMoney" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    } andFailure:^(NSString * _Nonnull errorType) {
        [SVProgressHUD showErrorWithStatus:errorType];
        [SVProgressHUD dismissWithDelay:5];
    }];
}

//获取Mac地址
- (NSString *)macaddress{
    
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return @"";
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return @"";
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return @"";
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return @"";
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    //    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    NSLog(@"outString:%@", outstring);
    free(buf);
    return [outstring uppercaseString];
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
