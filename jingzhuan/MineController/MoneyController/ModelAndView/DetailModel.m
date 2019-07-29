//
//  DetailModel.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/4.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "DetailModel.h"

@implementation DetailModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setDefaultView];
    }
    return self;
}

- (void)setDefaultView {
    self.title = @"提现";
    self.date = @"2019-09-09 10:00";
    self.money = @"3.80";
    
    int n = arc4random_uniform(3);
    NSArray *stateArr = @[@"交易中",@"交易成功",@"交易失败",@""];
    self.stateString = stateArr[n];
    self.state = [NSString stringWithFormat:@"%d",n + 1];
}

@end

@implementation GroupModel

- (instancetype) init {
    self = [super init];
    if (self) {
        self.groupTitle = @"";
        self.cellArray = [NSMutableArray new];
        for (int i = 0; i < 8; i++) {
            DetailModel *item = [[DetailModel alloc] init];
            [self.cellArray addObject:item];
        }
    }
    return self;
}

@end
