//
//  DetailModel.h
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/4.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *stateString;
@property (nonatomic, copy) NSString *state;

@end

@interface GroupModel : NSObject

@property (nonatomic, copy) NSString *groupTitle;
@property (nonatomic, strong) NSMutableArray *cellArray;

@end
