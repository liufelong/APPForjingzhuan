//
//  HomeBottonBtnView.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/4.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "HomeBottonBtnView.h"

@implementation HomeBottonBtnView

+ (instancetype)standView {
    HomeBottonBtnView *view = [[NSBundle mainBundle] loadNibNamed:@"HomeBottonBtnView" owner:nil options:nil][0];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
    return view;
}

- (IBAction)buttonAction:(UIButton *)sender {
    if (self.buttonBlock) {
        self.buttonBlock(sender.tag);
    }
}


@end
