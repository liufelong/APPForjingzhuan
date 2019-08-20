//
//  SetViewController.h
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/14.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetViewController : BaseViewController

@property (strong, nonatomic) NSDictionary *mineMessageDict;
@property (copy, nonatomic) void(^updateBlock)(void);

@end

NS_ASSUME_NONNULL_END
