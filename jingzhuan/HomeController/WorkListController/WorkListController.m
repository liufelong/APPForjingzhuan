//
//  WorkListController.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/7.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "WorkListController.h"
#import "WorkDetailController.h"

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

//获取Mac地址
#import <sys/sysctl.h>
//#import <net/if.h>
#import <net/if_dl.h>

#import "WorkModel.h"
#import "WorkListCell.h"
#import "WorkTopView.h"

@interface WorkListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArray;
/*!进行中*/
@property (strong, nonatomic) NSMutableArray *progressArray;
/*!投放中*/
@property (strong, nonatomic) NSMutableArray *putArray;

@end

@implementation WorkListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    WorkTopView *workView = [WorkTopView topViewStand];
    UIView *topView = [[UIView alloc] initWithFrame:workView.frame];
    [topView addSubview:workView];
    self.tableView.tableHeaderView = topView;
    
    [self creatDate];
    [self.tableView reloadData];
}

- (void)creatDate {
    self.tableArray = [NSMutableArray new];
    self.progressArray = [NSMutableArray new];
    self.putArray = [NSMutableArray new];
    NSDictionary *goingTask = self.workDate[@"goingTask"];
    NSArray *keysArr = [goingTask allKeys];
    if (keysArr.count > 0) {
        WorkModel *item = [[WorkModel alloc] init];
        [item setValuesForKeysWithDictionary:goingTask];
        [self.progressArray addObject:item];
    }
    NSArray *taskList = self.workDate[@"taskList"];
    for (NSDictionary *dict in taskList) {
        WorkModel *item = [[WorkModel alloc] init];
        [item setValuesForKeysWithDictionary:dict];
        [self.putArray addObject:item];
    }
    if (self.progressArray.count > 0) {
        [self.tableArray addObject:@{@"groupTitle":@"进行中",@"cellArray":self.progressArray}];
    }
    if (self.putArray.count > 0) {
        [self.tableArray addObject:@{@"groupTitle":@"投放中",@"cellArray":self.putArray}];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WorkTopView *groupHeader = [WorkTopView groupHeaderView];
    NSDictionary *groupDict = self.tableArray[section];
    groupHeader.titleLabel.text = groupDict[@"groupTitle"];
    return groupHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     NSDictionary *groupDict = self.tableArray[section];
    NSMutableArray *array = groupDict[@"cellArray"];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"WorkListCell";
    WorkListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][0];
    }
    NSDictionary *groupDict = self.tableArray[indexPath.section];
    NSMutableArray *array = groupDict[@"cellArray"];
    WorkModel *model = array[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *groupDict = self.tableArray[indexPath.section];
    NSString *title = groupDict[@"groupTitle"];
    NSString *showMessage = @"";
    NSMutableArray *array = groupDict[@"cellArray"];
    WorkModel *model = array[indexPath.row];
    
    if ([title isEqualToString:@"投放中"]) {
        showMessage = @"任务抢夺中";
        NSString *idfa = [UserDefaults valueForKey:@"IDFA"];
        if (idfa.length < 1) {
            idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            [UserDefaults setValue:idfa forKey:@"IDFA"];
        }
        NSDictionary *body = @{@"token":[UserDefaults valueForKey:@"token"],
                               @"userId":[UserDefaults valueForKey:@"userId"],
                               @"udid":[[UIDevice currentDevice] identifierForVendor].UUIDString,
                               @"idfa":idfa,
                               @"tId":model.tid,
                               @"interfaceType":model.interfacetype,
                               @"advertiserId":model.advertiserid,
                               @"ip":@"10.12.1.1",//[self getDeviceIPIpAddresses],
                               @"os": [[UIDevice currentDevice] systemVersion],
                               @"device":@"iphone",
                               @"keyword":model.keyword,
                               @"appid":model.appid,
                               @"mac":[self macaddress],
                               @"showMessage":showMessage};

        WorkDetailController *detailVC = [[WorkDetailController alloc] init];
        detailVC.title = @"任务详情";
        detailVC.model = model;
        [self.navigationController pushViewController:detailVC animated:YES];

        [[RequestTool tool] requsetWithController:self url:@"pub/task/taskQuery" body:body Success:^(id  _Nonnull result) {
            NSString *code = result[@"code"];
            if ([code isEqualToString:@"7777"]) {
                [self userAuthWithModel:model];
            }else {
                WorkDetailController *detailVC = [[WorkDetailController alloc] init];
                detailVC.title = @"任务详情";
                detailVC.model = model;
                [self.navigationController pushViewController:detailVC animated:YES];
            }

        } andFailure:^(NSString * _Nonnull errorType) {
            [SVProgressHUD showErrorWithStatus:errorType];
            [SVProgressHUD dismissWithDelay:5];
        }];
    }else {
        WorkDetailController *detailVC = [[WorkDetailController alloc] init];
        detailVC.title = @"任务详情";
        detailVC.model = model;
        [self.navigationController pushViewController:detailVC animated:YES];

    }
}

- (void)userAuthWithModel:(WorkModel *)model {
//    aid=2026296478
    [[TCWebCodesBridge sharedBridge] loadTencentCaptcha:self.view appid:@"2026296478" callback:^(NSDictionary *resultJSON) {
        NSLog(@"%@",resultJSON);
        NSString *ticket = resultJSON[@"ticket"];
        if (ticket.length > 0) {
            NSString *idfa = [UserDefaults valueForKey:@"IDFA"];
            if (idfa.length < 1) {
                idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
                [UserDefaults setValue:idfa forKey:@"IDFA"];
            }
            NSDictionary *body = @{@"token":[UserDefaults valueForKey:@"token"],
                                   @"userId":[UserDefaults valueForKey:@"userId"],
                                   @"ticket":ticket,
                                   @"randstr":resultJSON[@"randstr"],
                                   @"userIp":[self getIPAddress:YES],
                                   @"udid":[[UIDevice currentDevice] identifierForVendor].UUIDString,
                                   @"idfa":idfa};
            [[RequestTool tool] requsetWithController:self url:@"pub/user/userAuth" body:body Success:^(id  _Nonnull result) {
                WorkDetailController *detailVC = [[WorkDetailController alloc] init];
                detailVC.title = @"任务详情";
                detailVC.model = model;
                [self.navigationController pushViewController:detailVC animated:YES];
            } andFailure:^(NSString * _Nonnull errorType) {
                [SVProgressHUD showErrorWithStatus:errorType];
                [SVProgressHUD dismissWithDelay:5];
            }];
        }
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

@end
