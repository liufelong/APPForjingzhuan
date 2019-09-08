//
//  MoneyDetailController.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/4.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "MoneyDetailController.h"

#import "MoneyGroupHeaderView.h"
#import "MoneyDetailCell.h"

#import "DetailModel.h"
#import <MJRefresh.h>

@interface MoneyDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArray;

@property (assign, nonatomic) NSInteger page;
@end

@implementation MoneyDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableArray = [NSMutableArray new];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.page = 1;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self requestDateFirstPage:YES];
//    }];
//    [self.tableView.mj_header beginRefreshing];
//
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [self requestDateFirstPage:NO];
//    }];
    [self requestDateFirstPage:YES];
    [self.tableView reloadData];
}

- (void)requestDateFirstPage:(BOOL)isFirst {
    if (isFirst) {
        self.page = 1;
        [self.tableArray removeAllObjects];
    }
    NSDictionary *body = @{@"pageNumber":[NSString stringWithFormat:@"%ld",self.page],
                           @"token":[UserDefaults valueForKey:@"token"],
                           @"userId":[UserDefaults valueForKey:@"userId"]};
    [[RequestTool tool] requsetWithController:self url:@"pub/user/billInfo" body:body Success:^(id  _Nonnull result) {
        [self endRefrish];
        NSArray *billList = result[@"billList"];
        for (NSDictionary *dict in billList) {
            DetailModel *item = [[DetailModel alloc] init];
            [item setValuesForKeysWithDictionary:dict];
            [self.tableArray addObject:item];
        }
        [self.tableView reloadData];
    } andFailure:^(NSString * _Nonnull errorType) {
        [self endRefrish];
        [SVProgressHUD showErrorWithStatus:errorType];
        [SVProgressHUD dismissWithDelay:5];
    }];
}

- (void)endRefrish {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MoneyDetailCell";
    MoneyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][0];
    }
    DetailModel *model = self.tableArray[indexPath.row];
    cell.model = model;
    return cell;
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
