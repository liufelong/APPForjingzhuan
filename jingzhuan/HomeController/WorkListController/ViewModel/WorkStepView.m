//
//  WorkStepView.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/10.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "WorkStepView.h"

@implementation WorkStepView

+ (instancetype)viewForFirstView {
    WorkStepView *view = [[NSBundle mainBundle] loadNibNamed:@"WorkStepView" owner:nil options:nil][0];
    view.firstBgView.layer.shadowColor = [UIColor blackColor].CGColor;
    view.firstBgView.layer.shadowOffset = CGSizeMake(0,0);
    view.firstBgView.layer.shadowRadius = 3;
    view.firstBgView.layer.shadowOpacity = 0.5;
    view.firstBgView.layer.masksToBounds = YES;
    view.firstBgView.layer.cornerRadius = 3;
    view.firstBgView.clipsToBounds = NO;
    
    view.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    view.bgView.layer.shadowOffset = CGSizeMake(0,0);
    view.bgView.layer.shadowRadius = 3;
    view.bgView.layer.shadowOpacity = 0.5;
    view.bgView.layer.masksToBounds = YES;
    view.bgView.layer.cornerRadius = 3;
    view.bgView.clipsToBounds = NO;
    return view;
}

+ (instancetype)viewForSecondView {
    WorkStepView *view = [[NSBundle mainBundle] loadNibNamed:@"WorkStepView" owner:nil options:nil][1];
    return view;
}

+ (instancetype)viewForThirdView {
    WorkStepView *view = [[NSBundle mainBundle] loadNibNamed:@"WorkStepView" owner:nil options:nil][2];
    return view;
}

- (IBAction)buttonAction:(UIButton *)sender {
    if (self.buttonBlock) {
        self.buttonBlock();
    }
}


@end
