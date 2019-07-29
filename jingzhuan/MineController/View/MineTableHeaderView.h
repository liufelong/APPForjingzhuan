//
//  MineTableHeaderView.h
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/7.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuELabel;
@property (weak, nonatomic) IBOutlet UILabel *allMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;

@property (copy, nonatomic) void(^buttonBlock)(NSInteger tag);

+ (instancetype)tableHeaderView;
+ (instancetype)tableHeaderViewForSet;

@end
