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
/// 业务端app的版本号
- (NSString *)customAppVersion;


///HTTPDNS相关
/// 提供给业务方自己配置连接im的ap对应的HTTPDNSIP
///eq:
///- (NSString *)ipForAPFromHTTPDNS:(NSString *)domain {
///  return [PhotonHTTPDNSClient getIPbyHost:domain];
///}
- (NSString *)ipForAPFromHTTPDNS:(NSString *)domain;
///用于AP成功提供给HTTPDNS的回调
///eq:
///- (void)apConnectSuccess:(NSString *)domain succeedDomain:(NSString *)succeedDomain port:(NSInteger)port;
///  [PhotonHTTPDNSClient requestSucceedForDomain:domain andSucceedDomain:succeedDomain andSuccessedPort:port];
///}

- (void)apConnectNetworkSuccess:(NSString *)domain succeedDomain:(NSString *)succeedDomain port:(NSInteger)port;
///用于AP失败提供给HTTPDNS的回调
///eq:
///- (void)apConnectTimeoutFail:(NSString *)domain failedDomain:(NSString *)failedDomain port:(NSInteger)port;
///  [PhotonHTTPDNSClient requestFailedForDomain:domain andFailedDomain:failDomain andFailedPort:port];
///}
- (void)apConnectNetworkFail:(NSString *)domain failedDomain:(NSString *)failedDomain port:(NSInteger)port;


@end

#endif /* PhotonIMClientConfigProtocol_h */
