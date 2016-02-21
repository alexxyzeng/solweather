//
//  XYHttpTool.m
//  Sol°C
//
//  Created by xiayao on 16/2/2.
//  Copyright © 2016年 xiayao. All rights reserved.
//

#import "XYHttpTool.h"
#import "AFNetworking.h"

@implementation XYHttpTool

+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //创建管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求的数据类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml", nil];
    //xml数据解析
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //发送请求
//    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(error);
//    }];
    [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

@end
