//
//  PhotonIMBaseBody.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/6/29.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    HashAlgType_NONE = 0,
    HashAlgType_MD5 = 1,
    HashAlgType_SHA1 = 2,
    HashAlgType_SHA256 = 3,
}HashAlgType;
NS_ASSUME_NONNULL_BEGIN

@interface PhotonIMBaseBody : NSObject
/**
 服务端资源地址
 */
@property (nonatomic, copy, nullable)NSString *url;

/**
 本地存储的实际资源名称即相对路径，通过此名称获取本地资源的存储路径
 */
@property (nonatomic, copy, nullable)NSString *localFileName;

/**
 本地资源的绝对路径，上行地址为业务端的资源地址，下行为SDK完成资源上传后存储在SDK管理的路径下
 */
@property (nonatomic, copy, nullable)NSString *localFilePath;

/**
资源内容，二进制格式,此时localFileName为此资源的名称，比如123.jpg 123.mp4等
*/
@property (nonatomic, strong, nullable) NSData *fileData;

/**
 本地资源展示的名称
 */
@property (nonatomic, copy, nullable)NSString *fileDisplayName;

/**
文件大小
*/
@property(nonatomic,assign)int64_t fileSize;


@property(nonatomic,assign)HashAlgType hashAlgType;//标注文件唯一性的算法 比如md5值

@property(nonatomic,copy,nullable)NSString *fileHash;// 比如md5值
@end

NS_ASSUME_NONNULL_END
