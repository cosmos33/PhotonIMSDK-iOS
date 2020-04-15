//
//  PhotonDBFriendStore.h
//  PhotonIM
//
//  Created by Bruce on 2019/7/2.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonDBaseStore.h"

NS_ASSUME_NONNULL_BEGIN
@class PhotonUser;
@interface PhotonDBUserStore : PhotonDBaseStore
- (BOOL)addFriend:(nullable PhotonUser *)user forUid:(nullable NSString *)uid;

- (BOOL)updateFriendsData:(nullable NSArray *)friendData forUid:(nullable NSString *)uid;

- (NSMutableArray<PhotonUser *> *)getFriendsByUid:(nullable NSString *)uid;

- (PhotonUser *)getFriendsByUid:(nullable NSString *)uid friendID:(nullable NSString *)fid;

- (BOOL)deleteFriendByFid:(nullable NSString *)fid forUid:(nullable NSString *)uid;


#pragma mark --- user_groups -----

// 创建当前用户表
- (BOOL)createUserTable:(NSString *)tableName;

// 查找当前用户加入的群组
- (NSArray<NSString *> *)findAllGroupWithTableName:(NSString *)tableName;

// 当前用户加入群组
- (BOOL)addGroupWithGid:(nullable NSString *)gid tableName:(NSString *)tableName;
// 当前用户移除群组
- (BOOL)deleteGroupByGid:(nullable NSString *)gid tableName:(NSString *)tableName;

- (BOOL)deleteAllGroups:(NSString *)tableName;

#pragma mark --- group-users -----
// 创建群组表
- (BOOL)createGroupTable:(NSString *)tableName;
// 查找群组成员
- (NSArray< PhotonUser *> *)findAllUsersWithGroupTableName:(NSString *)tableName;

// 查找指定的群组成员
- (PhotonUser *)findUserWithGroupTableName:(NSString *)tableName uid:(NSString *)uid;

// 当前用户加入群组
- (BOOL)addUserToGroupWithUser:(nullable PhotonUser *)user tableName:(NSString *)tableName;
// 移除数组中的成员
- (BOOL)deleteUserFromGroupWithUid:(nullable NSString *)uid tableName:(NSString *)tableName;

- (BOOL)deleteAllUserFromGroupWithTableName:(NSString *)tableName;
@end

NS_ASSUME_NONNULL_END
