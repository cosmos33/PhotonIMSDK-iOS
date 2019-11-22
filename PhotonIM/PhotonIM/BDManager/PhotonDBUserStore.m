//
//  PhotonDBUserStore.m
//  PhotonIM
//
//  Created by Bruce on 2019/7/2.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonDBUserStore.h"
#import "PhotonMacros.h"
#import "PhotonUser.h"
#define     FRIENDS_TABLE_NAME              @"friends"

#define     SQL_CREATE_FRIENDS_TABLE        @"CREATE TABLE IF NOT EXISTS %@(\
uid TEXT,\
fid TEXT,\
username TEXT,\
nickname TEXT, \
avatar TEXT,\
remark TEXT,\
type INTEGER,\
ext1 TEXT,\
ext2 TEXT,\
ext3 TEXT,\
ext4 TEXT,\
ext5 TEXT,\
PRIMARY KEY(uid, fid))"
#define     SQL_UPDATE_FRIEND               @"REPLACE INTO %@ (uid, fid, username, nickname, avatar, remark, type, ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
#define     SQL_SELECT_FRIENDS              @"SELECT * FROM %@ WHERE uid = '%@'"
#define     SQL_SELECT_FRIEND              @"SELECT * FROM %@ WHERE uid = '%@' and fid = '%@'"
#define     SQL_DELETE_FRIEND               @"DELETE FROM %@ WHERE uid = '%@' and fid = '%@'"

// user-groups
#define     SQL_CREATE_UID_GROUPS_TABLE        @"CREATE TABLE IF NOT EXISTS %@(\
gid TEXT,\
ext1 TEXT,\
ext2 TEXT,\
ext3 TEXT,\
ext4 TEXT,\
ext5 TEXT,\
ext6 TEXT,\
ext7 TEXT,\
ext8 TEXT,\
ext9 TEXT,\
ext10 TEXT,\
PRIMARY KEY(gid))"

#define     SQL_UPDATE_UID_GROUPS               @"REPLACE INTO %@ (gid, ext1, ext2, ext3, ext4, ext5, ext6, ext7, ext8, ext9, ext10) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
#define     SQL_SELECT_GROUPS              @"SELECT * FROM %@"
#define     SQL_DELETE_GROUP               @"DELETE FROM %@ WHERE gid = '%@'"
#define     SQL_DELETE_ALLGROUPS               @" delete from   %@"

// group-users
#define     SQL_CREATE_GROUP_UIDS_TABLE        @"CREATE TABLE IF NOT EXISTS %@(\
uid TEXT,\
username TEXT,\
nickname TEXT,\
avatar TEXT,\
ext1 TEXT,\
ext2 TEXT,\
ext3 TEXT,\
ext4 TEXT,\
ext5 TEXT,\
ext6 TEXT,\
ext7 TEXT,\
PRIMARY KEY(uid))"

#define     SQL_UPDATE_GROUP_UIDS             @"REPLACE INTO %@ (uid, username,nickname,avatar,ext1, ext2, ext3, ext4, ext5, ext6, ext7) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
#define     SQL_SELECT_USERS            @"SELECT * FROM %@"
#define     SQL_SELECT_USER             @"SELECT * FROM %@ WHERE uid = '%@'"
#define     SQL_DELETE_USER          @"DELETE FROM %@ WHERE uid = '%@'"
#define     SQL_DELETE_ALLUSER          @"DELETE FROM %@"


@implementation PhotonDBUserStore
- (instancetype)init
{
    self = [super init];
    if (self) {
        BOOL ok = [self createTable];
        if (!ok) {
            PhotonLog(@"DB: 好友表创建失败");
        }
    }
    return self;
}

- (BOOL)createTable
{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_FRIENDS_TABLE, FRIENDS_TABLE_NAME];
    return [self createTable:FRIENDS_TABLE_NAME withSQL:sqlString];
}



