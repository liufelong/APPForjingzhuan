//
//  MineViewController.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/7.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "MineViewController.h"
#import "MoneyDetailController.h"
#import "AboutViewController.h"
#import "TiXianTypeViewController.h"
#import "SetViewController.h"

#import "LoginViewController.h"

#import "MineTableHeaderView.h"
#import "MineTableCell.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dateArray;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    MineTableHeaderView *headerView = [MineTableHeaderView tableHeaderView];
    headerView.buttonBlock = ^(NSInteger tag){
        if (tag == 1) {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self presentViewController:login animated:YES completion:nil];
        }else {
            TiXianTypeViewController *txVC = [[TiXianTypeViewController alloc] init];
            txVC.title = @"提现方式";
            [self.navigationController pushViewController:txVC animated:YES];
        }
    };
    UIView *bgView = [[UIView alloc] initWithFrame:headerView.frame];
    [bgView addSubview:headerView];
    self.tableView.tableHeaderView = bgView;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dateArray = [NSMutableArray arrayWithArray:@[@{@"img":@"mine_money",@"title":@"收支明细"},
                                                      @{@"img":@"mine_about",@"title":@"关于净赚"},
                                                      @{@"img":@"mine_set",@"title":@"设置"}]];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dateArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MineTableCell";
    MineTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] [0];
    }
    NSDictionary *dict = self.dateArray[indexPath.row];
    cell.imgView.image = [UIImage imageNamed:dict[@"img"]];
    cell.titleLabel.text = dict[@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dateArray[indexPath.row];
    NSString *title = dict[@"title"];
    if ([title isEqualToString:@"收支明细"]) {
        MoneyDetailController *detailVC = [[MoneyDetailController alloc] init];
        detailVC.title = @"收入明细";
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if ([title isEqualToString:@"关于净赚"]) {
        AboutViewController *about = [[AboutViewController alloc] init];
        about.title = @"关于净赚";
        [self.navigationController pushViewController:about animated:YES];
    }else if ([title isEqualToString:@"设置"]) {
        SetViewController *set = [[SetViewController alloc] init];
        set.title = @"设置";
        [self.navigationController pushViewController:set animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end