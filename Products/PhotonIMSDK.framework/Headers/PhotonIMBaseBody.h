//
//  PhotonIMBaseBody.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/6/29.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotonIMBaseBody : NSObject
/**
 服务端资源地址
 */
@property (nonatomic, copy, nullable)NSString *url;

/**
 本地资源名称或者路径
 */
@property (nonatomic, copy, nullable)NSString *localFileName;
@end

NS_ASSUME_NONNULL_END
