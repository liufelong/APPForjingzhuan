//
//  ALertController.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/26.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "ALertController.h"

@interface ALertController ()

@end

@implementation ALertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//保证弹出层在当前window 最上层 （UITransitionView 唯一）
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIWindow * win = [UIApplication sharedApplication].keyWindow;
    for(UIView * view in win.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITransitionView")]){
            //            view.layer.zPosition = 2;
            [win bringSubviewToFront:view];
            break;
        }
    }
}

@end
