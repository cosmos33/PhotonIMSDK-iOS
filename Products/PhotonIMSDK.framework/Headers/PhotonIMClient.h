/*!

  @header PhotonIMClient.h

  @abstract PhotonIMSDK 句柄

  @author Created by Bruce on 2019/6/27.

  @version 2.1.1 2019/12/25 Creation

 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PhotonIMClientProtocol.h"
#import "PhotonIMMessage.h"
#import "PhotonIMConversation.h"
#import "PhotonIMError.h"
NS_ASSUME_NONNULL_BEGIN
/*!

@class PhotonIMClient

@abstract PhotonIMSDK面向接入端的管理类。

*/
@interface PhotonIMClient : NSObject

/*!

@property queue

@abstract  IM 处理线程，消息发送处理等

*/
@property (nonatomic, strong,readonly, nullable)dispatch_queue_t queue;

/*!

@property connectTimeout

@abstract  socket连接服务的超时时间

*/
@property (nonatomic, assign)NSTimeInterval  connectTimeout;

/*!

@property timeout

@abstract  消息发送的超时时间

*/
@property (nonatomic, assign)NSTimeInterval  timeout;


/*!

@property currentUserId

@abstract  当前用户的id

*/
@property (nonatomic, copy, readonly ,nullable)NSString *currentUserId;

#pragma mark ---- 初始化相关 -----
+ (instancetype)sharedClient;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


#pragma mark ---- 注册IMClient -----
/*!
 @abstract 使用在开放平台注册获取到的id注册imclient
 
 @discussion 整个app声明周期内调用一次
 
 @param appid IMSDK 服务分配的唯一id
 */
- (void)registerIMClientWithAppid:(NSString *)appid;

/*!
@abstract 支持群组功能
 
@discussion 不调用此方法默认不支持群组功能，如果需要支持群组功能，请紧跟在- (void)registerIMClientWithAppid:(NSString *)appid方法后调用
*/
- (void)supportGroup;

/*!
 @abstract 设置使用db的模式
 
 @discussion 数据库模式分为三种，不使用内嵌数据库，同步使用内嵌数据库（数据存储，消息收发同步执行）和异步使用内嵌数据库数据存储，消息收发异步执行）。
 
 @param mode 数据库使用模式,默认为PhotonIMDBModeNoDB不使用s内嵌数据库。推荐异步使用内嵌数据库
 */
- (void)setPhotonIMDBMode:(PhotonIMDBMode)mode;


/*!
 
 @abstract 绑定当前用户的userid
 
 @discussion 在业务端获取到userid时调用，此方法一般在im登录前完成调用

 @param userid 当前登录的用户账号
 */
- (void)bindCurrentUserId:(NSString *)userid;


/*!
 @abstract 登录IM
 
 @discussion 此方法需要token作为参数，token由业务端通过服务获取得到，此token使用中可持久化，业务端收到im针对token失效的回调时可重新获取
 
 @param token 通过appid获取的服务端的token
 
 @param extra 登录携带的额外数据，一般不携带为nil
 */
- (void)loginWithToken:(NSString *)token extra:(nullable NSDictionary<NSString *, NSString *> *)extra;

/*!
 @abstract 退出IM
 
 @discussion 用户在切换账号等退出操作是调用
 
 */
- (void)logout;


/*!
 
  @abstract 获取当前的连接状态
 
  @discussion 用户在切换账号等退出操作是调用
 
  @return 返回的连接状态
 */
- (PhotonIMLoginStatus)currentLoginStatus;

/*!
 
 @abstract 设置是否开启断言
 
 @discussion 开启断言，接口调用不合理或者存在时会启用断言。建议在debugn模式下打开，release模式下关闭，默认是关闭状态

 @param enable YES是开启 NO是关闭 默认是NO
 */
- (void)setAssertEnable:(BOOL)enable;


/**
 或是断言的开启状态

 @return <#return value description#>
 */
- (BOOL)assertEnable;


/*!
 
 @abstract IM连接登录操作的执行队列
 
 @discussion 事件操作运行在IM连接登录操作的执行队列
 
 @param block 事件函数
 
 */
- (void)runInPhotonIMQueue:(dispatch_block_t)block;

/*!
 
 @abstract db操作的队列
 
 @discussion 业务端db读取等操作可放置在此队列处理，也可在自己的业务队列处理
 
 @param block 事件函数
 
 */
- (void)runInPhotonIMDBQueue:(dispatch_block_t)block;
@end

NS_ASSUME_NONNULL_END
