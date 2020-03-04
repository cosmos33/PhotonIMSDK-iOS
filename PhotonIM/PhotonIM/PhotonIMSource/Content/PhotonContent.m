//
//  PhotonContent.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/25.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonContent.h"
#import <pushsdk/MoPushManager.h>
#import "PhotonDBUserStore.h"
#import "PhotonMessageCenter.h"
#import "PhotonAppLaunchManager.h"
@interface PhotonContent()
@property(nonatomic, strong, nullable)PhotonUser *currentUser;
@property(nonatomic, strong, nullable)PhotonLoadDataSetModel *setModel;
@end
@implementation PhotonContent
+ (instancetype)sharedInstance{
    static PhotonContent *content = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        content = [[PhotonContent alloc] init];
    });
    return content;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _setModel = [[PhotonLoadDataSetModel alloc] init];
        _currentUser = [[PhotonUser alloc] init];
       id user = [[NSUserDefaults standardUserDefaults] objectForKey:@"photon_current_user"];
        if ([user isKindOfClass:[NSDictionary class]]) {
            NSDictionary *userDict = user;
            _currentUser.userID = [userDict objectForKey:@"photon_user_id"];
            _currentUser.userName = [userDict objectForKey:@"photon_user_name"];
            _currentUser.sessionID = [userDict objectForKey:@"photon_user_sessionid"];
        }
    }
    return self;
}
+ (PhotonAppDelegate *)sharedAppDelegate
{
    __block PhotonAppDelegate *appDelegate = nil;
    
    if ([NSThread isMainThread]) {
        appDelegate = (PhotonAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            appDelegate = (PhotonAppDelegate *)[[UIApplication sharedApplication] delegate];
        });
    }
    
    return appDelegate;
}
+ (PhotonUser *)currentUser{
    return [PhotonContent sharedInstance].currentUser;
}

+ (PhotonLoadDataSetModel *)currentSettingModel{
    return [PhotonContent sharedInstance].setModel;
}

+ (void)persistenceCurrentUser{
    NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
    PhotonUser *user = [self currentUser];
    if ([user.userID isNotEmpty]) {
        [userDict setValue:user.userID forKey:@"photon_user_id"];
    }
    if ([user.userName isNotEmpty]) {
        [userDict setValue:user.userName forKey:@"photon_user_name"];
    }
    if ([user.sessionID isNotEmpty]) {
        [userDict setValue:user.sessionID forKey:@"photon_user_sessionid"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:userDict forKey:@"photon_current_user"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)clearCurrentUser{
    [PhotonContent sharedInstance].currentUser = [[PhotonUser alloc] init];
    [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"photon_current_user"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (PhotonUser *)userDetailInfo{
    PhotonDBUserStore *userDB = [[PhotonDBUserStore alloc] init];
    PhotonUser *user = [userDB getFriendsByUid:[PhotonContent currentUser].userID friendID:[PhotonContent currentUser].userID];
    return user;
}

+ (PhotonUser *)friendDetailInfo:(NSString *)fid{
    PhotonDBUserStore *userDB = [[PhotonDBUserStore alloc] init];
    PhotonUser *user = [userDB getFriendsByUid:[PhotonContent currentUser].userID friendID:fid];
    return user;
}
+ (void)addFriendToDB:(PhotonUser *)user{
     PhotonDBUserStore *userDB = [[PhotonDBUserStore alloc] init];
    [userDB addFriend:user forUid:[PhotonContent currentUser].userID];
}

// 查找当前用户的所有所在群组
+ (NSArray<NSString *> *)findAllGroups{
    PhotonDBUserStore *userDB = [[PhotonDBUserStore alloc] init];
    NSString *tableName = [NSString stringWithFormat:@"user_group_%@",[PhotonContent currentUser].userID];
    return [userDB findAllGroupWithTableName:tableName];
}
// 当前用户移除群组
+ (BOOL)deleteGroupByGid:(nullable NSString *)gid{
    PhotonDBUserStore *userDB = [[PhotonDBUserStore alloc] init];
    NSString *tableName = [NSString stringWithFormat:@"user_group_%@",[PhotonContent currentUser].userID];
    return [userDB deleteGroupByGid:gid tableName:tableName];
}
// 当前用户加入群组
+ (BOOL)addGroupToCurrentUserByGid:(nullable NSString *)gid{
    PhotonDBUserStore *userDB = [[PhotonDBUserStore alloc] init];
    NSString *tableName = [NSString stringWithFormat:@"user_group_%@",[PhotonContent currentUser].userID];
    return [userDB addGroupWithGid:gid tableName:tableName];
}

+ (BOOL)deleteAllGroups{
    PhotonDBUserStore *userDB = [[PhotonDBUserStore alloc] init];
    NSString *tableName = [NSString stringWithFormat:@"user_group_%@",[PhotonContent currentUser].userID];
    return [userDB deleteAllGroups:tableName];
}

+ (NSArray<PhotonUser *> *)findAllUsersWithGroupId:(NSString *)gid{
    PhotonDBUserStore *userDB = [[PhotonDBUserStore alloc] init];
    NSString *tableName = [NSString stringWithFormat:@"group_user_%@",gid];
    return [userDB findAllUsersWithGroupTableName:tableName];
}
+ (PhotonUser *)findUserWithGroupId:(NSString *)gid uid:(NSString *)uid;{
    PhotonDBUserStore *userDB = [[PhotonDBUserStore alloc] init];
    NSString *tableName = [NSString stringWithFormat:@"group_user_%@",gid];
    return [userDB findUserWithGroupTableName:tableName uid:uid];
}
+ (BOOL)addUserToGroupWithUser:(nullable PhotonUser *)user gid:(NSString *)gid{
    PhotonDBUserStore *userDB = [[PhotonDBUserStore alloc] init];
    NSString *tableName = [NSString stringWithFormat:@"group_user_%@",gid];
    return [userDB addUserToGroupWithUser:user tableName:tableName];
}
+ (BOOL)deleteUserFromGroupWithUid:(nullable NSString *)uid gid:(NSString *)gid{
    PhotonDBUserStore *userDB = [[PhotonDBUserStore alloc] init];
    NSString *tableName = [NSString stringWithFormat:@"group_user_%@",gid];
     return [userDB deleteUserFromGroupWithUid:uid tableName:tableName];
}

+ (BOOL)deleteaAllUserFromGroupWithGid:(NSString *)gid{
    PhotonDBUserStore *userDB = [[PhotonDBUserStore alloc] init];
    NSString *tableName = [NSString stringWithFormat:@"group_user_%@",gid];
    return [userDB deleteAllUserFromGroupWithTableName:tableName];
}




+ (void)logout{
    [PhotonUtil runMainThread:^{
        [PhotonDBManager closeDB];
        [MoPushManager unAlias:[PhotonContent currentUser].userID];
        [self clearCurrentUser];
        [PhotonAppLaunchManager launchInWindow];
    }];
   
}

+ (void)login{
   
    [PhotonUtil runMainThread:^{
         [PhotonDBManager openDB];
        [MoPushManager registerWithAlias:[PhotonContent currentUser].userID];
        [[PhotonContent currentUser] loadFriendProfile];
    }];
}
@end
