//
//  PhotonIMVideoBody.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/3.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <PhotonIMSDK/PhotonIMSDK.h>
#import "PhotonIMMediaBody.h"
NS_ASSUME_NONNULL_BEGIN

@interface PhotonIMVideoBody : PhotonIMMediaBody
@property(nonatomic, copy, nullable) NSString *coverUrl;
@property(nonatomic, assign)CGFloat  whRatio;

+ (PhotonIMVideoBody *)videoBodyWithURL:(NSString *)url
                              mediaTime:(int64_t)mediaTime
                               coverUrl:(nullable NSString *)coverUrl
                                whRatio:(CGFloat)whRatio
                          localFileName:(nullable NSString *)localFileName;
@end

NS_ASSUME_NONNULL_END
