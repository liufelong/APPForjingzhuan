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

- (void)setButtonViewWithArray:(NSArray *)arr {
    NSArray *views = [self.scrollView subviews];
    for (UIView *view in views) {
        [view removeFromSuperview];
    }
    [arr enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HomeBottonBtnView *bottomView = [HomeBottonBtnView standView];
        bottomView.buttonBlock = ^(NSInteger tag) {
            if (self.buttonBlock) {
                self.buttonBlock(tag);
            }
        };
        bottomView.frame = CGRectMake(SCREEN_WIDTH * idx, 0, SCREEN_WIDTH, 70);
        bottomView.bottomBtn.tag = idx + 1;
        NSString *img = obj[@"img"];
        [bottomView.bottomBtn sd_setImageWithURL:[NSURL URLWithString:img] forState:UIControlStateNormal];
        UIView *bgView = [[UIView alloc] initWithFrame:bottomView.frame];
        [bgView addSubview:bottomView];
        [self.scrollView addSubview:bgView];
    }];
    
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
