//
//  PhotonUser.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/25.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonUser.h"
#import "PhotonMessageCenter.h"
#import "PhotonNetworkService.h"
@interface PhotonUser()
@property (nonatomic, strong, nullable)PhotonNetworkService *netService;
@end

@implementation PhotonUser
- (void)loadFriendProfile{
    __weak typeof(self)weakSelf = self;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [self.netService commonRequestMethod:PhotonRequestMethodPost queryString:@"photonimdemo/user/my/profile" paramter:dict completion:^(NSDictionary * _Nonnull responseDict) {
        [weakSelf wrappFriendProfileDict:responseDict];
    } failure:^(PhotonErrorDescription * _Nonnull error) {
    }];
}
- (void)loadFriendProfileBatch:(NSArray *)remoteids completion:(void(^)(BOOL success))completion{
    if (remoteids.count == 0) {
        if (completion) {
            completion(YES);
        }
    }
    NSString *ids = [remoteids componentsJoinedByString:@","];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:ids forKey:@"remoteids"];
    PhotonWeakSelf(self)
    [self.netService commonRequestMethod:PhotonRequestMethodPost queryString:@"photonimdemo/user/remote/profiles" paramter:dict completion:^(NSDictionary * _Nonnull responseDict) {
        [weakself wrappFriendProfileBatchDict:responseDict];
        if (completion) {
            completion(YES);
        }
    } failure:^(PhotonErrorDescription * _Nonnull error) {
        if (completion) {
            completion(NO);
        }
    }];
}
- (void)wrappFriendProfileBatchDict:(NSDictionary *)responseDict {
    NSDictionary *data = [responseDict objectForKey:@"data"];
    if (data.count > 0) {
        NSArray *lists = [data objectForKey:@"lists"];
        for (NSDictionary *profile in lists) {
            if (profile.count > 0) {
                PhotonUser *user = [[PhotonUser alloc] init];
                user.userID = [[profile objectForKey:@"userId"] isNil];
                user.nickName = [[profile objectForKey:@"nickname"] isNil];
                user.avatarURL = [[profile objectForKey:@"avatar"] isNil];
                [PhotonContent addFriendToDB:user];
            }
        }
       
    }
}

- (void)loadFriendProfile:(NSString *)remoteid completion:(void(^)(BOOL success))completion{
    __weak typeof(self)weakSelf = self;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:remoteid forKey:@"remoteid"];
    [self.netService commonRequestMethod:PhotonRequestMethodPost queryString:@"photonimdemo/user/remote/profile" paramter:dict completion:^(NSDictionary * _Nonnull responseDict) {
        [weakSelf wrappFriendProfileDict:responseDict];
        if (completion) {
            completion(YES);
        }
        
    } failure:^(PhotonErrorDescription * _Nonnull error) {
        if (completion) {
            completion(NO);
        }
    }];
}

- (void)wrappFriendProfileDict:(NSDictionary *)responseDict {
    NSDictionary *data = [responseDict objectForKey:@"data"];
    if (data.count > 0) {
        NSDictionary *profile = [data objectForKey:@"profile"];
        if (profile.count > 0) {
            PhotonUser *user = [[PhotonUser alloc] init];
            user.userID = [[profile objectForKey:@"userId"] isNil];
            user.nickName = [[profile objectForKey:@"nickname"] isNil];
            user.avatarURL = [[profile objectForKey:@"avatar"] isNil];
            [PhotonContent addFriendToDB:user];
        }
        NSArray *joinedGids = [data objectForKey:@"joinedGids"];
        [PhotonContent deleteAllGroups];
        for (NSString *gid in joinedGids) {
            if (gid && [gid isKindOfClass:[NSString class]]) {
                [PhotonContent addGroupToCurrentUserByGid:gid];
                [self loadMembersFormGroup:gid completion:nil];
                [self loadGroupProfile:gid completion:nil];
            }
        }
    }
}

- (void)modifiedName:(NSString *)nickName
            completion:(void(^)(BOOL success,BOOL open))completion{
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    NSString *url = @"photonimdemo/user/my/editProfile";
    [paramter setValue:nickName forKey:@"nickname"];
    [self.netService commonRequestMethod:PhotonRequestMethodPost queryString:url paramter:paramter completion:^(NSDictionary * _Nonnull dict) {
        if (completion) {
            completion(YES,YES);
        }
    } failure:^(PhotonErrorDescription * _Nonnull error) {
        if (completion) {
            completion(NO,NO);
        }
    }];
}

