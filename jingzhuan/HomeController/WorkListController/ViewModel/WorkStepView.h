//
//  WorkStepView.h
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/10.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkStepView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UIView *firstBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstBgViewWith;
@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (copy, nonatomic) void(^buttonBlock)(void);

+ (instancetype)viewForFirstView;
+ (instancetype)viewForSecondView;
+ (instancetype)viewForThirdView;

@end
