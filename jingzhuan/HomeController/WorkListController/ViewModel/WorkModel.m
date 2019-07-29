//
//  WorkModel.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/9.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "WorkModel.h"

@implementation WorkModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setDefaultView];
    }
    return self;
}

- (void)setDefaultView {
    self.title = @"京东1元代购";
    self.money = @"3.80";
    
    int n = arc4random_uniform(1000);
    self.count = [NSString stringWithFormat:@"%d",n + 1];
    self.words = @"京东";
}

@end
