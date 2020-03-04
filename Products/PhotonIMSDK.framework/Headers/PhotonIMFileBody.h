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
typedef enum {
    HashAlgType_NONE = 0,
    HashAlgType_MD5 = 1,
    HashAlgType_SHA1 = 2,
    HashAlgType_SHA256 = 3,
}HashAlgType;
@interface PhotonIMFileBody : PhotonIMBaseBody
@property(nonatomic,assign)HashAlgType hashAlgType;//标注文件唯一性的算法 比如md5值
@property(nonatomic,copy,nullable)NSString *fileHash;// 比如md5值
@property(nonatomic,assign)int64_t fileSize;// 文件大小
+ (PhotonIMFileBody *)FileBodyWithFileName:(nullable NSString *)fileName
                                       url:(NSString *)url
                                  fileSize:(int64_t)fileSize
                               hashAlgType:(HashAlgType)hashAlgType
                                algContent:(nullable NSString *)algContent;

@end

NS_ASSUME_NONNULL_END
