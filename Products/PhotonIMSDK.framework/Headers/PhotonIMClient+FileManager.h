//
//  PhotonIMClient+FileManager.h
//  PhotonIMSDK
//
//  Created by Bruce on 2020/1/21.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotonIMClient.h"
#import "PhotonIMDataTask.h"
#import "PhotonIMFileBody.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^PhotonFileDownloadProgress)(NSProgress * _Nonnull downloadProgress);
typedef void(^PhotonFileDownloadCompletion)(NSString * _Nullable filePath, NSError * _Nullable error);
@interface PhotonIMClient(FileManager)

//  文件上传
- (void)uploadFileWithMessagee:(PhotonIMMessage *)message
                    willUpload:(nullable void(^)(PhotonIMMessage * _Nonnull))willUpload
                      progress:(nullable void(^)(NSProgress * _Nonnull))progress
                    completion:(nullable void(^)(PhotonIMMessage * _Nonnull,PhotonIMError * _Nullable))completion;

/// 此方法仅下载消息中的源文件(比如图片原图，音频文件，视频源文件以及其他的文件),支持断点下载
- (id<PhotonIMDataTaskProtocol>)getLocalFileWithMessage:(PhotonIMMessage *)message
                                            fileQuality:(PhotonIMDownloadFileQuality)fileQuality
                                               progress:(nullable PhotonFileDownloadProgress)progress
                                             completion:(nullable PhotonFileDownloadCompletion)completion;

- (id<PhotonIMDataTaskProtocol>)getLocalFileWithMessage:(PhotonIMMessage *)message
                                            fileQuality:(PhotonIMDownloadFileQuality)fileQuality;


/// 判断消息所带的资源是否已下载存储到本地
/// @param message 消息对象
- (BOOL)fileExistsLocalWithMessage:(PhotonIMMessage *)message
                       fileQuality:(PhotonIMDownloadFileQuality)fileQuality;

- (void)removeFileWithMessage:(PhotonIMMessage *)message;

- (void)removeFileWithChatType:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith msgId:(NSString *)msgId;

- (void)removeFileWithChatType:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;

@end

NS_ASSUME_NONNULL_END
