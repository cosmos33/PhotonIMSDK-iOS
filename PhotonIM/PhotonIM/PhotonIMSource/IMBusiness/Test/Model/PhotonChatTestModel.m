//
//  PhotonConversationModel.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/26.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonChatTestModel.h"
#import "PhotonChatTestItem.h"
#import "PhotonMessageCenter.h"
#import <MMKV/MMKV.h>
@interface PhotonChatTestModel()
@property (nonatomic, strong)PhotonIMThreadSafeArray  *cache;
@end

@implementation PhotonChatTestModel
- (void)loadItems:(nullable NSDictionary *)params finish:(void (^)(NSDictionary * _Nullable))finish failure:(void (^)(PhotonErrorDescription * _Nullable))failure{
    PhotonWeakSelf(self);
        NSArray *items =  [weakself.items copy];
        NSArray<PhotonIMConversation *> *conversations = [[PhotonIMClient sharedClient] findConversationList:0 size:200 asc:NO];
    NSInteger index = -1;
        if (conversations.count > 0) {
            NSMutableArray *chatWiths = [NSMutableArray array];
            for (PhotonIMConversation *conversation in  conversations) {
                index++;
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
                PhotonChatTestItem *conItem = [[PhotonChatTestItem alloc] init];
                conItem.userInfo = conversation;
                if (items.count == 0) {
                     [weakself.items addObject:conItem];
                }else{
                    BOOL isNotExist = YES;
                    for (PhotonChatTestItem *item in items) {
                        if ([[[item userInfo] chatWith] isEqualToString:conversation.chatWith]) {
                            isNotExist = NO;
                        }
                       
                       
                    }
                    if(isNotExist){
                        if (weakself.items.count > index) {
                              [weakself.items insertObject:conItem atIndex:index];
                          }else{
                               [weakself.items addObject:conItem];
                          }
                    }
                }
                
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
                PhotonChatTestItem *conItem = [[PhotonChatTestItem alloc] init];
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
