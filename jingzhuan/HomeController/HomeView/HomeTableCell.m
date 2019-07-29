//
//  HomeTableCell.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/2.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "HomeTableCell.h"
#import "HomeBottonBtnView.h"

@implementation HomeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setButtonView {
    HomeBottonBtnView *bottomView = [HomeBottonBtnView standView];
    bottomView.buttonBlock = ^(NSInteger tag) {
        if (self.buttonBlock) {
            self.buttonBlock(tag);
        }
    };
    UIView *bgView = [[UIView alloc] initWithFrame:bottomView.frame];
    [bgView addSubview:bottomView];
    [self.scrollView addSubview:bgView];
}

- (IBAction)buttonAction:(UIButton *)sender {
    if (self.buttonBlock) {
        self.buttonBlock(sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
