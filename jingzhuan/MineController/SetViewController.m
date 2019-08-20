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
    NSString *headimgurl = self.mineMessageDict[@"headimgurl"];
    if (headimgurl.length > 0) {
        [header.headerImage sd_setImageWithURL:[NSURL URLWithString:headimgurl] placeholderImage:[UIImage imageNamed:@"home_header"]];
    }
    UIView *bgView = [[UIView alloc] initWithFrame:header.frame];
    [bgView addSubview:header];
    self.tableView.tableHeaderView = bgView;
    
    TiXianButtonView *btnView = [TiXianButtonView buttonView];
    [btnView.btn setTitle:@"保存" forState:UIControlStateNormal];
    btnView.buttonBlock = ^{
        [self updateUserMessage];
    };
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    [footView addSubview:btnView];
    self.tableView.tableFooterView = footView;
    
    [self creatDate];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
}

- (void)updateUserMessage {
    NSMutableDictionary *body = [NSMutableDictionary new];
    [body setValue:[UserDefaults valueForKey:@"token"] forKey:@"token"];
    [body setValue:[UserDefaults valueForKey:@"userId"] forKey:@"userId"];
    for (CellModel *model in self.tableArray) {
        [body setValue:model.value forKey:model.key];
    }
    [[RequestTool tool] requsetWithController:self url:@"pub/user/update" body:body Success:^(id  _Nonnull result) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        [SVProgressHUD dismissWithDelay:5 completion:^{
            [self.navigationController popViewControllerAnimated:YES];
            if (self.updateBlock) {
                self.updateBlock();
            }
        }];
    } andFailure:^(NSString * _Nonnull errorType) {
        [SVProgressHUD showErrorWithStatus:errorType];
        [SVProgressHUD dismissWithDelay:5];
    }];
}

- (void)creatDate {
    self.tableArray = [NSMutableArray new];
    self.sexCode = 1;
    NSArray *titleArr = @[@"昵称",@"性别",@"手机",@"微信"];
    NSArray *keyArr = @[@"nickname",@"sex",@"phone",@"wxpayid"];
    if (!self.mineMessageDict) {
        [self loadDate];
    }
    [titleArr enumerateObjectsUsingBlock:^(NSString *  _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
        CellModel *item = [[CellModel alloc] init];
        item.title = title;
        item.key = keyArr[idx];
        item.value = [self.mineMessageDict valueForKey:item.key];
        item.cellHight = 100;
        item.cellType = 1;
        if ([title isEqualToString:@"性别"]) {
            item.cellType = 2;
            item.cellHight = 80;
        }
        [self.tableArray addObject:item];
    }];
    [self.tableView reloadData];
}

- (void)loadDate {
    self.mineMessageDict = @{};
    NSDictionary *body = @{@"token":[UserDefaults valueForKey:@"token"],
                           @"userId":[UserDefaults valueForKey:@"userId"]};
    [[RequestTool tool] requsetWithController:self url:@"pub/user/userInfo" body:body Success:^(id  _Nonnull result) {
        self.mineMessageDict = result;
    } andFailure:^(NSString * _Nonnull errorType) {
        [SVProgressHUD showErrorWithStatus:errorType];
        [SVProgressHUD dismissWithDelay:5];
    }];
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
    cell.textField.text = model.value;
    if ([model.title isEqualToString:@"性别"]) {
        if ([model.value isEqualToString:@"1"]) {
            cell.manBtn.selected = YES;
            cell.womanBtn.selected = NO;
        }else if ([model.value isEqualToString:@"2"]){
            cell.manBtn.selected = NO;
            cell.womanBtn.selected = YES;
        }else {
            cell.manBtn.selected = NO;
            cell.womanBtn.selected = NO;
        }
        cell.btnBlock = ^(NSInteger tag) {
            model.value = [NSString stringWithFormat:@"%ld",tag];
        };
    }
    return cell;
}

@end
