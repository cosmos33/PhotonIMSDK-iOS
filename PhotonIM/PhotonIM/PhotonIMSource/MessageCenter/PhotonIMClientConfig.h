//
//  PhotonIMClientConfig.h
//  PhotonIM
//
//  Created by Bruce on 2020/5/9.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PhotonIMSDK/PhotonIMSDK.h>
#import <UserNotifications/UserNotifications.h>
NS_ASSUME_NONNULL_BEGIN

@interface PhotonIMClientConfig : NSObject<PhotonIMClientConfigProtocol,UNUserNotificationCenterDelegate,UIApplicationDelegate>

@end

NS_ASSUME_NONNULL_END
