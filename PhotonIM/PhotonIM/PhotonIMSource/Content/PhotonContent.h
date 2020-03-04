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
#import "PhotonLoadDataSetModel.h"
NS_ASSUME_NONNULL_BEGIN
#define APP_ID @"326a7a61d5e8f170957f9bf6591a7c9b"
@interface PhotonContent : NSObject
+ (instancetype)sharedInstance;
+ (PhotonAppDelegate *)sharedAppDelegate;
+ (PhotonUser *)currentUser;
+ (PhotonLoadDataSetModel *)currentSettingModel;
+ (void)persistenceCurrentUser;

+ (PhotonUser *)userDetailInfo;

+ (PhotonUser *)friendDetailInfo:(NSString *)fid;
+ (void)addFriendToDB:(PhotonUser *)user;

// 查找当前用户加入的群组
+ (NSArray<NSString *> *)findAllGroups;

// 当前用户加入群组
+ (BOOL)addGroupToCurrentUserByGid:(nullable NSString *)gid;
// 当前用户移除群组
+ (BOOL)deleteGroupByGid:(nullable NSString *)gid;

+ (BOOL)deleteAllGroups;

+ (NSArray< PhotonUser *> *)findAllUsersWithGroupId:(NSString *)gid;
+ (PhotonUser *)findUserWithGroupId:(NSString *)gid uid:(NSString *)uid;
+ (BOOL)addUserToGroupWithUser:(nullable PhotonUser *)user gid:(NSString *)gid;
+ (BOOL)deleteUserFromGroupWithUid:(nullable NSString *)uid gid:(NSString *)gid;


+ (BOOL)deleteaAllUserFromGroupWithGid:(NSString *)gid;

+ (void)logout;
+ (void)login;



@end

NS_ASSUME_NONNULL_END
