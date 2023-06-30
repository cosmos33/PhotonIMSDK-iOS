//
//  PhotonIMAssert.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/8/9.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface PhotonIMAssert : NSObject
+ (void)assertFail:(const char* )file line:(int)line func:(const char*)func expr:(const char *)expr fmt:(const char*)fmt,...;

@end

NS_ASSUME_NONNULL_END
