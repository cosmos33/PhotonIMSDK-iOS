//
//  PhotonIMClient.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/6/27.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PhotonIMClientProtocol.h"
#import "PhotonIMMessage.h"
#import "PhotonIMConversation.h"
#import "PhotonIMError.h"

NS_ASSUME_NONNULL_BEGIN
@interface PhotonIMClient : NSObject
/**
  IM 处理线程，消息发送处理等
 */
@property (nonatomic, strong,readonly, nullable)dispatch_queue_t queue;

/**
 socket连接服务的超时时间
 */
@property (nonatomic, assign)NSTimeInterval  connectTimeout;
/**
 消息发送的超时时间
 */
@property (nonatomic, assign)NSTimeInterval  timeout;


/**
 当前用户的id
 */
@property (nonatomic, copy, readonly ,nullable)NSString *currentUserId;

#pragma mark ---- 初始化相关 -----
+ (instancetype)sharedClient;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
设置IM服务走海外还是国内,在注册appid之前调用
*/
- (void)setServerType:(PhotonIMServerType)serverType;

#pragma mark ---- 注册IMClient -----
/**
 使用appid注册imclient,整个app声明周期内调用一次
 @param appid IMSDK 服务分配的唯一id
 */
- (void)registerIMClientWithAppid:(NSString *)appid;

/// 支持群组功能
- (void)supportGroup;
/**
 设置使用db的模式
 
 @param mode <#mode description#>
 */
- (void)setPhotonIMDBMode:(PhotonIMDBMode)mode;


/**
 绑定当前用户的userid,在登录后优先调用

 @param userid 当前登录的用户账号
 */
- (void)bindCurrentUserId:(NSString *)userid;


/**
 登录IM

 @param token 通过appid获取的服务端的token
 @param extra 登录携带的额外数据，一般不携带为nil
 */
- (void)loginWithToken:(NSString *)token extra:(nullable NSDictionary<NSString *, NSString *> *)extra;

/**
 退出IM，
 */
- (void)logout;


/**
 获取当前的连接状态
 */
- (PhotonIMLoginStatus)currentLoginStatus;


/**
 开启断言，接口调用不合理或者存在时会启用断言。建议在debugn模式下打开，release模式下关闭，默认是关闭状态

 @param enable <#enable description#>
 */
- (void)setAssertEnable:(BOOL)enable;


/**
 或是断言的开启状态

 @return <#return value description#>
 */
- (BOOL)assertEnable;


/**
 IM 连接登录相关操作

 @param block <#block description#>
 */
- (void)runInPhotonIMQueue:(dispatch_block_t)block;

/**
 db操作的队列
 业务端db读取等操作可放置在此队列处理，也可在自己的业务队列处理
 @param block <#block description#>
 */
- (void)runInPhotonIMDBQueue:(dispatch_block_t)block;


@end

NS_ASSUME_NONNULL_END
