//
//  TiXianViewController.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/9.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "TiXianViewController.h"

#import "TiXianTableViewCell.h"
#import "TiXianButtonView.h"

#import "TiXianModel.h"

@interface TiXianViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) TiXianModel *tableModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TiXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableModel = [[TiXianModel alloc] initWithTitle:self.title];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView reloadData];
    
    TiXianButtonView *btnView = [TiXianButtonView buttonView];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    [bgView addSubview:btnView];
    self.tableView.tableFooterView = bgView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableModel.tableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    footView.backgroundColor = [UIColor whiteColor];
    UIView *linView = [[UIView alloc] initWithFrame:CGRectMake(20, 2, SCREEN_WIDTH - 40, 1)];
    linView.backgroundColor = RGB(0xCCCCCC);
    [footView addSubview:linView];
    return footView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *groupArray = self.tableModel.tableArray[section];
    return groupArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellModel *item = self.tableModel.tableArray[indexPath.section][indexPath.row];
    return item.cellHight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellModel *item = self.tableModel.tableArray[indexPath.section][indexPath.row];
    static NSString *identifier = @"TiXianTableViewCell";
    TiXianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][item.cellType];
    }
    if (item.cellType == 0) {
        cell.titleLabel.text = item.title;
        cell.textField.placeholder = [NSString stringWithFormat:@"请输入%@",item.title];
    }else {
        cell.yuELabel.text = [NSString stringWithFormat:@"账户余额为¥%@",self.tableModel.yuE];
        cell.collectionArray = self.tableModel.collectionArray;
        [cell reloadCollectionView];
    }
    
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
