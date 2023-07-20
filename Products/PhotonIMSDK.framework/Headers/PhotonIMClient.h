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
#import "PhotonIMClientConfigProtocol.h"
#import "PhotonIMMessage.h"
#import "PhotonIMConversation.h"
#import "PhotonIMError.h"

NS_ASSUME_NONNULL_BEGIN

/// 管理所有IMSDK相关操作;
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

/**
 @brief获取Client.
 */
+ (instancetype)sharedClient;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 @brief 设置IM服务走海外还是国内,国内(PhotonIMServerTypeInland) 海外(PhotonIMServerTypeOverseas),在注册appid之前调用
 
 @param serverType 选择的服务类型
 */
- (void)setServerType:(PhotonIMServerType)serverType;

- (void)setIMClientConfig:(id<PhotonIMClientConfigProtocol>)imClientConfig;

#pragma mark ---- 注册IMClient -----

/**
 使用在d服务端注册的appid完成IMSDK的注册,整个app声明周期内调用一次
 
 @param appid IMSDK 服务分配的唯一id
 */
- (void)registerIMClientWithAppid:(NSString *)appid;

/**
 支持群组功能，SDK默认不支持群聊功能，开启支持需在紧跟初始化时调用此方法
 */
- (void)supportGroup;

/**
 设置使用内嵌的模式，支持三种数据库的模式，详情请见
 [PhotonIMDBMode](https://cosmos.immomo.com/cosmos_sdk_apidoc/imios/html/Constants/PhotonIMDBMode.html)
 @param mode 数据库模式
 */
- (void)setPhotonIMDBMode:(PhotonIMDBMode)mode;


/**
 将登录IM的账号和IM进行绑定,在获取账号后调用，一般是业务端登录后调用
 
 @param userid 当前登录IM的账号
 */
- (void)bindCurrentUserId:(NSString *)userid;


/**
 使用在服务端注册获取的登录token登录IM
 
 @param token 使用登录账号在服务端获取的登录token
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
- (PhotonIMLoginStatus)getCurrentLoginStatus;


/**
 开启断言，接口调用不合理或者存在时会启用断言。建议在debugn模式下打开，release模式下关闭，默认是关闭状态
 
 @param enable <#enable description#>
 */
- (void)setAssertEnable:(BOOL)enable;


/**
 判断断言是否处于开启状态
 
 @return YES为开启,NO为关闭
 */
- (BOOL)assertEnable;


/**
 IM 连接登录相关操作
 
 @param block 执行的f方法函数
 */
- (void)runInPhotonIMQueue:(dispatch_block_t)block;

/**
 db操作的队列
 业务端db读取等操作可放置在此队列处理，也可在自己的业务队列处理
 @param block 执行的f方法函数
 */
- (void)runInPhotonIMDBQueue:(dispatch_block_t)block;

/**
 此方法可以设置是否使im在后台一直处于连接中，一定要谨慎使用。
 在确保app进到后台一直保活的前提下设置keep为YES。处于非保活下设置keep为NO
 使用场景一般是后台播放音频，后台定位等场景。进到此场景调用设置keep为YES，退回此场景设置Keep为NO.
 
 @param keep 默认是NO,因切后台在不开启后台运行模式的情况下app休眠的问题，im默认进到后台会断开处理。
 */
- (void)keepConnectedOnBackground:(BOOL)keep;

/// 自定义cosmos-im-ap-hw.immomo.com域名
/**
 自定义
 @param url cosmos-im-ap-hw.immomo.com
 @param api cosmos-im-api-hw.immomo.com
 */
- (void)customHWAp:(NSString *)url api:(NSString *)api;
- (void)customHWIPs:(NSArray *)ips;

@end

NS_ASSUME_NONNULL_END
