//
//  PhotonIMCustomBody.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/3.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <PhotonIMSDK/PhotonIMSDK.h>

NS_ASSUME_NONNULL_BEGIN
/// 自定义消息的消息体，构建此消息体发送自定义消息，其对应的消息类型是PhotonIMMessageType::PhotonIMMessageTypeRaw
@interface PhotonIMCustomBody : PhotonIMBaseBody
/** 自定义int参数1，可作为消息类型或数据类型等用途 */
@property(nonatomic) int32_t arg1;

/** 自定义int参数2，可作为消息类型或数据类型等用途 */
@property(nonatomic) int32_t arg2;

/** 自定义二进制数据 */
@property(nonatomic, copy, nullable) NSData *data;

/// 遍历构造CustomBody
/// @param arg1 业务端自定义参数1
/// @param arg2 业务端自定义参数2
/// @param customData 自定义的二进制数据
+ (PhotonIMCustomBody *)customBodyWithArg1:(int32_t)arg1
                              arg2:(int32_t)arg2
                          customData:(nullable NSData *)customData;

/// 遍历构造CustomBody
/// @param arg1 业务端自定义参数1
/// @param arg2 业务端自定义参数2
/// @param customData 自定义的二进制数据
/// @param srcDescription  资源描述，此字段会入库，内容可作为全文搜索使用
+ (PhotonIMCustomBody *)customBodyWithArg1:(int32_t)arg1
                                      arg2:(int32_t)arg2
                                customData:(nullable NSData *)customData
                            srcDescription:(nullable NSString *)srcDescription;
@end

NS_ASSUME_NONNULL_END
