//
//  HomeBottonBtnView.h
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/4.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeBottonBtnView : UIView
@property (nonatomic, copy) void(^buttonBlock)(NSInteger tag);
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

+ (instancetype)standView;
@end
