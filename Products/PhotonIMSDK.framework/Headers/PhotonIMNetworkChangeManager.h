//
//  PhotonIMNetworkChangeManager.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/5.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotonIMEnum.h"
NS_ASSUME_NONNULL_BEGIN
@interface PhotonIMNetworkChangeManager : NSObject
@property (nonatomic, assign, readonly) PhotonIMNetworkStatus networkStatus;
@property (nonatomic, assign, readonly) PhotonIMNetworkType networkType;
+ (void)startMonitoringWithChangeBlock:(nullable void(^)(PhotonIMNetworkStatus status))changeBlock;
+ (void)stopMonitoring;
+ (PhotonIMNetworkStatus)currentNetworkStatus;
+ (PhotonIMNetworkType)currentNetworkType;
+ (NSString *)currentNetworkName;
+ (BOOL)isNetworkValid;
@end

NS_ASSUME_NONNULL_END
