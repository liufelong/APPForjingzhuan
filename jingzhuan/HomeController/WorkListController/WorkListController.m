//
//  WorkListController.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/7.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "WorkListController.h"
#import "WorkDetailController.h"

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
    
    self.tableArray = [NSMutableArray new];
    self.progressArray = [NSMutableArray new];
    self.putArray = [NSMutableArray new];
    for (int i = 0; i < 5; i++) {
        WorkModel *item = [[WorkModel alloc] init];
        [self.progressArray addObject:item];
    }
    
    for (int i = 0; i < 5; i++) {
        WorkModel *item = [[WorkModel alloc] init];
        [self.putArray addObject:item];
    }
    [self.tableArray addObject:self.progressArray];
    [self.tableArray addObject:self.putArray];
    
    [self.tableView reloadData];
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
    [SVProgressHUD showWithStatus:@"任务抢夺中"];
    [SVProgressHUD dismissWithDelay:1 completion:^{
        WorkDetailController *detail = [[WorkDetailController alloc] init];
        detail.title = @"任务详情";
        [self.navigationController pushViewController:detail animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
