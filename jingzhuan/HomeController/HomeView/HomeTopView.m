//
//  HomeTopView.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/1.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "HomeTopView.h"

@implementation HomeTopView

+ (instancetype)viewStand {
    HomeTopView *view = [[NSBundle mainBundle] loadNibNamed:@"HomeTopView" owner:nil options:nil].firstObject;
    [view midViewSet];
    return view;
}
- (IBAction)btnAction:(UIButton *)sender {
    if (self.buttonBlock) {
        self.buttonBlock(sender.tag);
    }
}

- (void)setMessageWith:(NSDictionary *)dict {
    
    self.todayMoneyLabel.text = dict[@"todayMoney"];
    self.totalMoneyLabel.text = dict[@"totalMoney"];
    self.balanceLabel.text = dict[@"balance"];
}

- (void)midViewSet {
    self.midView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.midView.layer.shadowOffset = CGSizeMake(0,0);
    self.midView.layer.shadowRadius = 3;
    self.midView.layer.shadowOpacity = 0.5;
    self.midView.layer.masksToBounds = YES;
    self.midView.clipsToBounds = NO;
}

- (void)awakeFromNib{
    [super awakeFromNib];
}

@end
