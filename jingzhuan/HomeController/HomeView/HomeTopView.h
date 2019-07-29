//
//  HomeTopView.h
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/1.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTopView : UIView

@property (nonatomic, copy) void(^buttonBlock)(NSInteger tag);
@property (weak, nonatomic) IBOutlet UIView *midView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *todayMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;


+ (instancetype)viewStand;

- (void)setMessageWith:(NSDictionary *)dict;

@end