- (void)getIgnoreAlert:(int)chatType
              chatWith:(NSString *)chatWith
            completion:(void(^)(BOOL success,BOOL open))completion{
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    NSString *url = @"";
    if (chatType == (int)PhotonIMChatTypeSingle) {
        url = @"photonimdemo/setting/msg/getP2pRemind";
         [paramter setValue:chatWith forKey:@"remoteid"];
    }else if (chatType == (int)PhotonIMChatTypeGroup){
        url = @"photonimdemo/setting/msg/getP2GRemind";
         [paramter setValue:chatWith forKey:@"gid"];
    }
    [self.netService commonRequestMethod:PhotonRequestMethodPost queryString:url paramter:paramter completion:^(NSDictionary * _Nonnull dict) {
        NSDictionary *data = dict[@"data"];
        if (data.count > 0) {
            id switch_ = data[@"switch"];
            if (completion && [switch_ isKindOfClass:[NSNumber class]]) {
                completion(YES,[switch_ boolValue]);
            }
        }else{
            if (completion) {
                completion(NO,NO);
            }
        }
    } failure:^(PhotonErrorDescription * _Nonnull error) {
        if (completion) {
            completion(NO,NO);
        }
    }];
}

- (void)loadMembersFormGroup:(NSString *)gid completion:(nullable void(^)(BOOL success))completion{
    NSDictionary *paramter = @{@"gid":gid};
    __weak typeof(self)weakSelf = self;
    [self.netService commonRequestMethod:PhotonRequestMethodPost queryString:@"photonimdemo/group/remote/members" paramter:paramter completion:^(NSDictionary * _Nonnull responseDict) {
        [weakSelf wrappMemberDict:responseDict gid:gid completion:completion];
    } failure:^(PhotonErrorDescription * _Nonnull error) {
        if (completion) {
            completion(NO);
        }
    }];
}

- (void)loadMembersFormRoom:(NSString *)gid completion:(nullable void(^)(BOOL success))completion{
    NSDictionary *paramter = @{@"gid":gid};
    __weak typeof(self)weakSelf = self;
    [self.netService commonRequestMethod:PhotonRequestMethodPost queryString:@"/photonimdemo/room/remote/members" paramter:paramter completion:^(NSDictionary * _Nonnull responseDict) {
        [weakSelf wrappMemberDict:responseDict gid:gid completion:completion];
    } failure:^(PhotonErrorDescription * _Nonnull error) {
        if (completion) {
            completion(NO);
        }
    }];
}

- (void)wrappMemberDict:(NSDictionary *)dict gid:(NSString  *)gid completion:(nullable void(^)(BOOL success))completion{
    if ([dict[@"ec"] intValue] != 0) {
        if (completion) {
            completion(NO);
        }
        return;
    }
    NSDictionary *data = [dict objectForKey:@"data"];
    if (data.count > 0) {
        NSArray *lists = [data objectForKey:@"lists"];
        
        if (lists.count > 0) {
            [PhotonContent deleteaAllUserFromGroupWithGid:gid];
            for (NSDictionary *item in lists) {
                PhotonUser *user = [[PhotonUser alloc] init];
                user.userID = [[item objectForKey:@"userId"] isNil];
                user.nickName = [[item objectForKey:@"nickname"] isNil];
                user.userName = [[item objectForKey:@"username"] isNil];
                user.avatarURL = [[item objectForKey:@"avatar"] isNil];
                [PhotonContent addUserToGroupWithUser:user gid:gid];
            }
            
        }
        if (completion) {
            completion(YES);
        }
    }
}

- (void)loadGroupProfile:(NSString *)gid completion:(nullable void(^)(NSString *gid,BOOL success))completion{
    NSDictionary *paramter = @{@"gid":gid};
    __weak typeof(self)weakSelf = self;
    [self.netService commonRequestMethod:PhotonRequestMethodPost queryString:@"photonimdemo/group/remote/profile" paramter:paramter completion:^(NSDictionary * _Nonnull responseDict) {
        [weakSelf wrappGroupProfileDict:responseDict completion:completion];
       
    } failure:^(PhotonErrorDescription * _Nonnull error) {
        if (completion) {
            completion(nil, NO);
        }
    }];
}

- (void)wrappGroupProfileDict:(NSDictionary *)responseDict completion:(void(^)(NSString *gid,BOOL success))completion{
    if ([responseDict[@"ec"] intValue] != 0) {
        if (completion) {
            completion(nil, NO);
        }
        return;
    }
    
    NSDictionary *data = [responseDict objectForKey:@"data"];
    if (data.count > 0) {
        NSDictionary *profile = [data objectForKey:@"profile"];
        if (profile.count > 0) {
            PhotonUser *user = [[PhotonUser alloc] init];
            user.userID = [[profile objectForKey:@"gid"] isNil];
            user.nickName = [[profile objectForKey:@"name"] isNil];
            user.userName = [[profile objectForKey:@"name"] isNil];
            user.avatarURL = [[profile objectForKey:@"avatar"] isNil];
            user.type = [[profile objectForKey:@"type"] isNil]?2:[[[profile objectForKey:@"type"] isNil] intValue];
            [PhotonContent addFriendToDB:user];
            if (completion) {
                completion(user.userID, YES);
            }
        }
    }
}

- (PhotonNetworkService *)netService{
    if (!_netService) {
        _netService = [[PhotonNetworkService alloc] init];
        _netService.baseUrl = [PhotonContent baseUrlString];;
        
    }
    return _netService;
}
@end