#pragma mark ----- Profile -----
- (BOOL)addFriend:(nullable PhotonUser *)user forUid:(nullable NSString *)uid
{
    NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_FRIEND, FRIENDS_TABLE_NAME];
    NSArray *arrPara = [NSArray arrayWithObjects:
                        [PhotonUtil noNilString:uid],
                        [PhotonUtil noNilString:user.userID],
                        [PhotonUtil noNilString:user.userName],
                        [PhotonUtil noNilString:user.nickName],
                        [PhotonUtil noNilString:user.avatarURL],
                        [PhotonUtil noNilString:user.remark],
                        @(user.type),
                        @"", @"", @"", @"", @"", nil];
    BOOL ok = [self excuteSQL:sqlString withArrParameter:arrPara];
    return ok;
}

- (BOOL)updateFriendsData:(nullable NSArray *)friendData forUid:(nullable NSString *)uid
{
    NSArray *oldData = [self getFriendsByUid:uid];
    if (oldData.count > 0) {
        // 建立新数据的hash表，用于删除数据库中的过时数据
        NSMutableDictionary *newDataHash = [[NSMutableDictionary alloc] init];
        for (PhotonUser *user in friendData) {
            [newDataHash setValue:@"YES" forKey:user.userID];
        }
        for (PhotonUser *user in oldData) {
            if ([newDataHash objectForKey:user.userID] == nil) {
                BOOL ok = [self deleteFriendByFid:user.userID forUid:uid];
                if (!ok) {
                    PhotonLog(@"DBError: 删除过期好友失败");
                }
            }
        }
    }
    
    for (PhotonUser *user in friendData) {
        BOOL ok = [self addFriend:user forUid:uid];
        if (!ok) {
            return ok;
        }
    }
    
    return YES;
}

- (NSMutableArray *)getFriendsByUid:(nullable NSString *)uid
{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_FRIENDS, FRIENDS_TABLE_NAME, uid];
    PhotonWeakSelf(self)
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            PhotonUser *user = [weakself p_getUserByFMResultSet:retSet];
            [data addObject:user];
        }
        [retSet close];
    }];
    
    return data;
}

- (PhotonUser *)getFriendsByUid:(nullable NSString *)uid friendID:(nullable NSString *)fid{
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_FRIEND, FRIENDS_TABLE_NAME, uid,fid];
    PhotonWeakSelf(self)
    __block PhotonUser *user = nil;
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            user = [weakself p_getUserByFMResultSet:retSet];
        }
        [retSet close];
    }];
    
    return user;
}

- (BOOL)deleteFriendByFid:(nullable NSString *)fid forUid:(nullable NSString *)uid
{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_FRIEND, FRIENDS_TABLE_NAME, uid, fid];
    BOOL ok = [self excuteSQL:sqlString, nil];
    return ok;
}

#pragma mark --- user_groups -----

// 创建当前用户表
- (BOOL)createUserTable:(NSString *)tableName{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_UID_GROUPS_TABLE, tableName];
    return [self createTable:tableName withSQL:sqlString];
}

// 查找当前用户加入的群组
- (NSArray<NSString *> *)findAllGroupWithTableName:(NSString *)tableName{
    [self createUserTable:tableName];
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_GROUPS, tableName];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            NSString *gid =  [retSet stringForColumn:@"gid"];
            [data addObject:gid];
        }
        [retSet close];
    }];
    return data;
}

// 当前用户加入群组
- (BOOL)addGroupWithGid:(nullable NSString *)gid tableName:(NSString *)tableName
{
    [self createUserTable:tableName];
    NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_UID_GROUPS, tableName];
    NSArray *arrPara = [NSArray arrayWithObjects:
                        [PhotonUtil noNilString:gid],
                        @"", @"", @"", @"", @"",@"", @"", @"", @"", @"", nil];
    BOOL ok = [self excuteSQL:sqlString withArrParameter:arrPara];
    return ok;
}
// 当前用户移除群组
- (BOOL)deleteGroupByGid:(nullable NSString *)gid tableName:(NSString *)tableName{
    [self createUserTable:tableName];
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_GROUP, tableName, gid];
    BOOL ok = [self excuteSQL:sqlString, nil];
    return ok;
}


