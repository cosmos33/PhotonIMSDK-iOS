/*!

 @header PhotonIMError.h

 @abstract PhotonIMError 错误管理类

 @author Created by Bruce on 2019/6/27.

 @version 2.1.1 2019/12/25 Creation

*/

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
/*!

@class PhotonIMError

@abstract  错误管理类

*/
@interface PhotonIMError : NSError
/*!

@property em

@abstract  错误原因

*/
@property(nonatomic,copy,readonly,nullable,)NSString *em;

/*!

@property retTime

@abstract 消息收到ret的时间

*/
@property(nonatomic, assign)int16_t retTime;
/*!
@abstract 初始化方法


@param domain 错误域
@param code 错误编码
@param em 错误原因
@param dict IMSDK 服务分配的唯一id
@return PhotonIMError对象
*/
- (instancetype)initWithDomain:(NSErrorDomain)domain code:(NSInteger)code errorMessage:(NSString *)em userInfo:(NSDictionary<NSErrorUserInfoKey,id> *)dict;

/*!
@abstract 遍历构造方法

@param domain 错误域
@param code 错误编码
@param em 错误原因
@param dict IMSDK 服务分配的唯一id
@return PhotonIMError对象
*/
+ (instancetype)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code errorMessage:(NSString *)em userInfo:(NSDictionary<NSErrorUserInfoKey,id> *)dict;
@end

NS_ASSUME_NONNULL_END
