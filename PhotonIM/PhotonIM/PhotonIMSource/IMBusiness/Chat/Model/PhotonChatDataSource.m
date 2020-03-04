//
//  PhotonChatDataSource.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/21.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonChatDataSource.h"
#import "PhotonMessageCenter.h"

#import "PhotonChatTextMessageItem.h"
#import "PhotonChatTextMessageCell.h"

#import "PhotonChatImageMessageItem.h"
#import "PhotonChatImageMessageCell.h"

#import "PhotonChatVoiceMessageItem.h"
#import "PhotonChatVoiceMessageCell.h"

#import "PhotonChatNoticItem.h"
#import "PhotonChatNoticCell.h"

#import "PhotonChatLocationItem.h"
#import "PhotonChatLocationCell.h"
@interface PhotonChatDataSource()
@property (nonatomic, strong, nullable)PhotonIMThreadSafeArray *readMsgIdscCache;
@property (nonatomic, strong, nullable)PhotonIMTimer   *timer;
@end

@implementation PhotonChatDataSource
- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object{
    if ([object isKindOfClass:[PhotonChatTextMessageItem class]]) {
        return [PhotonChatTextMessageCell class];
    }else if([object isKindOfClass:[PhotonChatImageMessageItem class]]){
        return [PhotonChatImageMessageCell class];
    }else if ([object isKindOfClass:[PhotonChatVoiceMessageItem class]]){
        return [PhotonChatVoiceMessageCell class];
    }else if ([object isKindOfClass:[PhotonChatNoticItem class]]){
        return [PhotonChatNoticCell class];
    }else if ([object isKindOfClass:[PhotonChatLocationItem class]]){
        return [PhotonChatLocationCell class];
    }
     return [super tableView:tableView cellClassForObject:object];
}


- (void)tableView:(UITableView *)tableView cell:(UITableViewCell *)cell willAppearAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView cell:cell willAppearAtIndexPath:indexPath];
    id object = [self.items objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[PhotonChatBaseItem  class]]) {
        PhotonChatBaseItem *item = (PhotonChatBaseItem *)object;
        
        PhotonIMMessage *message = (PhotonIMMessage *)item.userInfo;
        if (item.fromType == PhotonChatMessageFromSelf || !message) {
            return;
        }
        if (item.fromType != PhotonChatMessageFromSelf && message.messageStatus != PhotonIMMessageStatusRecvRead && message.chatType == PhotonIMChatTypeSingle) {
            NSString *msgID = [message messageID];
            // 状态设置为已读
            message.messageStatus = PhotonIMMessageStatusRecvRead;
            if(![self.readMsgIds containsObject:msgID]){
                [self.readMsgIdscCache addObject:msgID];
            }
            [self beginSendReadMsgs];
        }
    }
}

// 定时发送已读消息
- (void)beginSendReadMsgs{
    PhotonWeakSelf(self)
    if (!_timer) {
        _timer = [PhotonIMTimer initWithInterval:1 delay:1 repeat:NO
                                         handler:^{
                                             [weakself p_sendReadMsgs];
                                         }];
    }else{
        [_timer delay:^{
            [weakself p_sendReadMsgs];
        }];
    }
}
- (void)p_sendReadMsgs{
    NSArray *items = [self readMsgIds];
    if (items.count == 0) {
        return;
    }
    PhotonWeakSelf(self);
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendReadMsgs:completion:)]) {
        [self.delegate sendReadMsgs:items completion:^(BOOL succeed, PhotonIMError * _Nullable error) {
            if (succeed) {
                [weakself removeReadMsgIds:items];
            }
            
        }];
    }
}
- (NSArray *)readMsgIds{
    return [self.readMsgIdscCache copy];
}
- (void)removeReadMsgIds:(NSArray *)ids{
    [self.readMsgIdscCache removeObjectsInArray:ids];
}

- (PhotonIMThreadSafeArray *)readMsgIdscCache{
    if (!_readMsgIdscCache) {
        _readMsgIdscCache = [PhotonIMThreadSafeArray array];
    }
    return _readMsgIdscCache;
}
@end
