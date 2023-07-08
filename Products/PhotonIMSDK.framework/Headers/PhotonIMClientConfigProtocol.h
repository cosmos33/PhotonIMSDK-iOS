//
//  PhotonIMClientConfigProtocol.h
//  PhotonIMSDK
//
//  Created by Bruce on 2020/5/9.
//  Copyright © 2020 Bruce. All rights reserved.
//

#ifndef PhotonIMClientConfigProtocol_h
#define PhotonIMClientConfigProtocol_h

@protocol PhotonIMClientConfigProtocol <NSObject>

@optional

/// 提供给业务方自己配置连接im的host
- (NSString *)customConnectionHost;

/// 业务端app的版本号
- (NSString *)customAppVersion;

/// 如果要实现httpdns需要实现此方法
- (NSString *)ipFromHttpdns:(NSString *)domain;

@end

#endif /* PhotonIMClientConfigProtocol_h */
