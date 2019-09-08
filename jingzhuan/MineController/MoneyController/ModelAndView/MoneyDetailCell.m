//
//  MoneyDetailCell.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/4.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "MoneyDetailCell.h"

@implementation MoneyDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(DetailModel *)model {
    self.titleLabel.text = model.sourceString;
    self.dateLabel.text = model.createtime;
    self.moneyLabel.text = model.amount;
    self.typeLabel.text = @"-";
    if ([model.type isEqualToString:@"1"]) {
        self.typeLabel.text = @"+";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
