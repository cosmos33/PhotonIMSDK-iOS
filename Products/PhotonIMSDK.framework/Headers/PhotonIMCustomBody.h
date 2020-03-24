//
//  PhotonIMCustomBody.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/3.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <PhotonIMSDK/PhotonIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotonIMCustomBody : PhotonIMBaseBody
/** 自定义int参数1，可作为消息类型或数据类型等用途 */
@property(nonatomic) int32_t arg1;

/** 自定义int参数2，可作为消息类型或数据类型等用途 */
@property(nonatomic) int32_t arg2;

/** 自定义二进制数据 */
@property(nonatomic, copy, nullable) NSData *data;

+ (PhotonIMCustomBody *)customBodyWithArg1:(int32_t)arg1
                              arg2:(int32_t)arg2
                          customData:(nullable NSData *)customData;
@end

NS_ASSUME_NONNULL_END
