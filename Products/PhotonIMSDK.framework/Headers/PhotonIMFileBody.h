//
//  PhotonIMFileBody.h
//  PhotonIMSDK
//
//  Created by Bruce on 2020/1/8.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotonIMBaseBody.h"
NS_ASSUME_NONNULL_BEGIN

/// 文件消息的消息体，构建此消息体发送文件消息，其对应的消息类型是PhotonIMMessageType::PhotonIMMessageTypeFile
@interface PhotonIMFileBody : PhotonIMBaseBody

/// 构建PhotonIMFileBody对象,此构造方法适用于业务端自己管理文件上传下载及相关的存储
/// @param fileName 文件名
/// @param url 文件存储在服务端的地址
/// @param fileSize 文件的大小
/// @param hashAlgType 文件使用的唯一性表示类型，比如HashAlgType_MD5，表示文件的MD5值
/// @param algContent 对应的唯一性标识内容，对应的获取到的文件的MD5值
+ (PhotonIMFileBody *)fileBodyWithFileName:(nullable NSString *)fileName
                                       url:(NSString *)url
                                  fileSize:(int64_t)fileSize
                               hashAlgType:(HashAlgType)hashAlgType
                                algContent:(nullable NSString *)algContent;



/// 构建PhotonIMFileBody对象,此构件方法适用于使用SDK的文件托管（sdk处理文件的上传下载和存储功能）
/// @param filePath 文件在业务端本地的路径
/// @param displayName 文件要显示的名称
+ (PhotonIMFileBody *)fileBodyWithFilePath:(nullable NSString *)filePath
                                       displayName:(NSString *)displayName;

@end

NS_ASSUME_NONNULL_END
