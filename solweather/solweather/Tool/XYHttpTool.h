//
//  XYHttpTool.h
//  Sol°C
//
//  Created by xiayao on 16/2/2.
//  Copyright © 2016年 xiayao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYHttpTool : NSObject
/**
 *  发送请求天气数据的GET方法
 *
 *  @param URLString  请求的URL字符串
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
@end
