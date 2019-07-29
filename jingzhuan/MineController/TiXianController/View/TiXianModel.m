//
//  TiXianModel.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/14.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "TiXianModel.h"

@implementation CellModel

@end

@implementation CollectionModel

@end

@implementation TiXianModel

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.tableArray = [NSMutableArray new];
        NSMutableArray *group1 = [NSMutableArray new];
        CellModel *item1 = [[CellModel alloc] init];
        item1.title = @"姓名";
        item1.cellType = 0;
        item1.cellHight = 90;
        [group1 addObject:item1];
        
        CellModel *item2 = [[CellModel alloc] init];
        item2.title = @"支付宝账号";
        if ([title containsString:@"微信"]) {
            item2.title = @"微信账号";
        }
        item2.cellType = 0;
        item2.cellHight = 90;
        [group1 addObject:item2];
        [self.tableArray addObject:group1];
        
        CellModel *cellItem = [[CellModel alloc] init];
        cellItem.cellType = 1;
        cellItem.cellHight = 190;
        [self.tableArray addObject:@[cellItem]];
        
        NSArray *moneyArr = @[@"5",@"10",@"50",@"100",@"200",@"500"];
        self.collectionArray = [NSMutableArray new];
        for (NSString *money in moneyArr) {
            CollectionModel *model = [[CollectionModel alloc] init];
            model.money = money;
            model.isSelect = NO;
            if ([money isEqualToString:@"5"]) {
                model.isSelect = YES;
            }
            [self.collectionArray addObject:model];
        }
        self.yuE = @"1234.99";
    }
    return self;
}

@end
