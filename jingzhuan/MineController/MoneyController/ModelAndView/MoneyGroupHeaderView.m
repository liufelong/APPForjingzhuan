//
//  MoneyGroupHeaderView.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/4.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "MoneyGroupHeaderView.h"

@implementation MoneyGroupHeaderView

+ (instancetype)groupHeader {
    MoneyGroupHeaderView *view = [[NSBundle mainBundle] loadNibNamed:@"MoneyGroupHeaderView" owner:nil options:nil][0];
    return view;
}

@end
