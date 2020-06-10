//
//  PhotonChatViewController+Receive.m
//  PhotonIM
//
//  Created by Bruce on 2019/7/12.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonChatViewController+Receive.h"

@implementation PhotonChatViewController(Receive)
- (NSString *)getChatWith{
    return self.conversation.chatWith;
}
/**
 接收单人聊天消息

 @param client client im sdk client 句柄
 @param message 消息
 */
- (void)imClient:(id)client didReceiveMesage:(PhotonIMMessage *)message{
    [[PhotonIMClient sharedClient] consumePacket:message.lt lv:message.lv];
    [self wrapperMessage:message];
}

/**
 二人聊天消息的撤回

 @param client im sdk client 句柄
 @param message 消息
 */
- (void)imClient:(id)client didReceiveSingleWithDrawMesage:(PhotonIMMessage *)message{
    [self wrapperWithdrawMessage:message];
}

- (void)imClient:(id)client didReceiveGroupWithDrawMesage:(PhotonIMMessage *)message{
     [self wrapperWithdrawMessage:message];
}


/**
 二人聊天已读消息

 @param client <#client description#>
 @param message <#message description#>
 */
- (void)imClient:(id)client didReceiveReadMesage:(PhotonIMMessage *)message{
    [self wrapperReadMessage:message];
}

- (void)imClient:(id)client didReceiveCustomMesage:(PhotonIMMessage *)message{
    [self imClient:client didReceiveChennalMesage:message.messageID fromid:message.fr toid:message.to msgBody:(PhotonIMCustomBody *)message.messageBody];
}

- (void)imClient:(id)client didReceiveChennalMesage:(NSString *)msgId fromid:(NSString *)fromid toid:(NSString *)toid msgBody:(PhotonIMCustomBody *)msgBody{
      PhotonChatMessageFromType fromeType = [fromid isEqualToString:[PhotonContent currentUser].userID]?PhotonChatMessageFromSelf:PhotonChatMessageFromFriend;
    PhotonChatTextMessageItem *textItem = [[PhotonChatTextMessageItem alloc] init];
    textItem.fromType = fromeType;
    textItem.timeStamp = [[NSDate date] timeIntervalSince1970] * 1000.0;
    textItem.messageText = [[NSString alloc] initWithData:msgBody.data encoding:NSUTF8StringEncoding];
    textItem.userInfo = [PhotonIMMessage commonMessageWithFrid:fromid toid:toid messageType:PhotonIMMessageTypeText chatType:PhotonIMChatTypeSingle];
    NSString *avatarUrl = [PhotonContent friendDetailInfo:fromid].avatarURL;
    textItem.avatalarImgaeURL = avatarUrl;

    [self addItem:textItem];

    
}
#pragma mark ------ Private Method---------
// 处理二人聊天收到的信息
- (void)wrapperMessage:(PhotonIMMessage *)message{
    [self _wrapperMessage:message];
}
- (void)_wrapperMessage:(PhotonIMMessage *)message{
    id item = [(PhotonChatModel *)self.model wrapperMessage:message];
    if (!item) {
        return;
    }
    [self addItem:item];
    
    if(message.chatType == PhotonIMChatTypeGroup && message.msgAtType != PhotonIMAtTypeNoAt){
        [[PhotonMessageCenter sharedCenter] resetAtType:self.conversation];
    }
    
}
// 处理撤回消息
- (void)wrapperWithdrawMessage:(PhotonIMMessage *)message{
    BOOL ret = [(PhotonChatModel *)self.model wrapperWithdrawMessage:message];
    if (ret) {
         [self reloadData];
    }
}


// 消息已读的处理
- (void)wrapperReadMessage:(PhotonIMMessage *)message{
    BOOL ret = [(PhotonChatModel *)self.model wrapperReadMessage:message];
    if (ret) {
        [self reloadData];
    }
    
}

- (void)imClient:(id)client didReceiveDeleteMesage:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith delMsgIds:(NSArray<NSString *> *)delMsgIds userInfo:(NSDictionary<NSString *,id> *)userInfo{
     BOOL ret = [self wrapperWithDelMsgIds:delMsgIds];
       if (ret) {
            [self reloadData];
       }
}
- (BOOL)wrapperWithDelMsgIds:(NSArray *)delMsgIds{
    NSArray *items=[self.model.items copy];
    BOOL rec = NO;
    for (PhotonChatBaseItem *item in items) {
        PhotonIMMessage *tempMsg = item.userInfo;
        if ([delMsgIds containsObject:tempMsg.messageID]) {
            [self.model.items removeObject:item];
            rec = YES;
        }
    }
    return rec;
}
@end
