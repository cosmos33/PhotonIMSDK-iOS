//
//  PhotonIMError.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/25.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/* 发送消息回执的错误列表
 code    描述
 0       发送成功
 1000    服务器内部错误
 1001    消息内容包含敏感词
 1002    图片非法
 1003    消息发送频率过高
 1004    消息不可撤回
 1005    撤回消息功能未开启
 1006    参数错误
 1008    客户端群消息开关关闭,暂不支持群组聊天
-1001   消息格式错误
 -1     消息发送超时
 -2     消息格式错误
 */

@interface PhotonIMError : NSError
@property(nonatomic,copy,readonly,nullable,)NSString *em;
@property(nonatomic, assign)int16_t retTime;
- (instancetype)initWithDomain:(NSErrorDomain)domain code:(NSInteger)code errorMessage:(NSString *)em userInfo:(NSDictionary<NSErrorUserInfoKey,id> *)dict;
+ (instancetype)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code errorMessage:(NSString *)em userInfo:(NSDictionary<NSErrorUserInfoKey,id> *)dict;
@end

NS_ASSUME_NONNULL_END
