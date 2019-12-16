//
//  PhotonConversationModel.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/26.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonConversationModel.h"
#import "PhotonConversationItem.h"
#import "PhotonMessageCenter.h"
#import <MMKV/MMKV.h>
@interface PhotonConversationModel()
@property (nonatomic, strong)PhotonIMThreadSafeArray  *cache;
@end

@implementation PhotonConversationModel
- (void)loadItems:(nullable NSDictionary *)params finish:(void (^)(NSDictionary * _Nullable))finish failure:(void (^)(PhotonErrorDescription * _Nullable))failure{
    PhotonWeakSelf(self);
        [super loadItems:params finish:finish failure:failure];
        NSArray<PhotonIMConversation *> *conversations = [[PhotonIMClient sharedClient] findConversationList:0 size:200 asc:NO];
        [weakself.items removeAllObjects];
        if (conversations.count > 0) {
            NSMutableArray *chatWiths = [NSMutableArray array];
            for (PhotonIMConversation *conversation in  conversations) {
                PhotonUser *user = [PhotonContent friendDetailInfo:conversation.chatWith];
                if (conversation.chatType == PhotonIMChatTypeSingle) {
                    if (!user) {
                        [chatWiths addObject:conversation.chatWith];
                    }
                }else if (conversation.chatType == PhotonIMChatTypeGroup){
                    [[PhotonContent currentUser]loadMembersFormGroup:conversation.chatWith completion:nil];
                }
                conversation.FAvatarPath = user.avatarURL;
                conversation.FName = user.nickName;
                PhotonConversationItem *conItem = [[PhotonConversationItem alloc] init];
                conItem.userInfo = conversation;
                [weakself.items addObject:conItem];
            }
            if (chatWiths.count > 0) {
                [[PhotonContent currentUser] loadFriendProfileBatch:chatWiths completion:^(BOOL success) {
                }];
            }
           
        }
        [PhotonUtil runMainThread:^{
            if (finish) {
                finish(nil);
            }
        }];
    

        BOOL excute = [[MMKV defaultMMKV] getBoolForKey:[PhotonContent currentUser].userID];
        if (conversations.count == 0 && !excute) {
            [[MMKV defaultMMKV] setBool:YES forKey:[PhotonContent currentUser].userID];
            __weak typeof(self)weakSelf = self;
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if (params && params.count > 0) {
                [dict addEntriesFromDictionary:params];
            }
            [self.netService commonRequestMethod:PhotonRequestMethodPost queryString:@"photonimdemo/contact/recentUser" paramter:dict completion:^(NSDictionary * _Nonnull responseDict) {
                [weakSelf wrappResponseddDict:responseDict];
                [PhotonUtil runMainThread:^{
                    if (finish) {
                        finish(nil);
                    }
                }];
            } failure:^(PhotonErrorDescription * _Nonnull error) {
            }];
        }

}


/**
 <#Description#>

 @param dict <#dict description#>
 */
- (void)wrappResponseddDict:(NSDictionary *)dict{
    [self.items removeAllObjects];
    [super wrappResponseddDict:dict];
    NSMutableArray<PhotonIMConversation *> *conversations = [[NSMutableArray alloc] init];
    NSDictionary *data = [[dict objectForKey:@"data"] isNil];
    if (data.count > 0) {
        NSArray *lists = [[data objectForKey:@"lists"] isNil];
        PhotonLog(@"history session data count: %@",@([lists count]));
        if (lists.count > 0) {
            for (NSDictionary *item in lists) {
                
                NSString *chatWith = [[item objectForKey:@"id"] isNil];
                int type = [[[item objectForKey:@"type"] isNil] intValue];
                PhotonIMChatType chatType = (PhotonIMChatType)type;
                
                PhotonIMConversation *conversation = [[PhotonIMConversation alloc] initWithChatType:chatType chatWith:chatWith];
                
                conversation.FName = [[item objectForKey:@"nickname"] isNil];
                conversation.FAvatarPath = [[item objectForKey:@"avatar"] isNil];
                
                
                [conversations addObject:conversation];
                PhotonConversationItem *conItem = [[PhotonConversationItem alloc] init];
                conItem.userInfo = conversation;
                [self.items addObject:conItem];
            }
        }
    }
    if (conversations.count) {
         [[PhotonIMClient sharedClient] saveConversationBatch:conversations];
    }
}

- (PhotonIMThreadSafeArray *)cache{
    if (!_cache) {
        _cache = [PhotonIMThreadSafeArray array];
    }
    return _cache;
}
@end
