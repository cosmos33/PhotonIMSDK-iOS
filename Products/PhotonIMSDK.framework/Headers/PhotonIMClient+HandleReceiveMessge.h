/*!

 @header PhotonIMClient+HandleReceiveMessge.h

 @abstract PhotonIMSDK 负责消息的接受

 @author Created by Bruce on 2019/6/27.

 @version 2.1.1 2019/12/25 Creation

*/

#import <Foundation/Foundation.h>
#import "PhotonIMClient.h"
NS_ASSUME_NONNULL_BEGIN

/*!

@class PhotonIMClient (HandleReceiveMessge)
 
@abstract 负责消息的接受类别。

*/
@interface PhotonIMClient (HandleReceiveMessge)
#pragma mark ---- 监听下行消息 --------

/*!
 
@abstract 添加监听对象

@discussion observer可添加多个，内部是弱引用

@param observer 实现PhotonIMClientProtocol协议的类对象
 
*/
- (void)addObservers:(id<PhotonIMClientProtocol>)observer;

/*!
 
@abstract 移除指定的监听对象

@discussion observer移除后即不可监听相关回调

@param observer 实现PhotonIMClientProtocol协议的类对象
 
*/
- (void)removeObserver:(id<PhotonIMClientProtocol>)observer;


/*!
 
@abstract 移除所有的监听对象
*/
- (void)removeAllObservers;

@end

NS_ASSUME_NONNULL_END
