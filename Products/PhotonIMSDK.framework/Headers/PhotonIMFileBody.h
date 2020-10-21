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

/**
唯一标识算法类型

- HashAlgType_NONE: mone
- HashAlgType_MD5: MD5
- HashAlgType_SHA1: SHA1
- HashAlgType_SHA256:SHA256
*/
typedef NS_ENUM(NSInteger,HashAlgType) {
    HashAlgType_NONE = 0,
    HashAlgType_MD5 = 1,
    HashAlgType_SHA1 = 2,
    HashAlgType_SHA256 = 3,
};

/// 文件消息的消息体，构建此消息体发送文件消息，其对应的消息类型是PhotonIMMessageType::PhotonIMMessageTypeFile
@interface PhotonIMFileBody : PhotonIMBaseBody

@property(nonatomic,assign)HashAlgType hashAlgType;//标注文件唯一性的算法 比如md5值
@property(nonatomic,copy,nullable)NSString *fileHash;// 比如md5值
@property(nonatomic,assign)int64_t fileSize;// 文件大小

/// 遍历构建文件消息t提
/// @param fileName 文件名
/// @param url 文件在服务端的存储地址
/// @param fileSize 文件大小
/// @param hashAlgType 文件唯一表示算法
/// @param algContent 处理后的唯一标识
+ (PhotonIMFileBody *)FileBodyWithFileName:(nullable NSString *)fileName
                                       url:(NSString *)url
                                  fileSize:(int64_t)fileSize
                               hashAlgType:(HashAlgType)hashAlgType
                                algContent:(nullable NSString *)algContent;

/// 遍历构建文件消息t提
/// @param fileName 文件名
/// @param url 文件在服务端的存储地址
/// @param fileSize 文件大小
/// @param hashAlgType 文件唯一表示算法
/// @param algContent 处理后的唯一标识
/// @param srcDescription  资源描述，此字段会入库，内容可作为全文搜索使用
+ (PhotonIMFileBody *)FileBodyWithFileName:(nullable NSString *)fileName
                                       url:(NSString *)url
                                  fileSize:(int64_t)fileSize
                               hashAlgType:(HashAlgType)hashAlgType
                                algContent:(nullable NSString *)algContent
                               srcDescription:(nullable NSString *)srcDescription;
@end

NS_ASSUME_NONNULL_END
