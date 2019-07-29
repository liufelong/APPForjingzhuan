//
//  MineTableHeaderView.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/7.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "MineTableHeaderView.h"

@implementation MineTableHeaderView

+ (instancetype)tableHeaderView {
    MineTableHeaderView *view = [[NSBundle mainBundle] loadNibNamed:@"MineTableHeaderView" owner:nil options:nil][0];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 220);
    return view;
}

+ (instancetype)tableHeaderViewForSet {
    MineTableHeaderView *view = [[NSBundle mainBundle] loadNibNamed:@"MineTableHeaderView" owner:nil options:nil][1];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
    return view;
}

- (IBAction)btnAction:(UIButton *)sender {
    if (self.buttonBlock) {
        self.buttonBlock(sender.tag);
    }
}


@end
