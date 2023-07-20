//
//  PhotonIMMediaBody.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/19.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonIMBaseBody.h"
NS_ASSUME_NONNULL_BEGIN

@interface PhotonIMMediaBody : PhotonIMBaseBody
/**
 时长
 */
@property(nonatomic) int64_t mediaTime;

/**
 媒体资源释放播放
 */
@property(nonatomic) BOOL localMediaPlayed;

@end

NS_ASSUME_NONNULL_END
