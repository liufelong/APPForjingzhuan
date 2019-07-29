//
//  WorkTopView.h
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/9.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkTopView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (instancetype)topViewStand;

+ (instancetype)groupHeaderView;

@end
