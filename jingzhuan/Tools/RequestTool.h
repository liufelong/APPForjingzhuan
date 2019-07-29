//
//  RequestTool.h
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/23.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RequestTool : NSObject

+ (RequestTool *)tool;
- (void)checkInterNet;

- (void)requsetWithController:(UIViewController *)vc
                           url:(NSString *)url
                          body:(NSDictionary *)body
                       Success:(void (^)(NSDictionary * result))success
                    andFailure:(void(^)(NSString *errorType))failure;

@end

NS_ASSUME_NONNULL_END
