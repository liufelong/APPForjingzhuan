//
//  WorkListCell.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/7.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "WorkListCell.h"

@implementation WorkListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleImage.layer.masksToBounds = YES;
    self.titleImage.layer.cornerRadius = 4;
    
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(0,0);
    self.bgView.layer.shadowRadius = 3;
    self.bgView.layer.shadowOpacity = 0.5;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 3;
    self.bgView.clipsToBounds = NO;
}

- (void)setModel:(WorkModel *)model {
    self.titleLabel.text = model.appname;
    self.moneyLabel.text = model.amount;
    self.shengyuLabel.text = [NSString stringWithFormat:@"剩余%@份",model.total];
    
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:model.appicon] placeholderImage:[UIImage imageNamed:@"work_logo"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
