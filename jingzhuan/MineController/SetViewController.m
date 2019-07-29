//
//  SetViewController.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/14.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//


#import "SetViewController.h"

#import "MineTableHeaderView.h"
#import "MineTableCell.h"
#import "TiXianButtonView.h"

#import "TiXianModel.h"

@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *tableArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/*!1男  2女*/
@property (assign, nonatomic) NSInteger sexCode;
@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    MineTableHeaderView *header = [MineTableHeaderView tableHeaderViewForSet];
    UIView *bgView = [[UIView alloc] initWithFrame:header.frame];
    [bgView addSubview:header];
    self.tableView.tableHeaderView = bgView;
    
    TiXianButtonView *btnView = [TiXianButtonView buttonView];
    [btnView.btn setTitle:@"保存" forState:UIControlStateNormal];
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    [footView addSubview:btnView];
    self.tableView.tableFooterView = footView;
    
    [self creatDate];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
}

- (void)creatDate {
    self.tableArray = [NSMutableArray new];
    self.sexCode = 1;
    NSArray *titleArr = @[@"昵称",@"性别",@"手机",@"微信"];
    for (NSString *titleStr in titleArr) {
        CellModel *item = [[CellModel alloc] init];
        item.title = titleStr;
        item.cellHight = 100;
        item.cellType = 1;
        if ([titleStr isEqualToString:@"性别"]) {
            item.cellType = 2;
            item.cellHight = 80;
        }
        [self.tableArray addObject:item];
    }
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
    CellModel *model = self.tableArray[indexPath.row];
    return model.cellHight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellModel *model = self.tableArray[indexPath.row];
    static NSString *idenifier = @"MineTableCell";
    MineTableCell *cell = [tableView dequeueReusableCellWithIdentifier:idenifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:idenifier owner:nil options:nil][model.cellType];
    }
    cell.titleLabel.text = model.title;
    cell.textField.placeholder = [NSString stringWithFormat:@"请输入%@",model.title];
    if ([model.title isEqualToString:@"性别"]) {
        if (self.sexCode == 1) {
            cell.manBtn.selected = YES;
            cell.womanBtn.selected = NO;
        }else {
            cell.manBtn.selected = NO;
            cell.womanBtn.selected = YES;
        }
    }
    return cell;
}

@end
