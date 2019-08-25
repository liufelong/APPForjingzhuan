//
//  WorkModel.h
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/9.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkModel : NSObject

@property (nonatomic, copy) NSString *tId;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *appIcon;
@property (copy, nonatomic) NSString *total;//剩余数量
@property (nonatomic, copy) NSString *amount;//价格

@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSString *guidance;//引导语
@property (nonatomic, copy) NSString *advertiserId;
@property (nonatomic, copy) NSString *interfaceType;//广告主任务类型（1快速任务；2回调任务

@end
