//
//  TiXianTypeViewController.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/18.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "TiXianTypeViewController.h"
#import "TiXianViewController.h"

#import "TiXianTableViewCell.h"

@interface TiXianTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dateSource;

@end

@implementation TiXianTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dateSource = [NSMutableArray arrayWithObjects:@{@"title":@"支付宝提现",@"img":@"tx_zhifubao"},
                                                       @{@"title":@"微信提现",@"img":@"tx_weixin"}, nil];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dateSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"TiXianTableViewCell";
    TiXianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][2];
    }
    NSDictionary *dict = self.dateSource[indexPath.row];
    NSString *title = dict[@"title"];
    cell.titleLabel.text = title;
    cell.titleImg.image = [UIImage imageNamed:dict[@"img"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dateSource[indexPath.row];
    NSString *title = dict[@"title"];
    TiXianViewController *vc = [[TiXianViewController alloc] init];
    vc.title = title;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
