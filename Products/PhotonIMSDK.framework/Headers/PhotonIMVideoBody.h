//
//  PhotonIMVideoBody.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/3.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <PhotonIMSDK/PhotonIMSDK.h>
#import <UIKit/UIKit.h>
#import "PhotonIMMediaBody.h"
NS_ASSUME_NONNULL_BEGIN

@interface PhotonIMVideoBody : PhotonIMMediaBody
@property(nonatomic, copy, nullable) NSString *coverUrl;
@property(nonatomic, strong, nullable)UIImage *coverImage;
@property(nonatomic, assign)CGFloat  whRatio;


/// 构建PhotonIMFileBody对象,此构造方法适用于业务端自己管理文件上传下载及相关的存储
/// @param url 视频资源在服务端的地址
/// @param mediaTime 视频资源时长
/// @param coverUrl 视频资源封面图地址
/// @param whRatio 封面图宽高比
/// @param localFileName 视频资源本地的相对地址
+ (PhotonIMVideoBody *)videoBodyWithURL:(NSString *)url
                              mediaTime:(int64_t)mediaTime
                               coverUrl:(nullable NSString *)coverUrl
                                whRatio:(CGFloat)whRatio
                          localFileName:(nullable NSString *)localFileName;


/// 构建PhotonIMFileBody对象,此构件方法适用于使用SDK的文件托管（sdk处理文件的上传下载和存储功能）
/// @param filePath 视频资源本地的
/// @param fileName <#fileName description#>
/// @param mediaTime <#mediaTime description#>
+ (PhotonIMVideoBody *)videoBodyWithFilePath:(NSString *)filePath
                                    fileName:(NSString *)fileName
                              mediaTime:(int64_t)mediaTime;
@end

NS_ASSUME_NONNULL_END
