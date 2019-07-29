//
//  HomeTableCell.h
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/2.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWith;

@property (nonatomic, copy) void(^buttonBlock)(NSInteger tag);

- (void)setButtonViewWithArray:(NSArray *)arr;

@end
