//
//  DetailModel.h
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/4.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject

@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *sourceString;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *typeString;
@property (nonatomic, copy) NSString *type;//1收入 2支出

@end

@interface GroupModel : NSObject

@property (nonatomic, copy) NSString *groupTitle;
@property (nonatomic, strong) NSMutableArray *cellArray;

@end