- (BOOL)deleteAllGroups:(NSString *)tableName{
    [self createUserTable:tableName];
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_ALLGROUPS, tableName];
    BOOL ok = [self excuteSQL:sqlString, nil];
    return ok;
}

#pragma mark --- group-users -----
// 创建群组表
- (BOOL)createGroupTable:(NSString *)tableName{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_GROUP_UIDS_TABLE, tableName];
    return [self createTable:tableName withSQL:sqlString];
}

// 查找群组成员
- (NSArray< PhotonUser *> *)findAllUsersWithGroupTableName:(NSString *)tableName{
    [self createGroupTable:tableName];
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_USERS, tableName];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            PhotonUser *user = [[PhotonUser alloc] init];
            // 用户id，fid如果是当前使用用户id，则表示自己，fid如果不是当前用户，则为好友id
            user.userID = [retSet stringForColumn:@"uid"];
            user.userName = [retSet stringForColumn:@"username"];
            user.nickName = [retSet stringForColumn:@"nickname"];
            user.avatarURL = [retSet stringForColumn:@"avatar"];
            [data addObject:user];
        }
        [retSet close];
    }];
    return data;
}

// 查找指定的群组成员
- (PhotonUser *)findUserWithGroupTableName:(NSString *)tableName uid:(NSString *)uid{
     [self createGroupTable:tableName];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_USER, tableName,uid];
    __block PhotonUser *user = [[PhotonUser alloc] init];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            // 用户id，fid如果是当前使用用户id，则表示自己，fid如果不是当前用户，则为好友id
            user.userID = [retSet stringForColumn:@"uid"];
            user.userName = [retSet stringForColumn:@"username"];
            user.nickName = [retSet stringForColumn:@"nickname"];
            user.avatarURL = [retSet stringForColumn:@"avatar"];
        }
        [retSet close];
    }];
    return user;
}

// 当前用户加入群组
- (BOOL)addUserToGroupWithUser:(nullable PhotonUser *)user tableName:(NSString *)tableName
{
     [self createGroupTable:tableName];
    NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_GROUP_UIDS, tableName];
    NSArray *arrPara = [NSArray arrayWithObjects:
                        [PhotonUtil noNilString:user.userID],
                        [PhotonUtil noNilString:user.userName],
                        [PhotonUtil noNilString:user.nickName],
                        [PhotonUtil noNilString:user.avatarURL],
                        @"", @"",@"", @"", @"", @"", @"", nil];
    BOOL ok = [self excuteSQL:sqlString withArrParameter:arrPara];
    return ok;
}
// 移除数组中的成员
- (BOOL)deleteUserFromGroupWithUid:(nullable NSString *)uid tableName:(NSString *)tableName{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_USER, tableName, uid];
    BOOL ok = [self excuteSQL:sqlString, nil];
    return ok;
}

// 移除群组中的所有成员
- (BOOL)deleteAllUserFromGroupWithTableName:(NSString *)tableName{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_ALLUSER, tableName];
    BOOL ok = [self excuteSQL:sqlString, nil];
    return ok;
}


#pragma mark - # Private Methods
- (PhotonUser *)p_getUserByFMResultSet:(nullable FMResultSet *)retSet
{
    PhotonUser *user = [[PhotonUser alloc] init];
    // 用户id，fid如果是当前使用用户id，则表示自己，fid如果不是当前用户，则为好友id
    user.userID = [retSet stringForColumn:@"fid"];
    user.userName = [retSet stringForColumn:@"username"];
    user.nickName = [retSet stringForColumn:@"nickname"];
    user.avatarURL = [retSet stringForColumn:@"avatar"];
    user.remark = [retSet stringForColumn:@"remark"];
    user.type = [[retSet stringForColumn:@"type"] intValue];
    return user;
}
@end
