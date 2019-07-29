//
//  WorkModel.h
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/9.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *count;

@property (copy, nonatomic) NSString *urlSheme;

@property (nonatomic, copy) NSString *words;

@end
