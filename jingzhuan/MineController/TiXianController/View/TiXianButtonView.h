//
//  TiXianButtonView.h
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/14.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TiXianButtonView : UIView
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (copy, nonatomic) void(^buttonBlock)(void);

+ (instancetype)buttonView;

@end

NS_ASSUME_NONNULL_END
