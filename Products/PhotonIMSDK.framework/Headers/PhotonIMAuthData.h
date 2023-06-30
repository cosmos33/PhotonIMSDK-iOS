//
//  PhotonIMConnectData.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/9.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotonIMAuthData : NSObject
/**
 PhotonIMSDK平台分配的appid
 */
@property(nonatomic, copy, nullable) NSString *appId;


/**
 通过appid获取服务端校验的token
 */
@property(nonatomic, copy, nullable) NSString *token;


/**
 用户id
 */
@property(nonatomic, copy, nullable) NSString *userId;


/**
 设备id
 */
@property(nonatomic, copy, nullable) NSString *deviceId;


/**
 客户端类型
 */
@property(nonatomic, copy, nullable) NSString *clientType;


/**
 SDK 版本号
 */
@property(nonatomic, readwrite) int32_t version;

/**
业务端版本号
 */
@property(nonatomic, readwrite) NSString * appBuildVersion;
/**
 额外的信息
 */
@property(nonatomic, strong, nullable) NSMutableDictionary<NSString*, NSString*> *extra;
/** The number of items in @c extra without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger extra_Count;

@property(nonatomic, copy, nullable)NSString  *connectReason;
@end

NS_ASSUME_NONNULL_END
