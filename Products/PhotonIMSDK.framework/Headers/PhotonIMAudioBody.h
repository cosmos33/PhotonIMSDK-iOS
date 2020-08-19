//
//  PhotonIMAudioBody.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/6/28.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotonIMMediaBody.h"
NS_ASSUME_NONNULL_BEGIN

/// 音频消息的消息体，构建此消息体发送音频消息，其对应的消息类型是PhotonIMMessageType::PhotonIMMessageTypeAudio
@interface PhotonIMAudioBody : PhotonIMMediaBody

/// 构建PhotonIMAudioBody对象,此构造方法适用于业务端自己管理文件上传下载及相关的存储
/// @param url <#url description#>
/// @param mediaTime <#mediaTime description#>
/// @param localFileName <#localFileName description#>
+ (PhotonIMAudioBody *)audioBodyWithURL:(NSString *)url
                              mediaTime:(int64_t)mediaTime
                          localFileName:(nullable NSString *)localFileName;


/// <#Description#>
/// @param audioPath <#audioPath description#>
/// @param displayName <#displayName description#>
/// @param mediaTime <#mediaTime description#>
+ (PhotonIMAudioBody *)audioBodyWithAudioPath:(NSString *)audioPath
                                  displayName:(nullable NSString *)displayName
                                    mediaTime:(int64_t)mediaTime;
/// 便利构造AudioBody
/// @param url 服务端保存的资源地址
/// @param mediaTime 音频时长（单位可由业务端协商自行决定）
/// @param localFileName 资源本地存储的相对路径
/// @param srcDescription  资源描述，此字段会入库，内容可作为全文搜索使用
+ (PhotonIMAudioBody *)audioBodyWithURL:(NSString *)url
                              mediaTime:(int64_t)mediaTime
                          localFileName:(nullable NSString *)localFileName
                            srcDescription:(nullable NSString *)srcDescription;
@end

NS_ASSUME_NONNULL_END
