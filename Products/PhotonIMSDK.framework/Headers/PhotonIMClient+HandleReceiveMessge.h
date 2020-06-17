//
//  PhotonIMClient+HandleReceiveMessge.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/3.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotonIMClient.h"
NS_ASSUME_NONNULL_BEGIN

/// [HandleReceiveMessge](https://cosmos.immomo.com/cosmos_sdk_apidoc/imios/html/Classes/PhotonIMClient.html#//api/name/addObservers:) 处理消息的接收;
@interface PhotonIMClient (HandleReceiveMessge)
#pragma mark ---- 监听下行消息 --------

/**
 添加监听对象
 
 @param observer 实现[PhotonIMClientProtocol](https://cosmos.immomo.com/cosmos_sdk_apidoc/imios/html/Protocols/PhotonIMClientProtocol.html) 协议的观察对象
 */
- (void)addObservers:(id<PhotonIMClientProtocol>)observer;

/**
 移除指定的监听对象
 
 @param observer 实现[PhotonIMClientProtocol](https://cosmos.immomo.com/cosmos_sdk_apidoc/imios/html/Protocols/PhotonIMClientProtocol.html) 协议的观察对象
 */
- (void)removeObserver:(id<PhotonIMClientProtocol>)observer;

/**
 移除所有的监听对象
 */
- (void)removeAllObservers;

@end

NS_ASSUME_NONNULL_END
