//
//  DetailModel.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/4.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "DetailModel.h"

@implementation DetailModel

- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key {}
- (id)valueForUndefinedKey:(NSString *)key {
    return @"";
}

- (void)setSource:(NSString *)source {
    _source = source;
    switch ([source intValue]) {
        case 1:
            _sourceString = @"提现";
            break;
        case 2:
            _sourceString = @"注册";
            break;
        case 3:
            _sourceString = @"任务";
            break;
        case 4:
            _sourceString = @"奖励";
            break;
        default:
            break;
    }
}

@end

@implementation GroupModel


@end
