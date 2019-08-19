//
//  PhotonContent.h
//  PhotonIM
//
//  Created by Bruce on 2019/6/25.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotonAppDelegate.h"
#import "PhotonUser.h"
NS_ASSUME_NONNULL_BEGIN
#define APP_ID @"280f8ef2cec41cde3bed705236ab9bc4"
@interface PhotonContent : NSObject
+ (instancetype)sharedInstance;
+ (PhotonAppDelegate *)sharedAppDelegate;
+ (PhotonUser *)currentUser;
+ (void)persistenceCurrentUser;

+ (PhotonUser *)userDetailInfo;

+ (PhotonUser *)friendDetailInfo:(NSString *)fid;
+ (void)addFriendToDB:(PhotonUser *)user;
+ (void)logout;
+ (void)login;
@end

NS_ASSUME_NONNULL_END
