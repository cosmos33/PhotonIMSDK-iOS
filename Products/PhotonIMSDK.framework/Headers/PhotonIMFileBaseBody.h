//
//  PhotonIMFileBaseBody.h
//  PhotonIMSDK
//
//  Created by Bruce on 2020/8/3.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotonIMBaseBody.h"
NS_ASSUME_NONNULL_BEGIN

@interface PhotonIMFileBaseBody : PhotonIMBaseBody
/**
 服务端资源地址
 */
@property (nonatomic, copy, nullable)NSString *url;

/**
 本地资源名称或者路径
 */
@property (nonatomic, copy, nullable)NSString *localFileName;

/**
 资源描述，此字段会入库，内容可作为全文搜索使用
 */
@property (nonatomic, copy, nullable)NSString *srcDescription;
@end

NS_ASSUME_NONNULL_END
