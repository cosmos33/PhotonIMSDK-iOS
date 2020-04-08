//
//  PhotonChatVideoMessageItem.h
//  PhotonIM
//
//  Created by Bruce on 2020/1/15.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonChatBaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotonChatVideoMessageItem : PhotonChatBaseItem
/**
 语音文件名
 */
@property(nonatomic, copy, nullable)NSString *fileName;

/**
 视频文件存储url
 */
@property(nonatomic, strong, nullable)NSURL *url;
/**
 视频时长文件时长
 */
@property(nonatomic, assign)int64_t duration;
/**
 
 语音文件本地存储路径
 */
@property(nonatomic, copy, nullable)NSString *fileLocalPath;

@property (nonatomic, strong, nullable)NSString *coverURL;

@property (nonatomic, strong, nullable)UIImage *coverImage;
@property (nonatomic, assign)CGFloat whRatio;
@end

NS_ASSUME_NONNULL_END
