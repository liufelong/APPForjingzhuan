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

- (void)mineHeaderSetMessage:(NSDictionary *)dict {
    self.yuELabel.text = dict[@"balance"];
    self.todayLabel.text = dict[@"todayMoney"];
    self.allMoneyLabel.text = dict[@"totalMoney"];
    
    NSString *headimgurl = dict[@"headimgurl"];
    if (headimgurl.length > 0) {
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:headimgurl] placeholderImage:[UIImage imageNamed:@"home_header"]];
    }
    self.nameLabel.text = dict[@"nickname"];
    self.numberLabel.text = dict[@"phone"];
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
