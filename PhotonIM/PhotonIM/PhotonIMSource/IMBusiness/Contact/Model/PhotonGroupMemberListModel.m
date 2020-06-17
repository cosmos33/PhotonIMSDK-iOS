//
//  PhotonGroupMemberListModel.m
//  PhotonIM
//
//  Created by Bruce on 2019/9/24.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonGroupMemberListModel.h"
#import "PhotonChatTransmitItem.h"
#import "PhotonTitleTableItem.h"
@implementation PhotonGroupMemberListModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showSelectBtn = YES;
    }
    return self;
}

- (void)loadItems:(nullable NSDictionary *)params finish:(void (^)(NSDictionary * _Nullable))finish failure:(void (^)(PhotonErrorDescription * _Nullable))failure{
    [super loadItems:params finish:finish failure:failure];
    __weak typeof(self)weakSelf = self;
    [PhotonUtil showLoading:nil];
    NSDictionary *paramter = @{@"gid":self.gid};
    NSString *path = @"photonimdemo/group/remote/members";
    if (self.isRoom) {
        path = @"photonimdemo/group/room/members";
    }
    [self.netService commonRequestMethod:PhotonRequestMethodPost queryString:path paramter:paramter completion:^(NSDictionary * _Nonnull responseDict) {
        [weakSelf wrappResponseddDict:responseDict];
        if (finish) {
            finish(nil);
        }
        [PhotonUtil hiddenLoading];
    } failure:^(PhotonErrorDescription * _Nonnull error) {
        NSArray *users = [PhotonContent findAllUsersWithGroupId:weakSelf.gid];
        for (PhotonUser *user in users) {
            if (user) {
                if([user.userID isEqualToString:[PhotonContent currentUser].userID]){
                    continue;
                }
                PhotonChatTransmitItem *item = [[PhotonChatTransmitItem alloc] init];
                item.contactID = user.userID;
                item.contactName = user.nickName;
                item.contactAvatar = user.avatarURL;
                item.userInfo = user;
                item.showSelectBtn = self.showSelectBtn;
                [self.items addObject:item];
            }
        }
        if (failure) {
            failure(error);
        }
        [PhotonUtil hiddenLoading];
    }];
}

- (void)wrappResponseddDict:(NSDictionary *)dict{
    [super wrappResponseddDict:dict];
    NSDictionary *data = [dict objectForKey:@"data"];
    if (data.count > 0) {
        NSArray *lists = [data objectForKey:@"lists"];
        
        if (lists.count > 0) {
             self.memberCount = lists.count;
            self.items = [PhotonIMThreadSafeArray arrayWithCapacity:lists.count];
            for (NSDictionary *item in lists) {
                PhotonUser *user = [[PhotonUser alloc] init];
                user.userID = [[item objectForKey:@"userId"] isNil];
                if([user.userID isEqualToString:[PhotonContent currentUser].userID]){
                    continue;
                }
                user.nickName = [[item objectForKey:@"nickname"] isNil];
                user.userName = [[item objectForKey:@"username"] isNil];
                user.avatarURL = [[item objectForKey:@"avatar"] isNil];
                [PhotonContent addUserToGroupWithUser:user gid:self.gid];
                if (user) {
                    PhotonChatTransmitItem *item = [[PhotonChatTransmitItem alloc] init];
                    item.contactID = user.userID;
                    item.contactName = user.nickName;
                    item.contactAvatar = user.avatarURL;
                    item.showSelectBtn = self.showSelectBtn;
                    item.userInfo = user;
                    [self.items addObject:item];
                }
            }
        }
    }
}

@end
