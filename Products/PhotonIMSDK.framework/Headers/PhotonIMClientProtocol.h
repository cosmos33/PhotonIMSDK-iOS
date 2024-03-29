//
//  PhotonIMClientProtocol.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/9.
//  Copyright © 2019 Bruce. All rights reserved.
//

#ifndef PhotonIMClientProtocol_h
#define PhotonIMClientProtocol_h
#import "PhotonIMEnum.h"
@class PhotonIMMessage;
@protocol PhotonIMClientProtocol <NSObject>

@optional
#pragma mark ======== IM登录回调相关接收消息 ===========
/**
 登录状态
 
 @param client im client
 @param loginstatus 登录过程中的状态
 */
- (void)imClientLogin:(id)client loginStatus:(PhotonIMLoginStatus)loginstatus;


/**
 登录失败时回调

 @param client <#client description#>
 @param failedType 失败的类型
 */
- (void)imClientLogin:(id)client failedType:(PhotonIMLoginFailedType)failedType;
#pragma mark ======== 拉取消息相关 ===========

/**
 拉取消息的状态回调

 @param client <#client description#>
 @param status <#status description#>
 @return 是否仅在IM登录后回调执行一次Sync方法 YES 仅一次， NO 每次拉取消息都有回调,默认是NO;
 */
- (BOOL)imClientSync:(id)client syncStatus:(PhotonIMSyncStatus)status;

#pragma mark ======== 接收消息 ===========
/**
 设置会话中对方的id
 
 @return <#return value description#>
 */
- (NSString *)getChatWith;
/**
 接收到消息 包含所有类型的消息（单聊，群聊）消息
 
 @param client <#client description#>
 @param message <#message description#>
 */
- (void)imClient:(id)client didReceiveMesage:(PhotonIMMessage *)message;

/**
 接收到单聊消息
 
 @param client <#client description#>
 @param message <#message description#>
 */
- (void)imClient:(id)client didReceiveSingleMesage:(PhotonIMMessage *)message;

/**
 接收到群聊消息
 
 @param client <#client description#>
 @param message <#message description#>
 */
- (void)imClient:(id)client didReceiveGroupMesage:(PhotonIMMessage *)message;

/**
 接收到自定义消息
 
 @param client <#client description#>
 @param message <#message description#>
 */
- (void)imClient:(id)client didReceiveCustomMesage:(PhotonIMMessage *)message;


/**
 收到单人消息撤回消息
 
 @param client <#client description#>
 @param message <#message description#>
 */
- (void)imClient:(id)client didReceiveSingleWithDrawMesage:(PhotonIMMessage *)message;

/**
 收到群组消息撤回消息
 
 @param client <#client description#>
 @param message <#message description#>
 */
- (void)imClient:(id)client didReceiveGroupWithDrawMesage:(PhotonIMMessage *)message;


/**
 收到消息已读的消息
 
 @param client <#client description#>
 @param message <#message description#>
 */
- (void)imClient:(id)client didReceiveReadMesage:(PhotonIMMessage *)message;


#pragma mark ======== 其他 ===========
/**
会话信息有变化时回调
 
@param envent 会话的操作类型（创建，删除，更新）
@param chatType 会话类型
@param chatWith 会话id
注：chatType和chatWith 二者一起确定一个会话的唯一性
 */
- (void)conversationChange:(PhotonIMConversationEvent)envent chatType:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;

/**
 会话数据有变化，依据此回调刷新会话列表
 */
- (void)networkChange:(PhotonIMNetworkStatus)networkStatus;
@end
#endif /* PhotonIMClientProtocol_h */
