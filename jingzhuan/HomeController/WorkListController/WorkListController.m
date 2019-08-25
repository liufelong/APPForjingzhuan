//
//  WorkListController.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/7.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "WorkListController.h"
#import "WorkDetailController.h"

//获取IDFA
#import <AdSupport/AdSupport.h>

//获取手机IP
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>

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
    NSArray *goingTask = self.workDate[@"goingTask"];
    for (NSDictionary *dict in goingTask) {
        WorkModel *item = [[WorkModel alloc] init];
        [item setValuesForKeysWithDictionary:dict];
        [self.progressArray addObject:item];
    }
    NSArray *taskList = self.workDate[@"taskList"];
    for (NSDictionary *dict in taskList) {
        WorkModel *item = [[WorkModel alloc] init];
        [item setValuesForKeysWithDictionary:dict];
        [self.putArray addObject:item];
    }
    
    [self.tableArray addObject:self.progressArray];
    [self.tableArray addObject:self.putArray];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WorkTopView *groupHeader = [WorkTopView groupHeaderView];
    groupHeader.titleLabel.text = @"投放中";
    if (section == 0) {
        groupHeader.titleLabel.text = @"进行中";
    }
    return groupHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *array = self.tableArray[section];
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
    NSMutableArray *array = self.tableArray[indexPath.section];
    WorkModel *model = array[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [SVProgressHUD showWithStatus:@"任务抢夺中"];
//    [SVProgressHUD dismissWithDelay:1 completion:^{
//        WorkDetailController *detail = [[WorkDetailController alloc] init];
//        detail.title = @"任务详情";
//        [self.navigationController pushViewController:detail animated:YES];
//    }];
    if (indexPath.section == 1) {
        WorkModel *model = self.putArray[indexPath.row];
        NSString *idfa = [UserDefaults valueForKey:@"IDFA"];
        if (idfa.length < 1) {
            idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            [UserDefaults setValue:idfa forKey:@"IDFA"];
        }
        NSDictionary *body = @{@"token":[UserDefaults valueForKey:@"token"],
                               @"userId":[UserDefaults valueForKey:@"userId"],
                               @"udid":[[UIDevice currentDevice] identifierForVendor].UUIDString,
                               @"idfa":idfa,
                               @"id":model.tId,
                               @"interfaceType":model.interfaceType,
                               @"advertiserId":model.advertiserId,
                               @"ip":[self getDeviceIPIpAddresses],
                               @"os": [[UIDevice currentDevice] systemVersion],
                               @"device":@"iphone",
                               @"keyword":model.keyword,
                               @"appid":model.appId,
                               @"mac":@""};
        [[RequestTool tool] requsetWithController:self url:@"pub/task/taskClick" body:body Success:^(id  _Nonnull result) {

        } andFailure:^(NSString * _Nonnull errorType) {
            [SVProgressHUD showErrorWithStatus:errorType];
            [SVProgressHUD dismissWithDelay:5];
        }];
    }
}

- (NSString *)getDeviceIPIpAddresses{
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd <<sockfd>>0){
        return @"";
    }
    NSMutableArray *ips = [NSMutableArray array];
    int BUFFERSIZE = 4096;
    struct ifconf ifc;
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ],*cptr;
    struct ifreq *ifr, ifrcopy;
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        for (ptr = buffer; ptr < buffer + ifc.ifc_len;) {
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
                
            }            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0)
                continue;
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            if ((ifrcopy.ifr_flags & IFF_UP) == 0)         continue;
            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    close(sockfd);
    NSString *deviceIP = @"";
    for (int i=0; i < ips.count; i++)    {
        if (ips.count > 0) {
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
        }
    }
    return deviceIP;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
