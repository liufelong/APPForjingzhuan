//
//  TiXianButtonView.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/14.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "TiXianButtonView.h"

@implementation TiXianButtonView

+ (instancetype)buttonView {
    TiXianButtonView *view = [[NSBundle mainBundle] loadNibNamed:@"TiXianButtonView" owner:nil options:nil][0];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
    return view;
}

- (IBAction)buttonActon:(UIButton *)sender {
    
}

@end
