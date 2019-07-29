//
//  MineTableCell.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/7.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "MineTableCell.h"

@implementation MineTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)sexBtnAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    self.manBtn.selected = NO;
    self.womanBtn.selected = NO;
    sender.selected = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
