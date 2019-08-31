//
//  WorkModel.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/9.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "WorkModel.h"

@implementation WorkModel

- (void)setTotal:(NSString *)total {
    _total = [NSString stringWithFormat:@"%@",total];
}

- (void)setAmount:(NSString *)amount {
    _amount = [NSString stringWithFormat:@"%@",amount];
}

- (void)setInterfaceType:(NSString *)interfacetype {
    _interfacetype = [NSString stringWithFormat:@"%@",interfacetype];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (id)valueForUndefinedKey:(NSString *)key {
    return @"";
}

@end
