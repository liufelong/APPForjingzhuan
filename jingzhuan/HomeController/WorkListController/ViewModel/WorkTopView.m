//
//  WorkTopView.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/9.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "WorkTopView.h"

@implementation WorkTopView

+ (instancetype)topViewStand {
    WorkTopView *view = [[NSBundle mainBundle] loadNibNamed:@"WorkTopView" owner:nil options:nil][0];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 170);
    return view;
}

+ (instancetype)groupHeaderView {
    WorkTopView *view = [[NSBundle mainBundle] loadNibNamed:@"WorkTopView" owner:nil options:nil][1];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    return view;
}

@end
