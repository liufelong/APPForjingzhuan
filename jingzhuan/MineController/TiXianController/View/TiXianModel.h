//
//  TiXianModel.h
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/14.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *key;
@property (copy, nonatomic) NSString *value;

@property (assign, nonatomic) int cellType;
@property (assign, nonatomic) CGFloat cellHight;

@end

@interface CollectionModel : NSObject

@property (copy, nonatomic) NSString *money;
@property (assign, nonatomic) BOOL isSelect;

@end

@interface TiXianModel : NSObject

@property (strong, nonatomic) NSMutableArray *tableArray;
/*!余额*/
@property (copy, nonatomic) NSString *yuE;
@property (strong, nonatomic) NSMutableArray *collectionArray;

- (instancetype)initWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
