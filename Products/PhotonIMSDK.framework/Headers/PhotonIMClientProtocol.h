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
#import "PhotonIMError.h"
NS_ASSUME_NONNULL_BEGIN
@class PhotonIMMessage;
@class PhotonIMCustomBody;


/// 此协议管理着im登录，消息接收等回调
@protocol PhotonIMClientProtocol <NSObject>

@optional
#pragma mark ======== IM登录回调相关接收消息 ===========
/**
 登录状态，登录过程中状态改变时回调,业务端通过此回调方法监听IM登录过程中状态的变化。登录状态详情请见:
 [PhotonIMLoginStatus](https://cosmos.immomo.com/cosmos_sdk_apidoc/imios/html/Constants/PhotonIMLoginStatus.html)
 @param client imclient
 @param loginstatus 登录过程中的状态
 */
- (void)imClientLogin:(id)client loginStatus:(PhotonIMLoginStatus)loginstatus;


/**
 登录失败时回调。失败类型详情请见:
 [PhotonIMLoginFailedType](https://cosmos.immomo.com/cosmos_sdk_apidoc/imios/html/Constants/PhotonIMLoginFailedType.html)
 @param client imclient
 @param failedType 失败的类型
 */
- (void)imClientLogin:(id)client failedType:(PhotonIMLoginFailedType)failedType;

#pragma mark ======== 拉取消息相关 ===========

/**
 拉取消息的状态回调。消息同步状态详情请见:
 [PhotonIMSyncStatus](https://cosmos.immomo.com/cosmos_sdk_apidoc/imios/html/Constants/PhotonIMSyncStatus.html)
 @param client imclient
 @param status 消息拉取的状态
 @return 是否仅在IM登录后回调执行一次Sync方法 YES 仅一次， NO 每次拉取消息都有回调,默认是NO;
 */
- (BOOL)imClientSync:(id)client syncStatus:(PhotonIMSyncStatus)status;


#pragma mark ======== 接收消息 ===========
/**
 设置会话中对方的id，设置此值后，当前设置的类接收的消息回调是只针对此会话的消息
 
 @return 返回对话中对方的id
 */
- (NSString *)getChatWith;

/**
 接收到消息时回调 包含所有类型的消息（单聊，群聊）消息.
 
 @param client imclient
 @param message [PhotonIMMessage](https://cosmos.immomo.com/cosmos_sdk_apidoc/imios/html/Classes/PhotonIMMessage.html) 消息对象，存储消息内容
 */
- (void)imClient:(id)client didReceiveMesage:(PhotonIMMessage *)message;

/**
 接收到单聊消息时回调
 
 @param client imclient
 @param message [PhotonIMMessage](https://cosmos.immomo.com/cosmos_sdk_apidoc/imios/html/Classes/PhotonIMMessage.html) 消息对象，存储消息内容
 */
- (void)imClient:(id)client didReceiveSingleMesage:(PhotonIMMessage *)message;

/**
 接收到群聊消息时回调
 
 @param client imclient
 @param message [PhotonIMMessage](https://cosmos.immomo.com/cosmos_sdk_apidoc/imios/html/Classes/PhotonIMMessage.html) 消息对象，存储消息内容
 */
- (void)imClient:(id)client didReceiveGroupMesage:(PhotonIMMessage *)message;

/**
 接收到自定义类型的通道消息时回调，消息包含：接收的消息包含服务端发的系统消息和对端发的通道消息
 @param client imclient
 @param message [PhotonIMMessage](https://cosmos.immomo.com/cosmos_sdk_apidoc/imios/html/Classes/PhotonIMMessage.html) 消息对象，存储消息内容
 */
- (void)imClient:(id)client didReceiveCustomMesage:(PhotonIMMessage *)message;


/**
 接收房间消息消息时回调
 
 @param client imclient
 @param message [PhotonIMMessage](https://cosmos.immomo.com/cosmos_sdk_apidoc/imios/html/Classes/PhotonIMMessage.html) 消息体，仅收到chatType为Room是回调
 */
- (void)imClient:(id)client didReceiveRoomMesage:(PhotonIMMessage *)message;


/**
 收到单人消息撤回消息时回调
 
 @param client imclient
 @param message [PhotonIMMessage](https://cosmos.immomo.com/cosmos_sdk_apidoc/imios/html/Classes/PhotonIMMessage.html) 消息对象，存储消息内容
 */
- (void)imClient:(id)client didReceiveSingleWithDrawMesage:(PhotonIMMessage *)message;
 
/**
 收到群组消息撤回消息时回调
 
 @param client imclient
 @param message [PhotonIMMessage](https://cosmos.immomo.com/cosmos_sdk_apidoc/imios/html/Classes/PhotonIMMessage.html) 消息对象，存储消息内容
 */
- (void)imClient:(id)client didReceiveGroupWithDrawMesage:(PhotonIMMessage *)message;


/**
 收到消息已读的消息时回调
 
 @param client imclient
 @param message [PhotonIMMessage](https://cosmos.immomo.com/cosmos_sdk_apidoc/imios/html/Classes/PhotonIMMessage.html) 消息对象，存储消息内容
 */
- (void)imClient:(id)client didReceiveReadMesage:(PhotonIMMessage *)message DEPRECATED_MSG_ATTRIBUTE("Use imClient:didReceiveReadMesage:chatWith:readMsgIDs:userInfo: instead.");

/**
 收到消息已读的消息。同方法:imClient:didReceiveReadMesage:
 
 @param client   client 对象
 @param chatType 删除的消息所属的会话类型
 @param chatWith 删除的消息所属的会话id
 @param readMsgIDs 对方已读的消息idl列表
 @param userInfo 预留属性字段
 */
- (void)imClient:(id)client
    didReceiveReadMesage:(PhotonIMChatType)chatType
                chatWith:(NSString *)chatWith
                readMsgIds:(NSArray<NSString *> *)readMsgIDs
                userInfo:(nullable id)userInfo;
/**
 收到消息的删除消息时回调
 
 @param client   client 对象
 @param chatType 删除的消息所属的会话类型
 @param chatWith 删除的消息所属的会话id
 @param delMsgIds 对方删除消息的id列表
 @param userInfo 预留属性字段
 */
- (void)imClient:(id)client
                didReceiveDeleteMesage:(PhotonIMChatType)chatType
                chatWith:(NSString *)chatWith
                delMsgIds:(NSArray<NSString *> *)delMsgIds
                userInfo:(nullable id)userInfo;

#pragma mark ======== 其他 ===========
/**
会话信息有变化时回调
 dev_2.0.1
@param envent 会话的操作类型（创建，删除，更新）
@param chatType 会话类型
@param chatWith 会话id
注：chatType和chatWith 二者一起确定一个会话的唯一性
 */
- (void)conversationChange:(PhotonIMConversationEvent)envent chatType:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;

/**
 会话数据有变化，依据此回调刷新会话列表
 
 @param networkStatus 网络状态
 */
- (void)networkChange:(PhotonIMNetworkStatus)networkStatus;



/**
 重发程序kill时的消息，消息发出后监听此回执，刷新会话列表页UI展示
 
 @param client client
 @param msgID 消息的id
 @param chatType 消息所属的会话
 @param chatWith 消息所属的会话对方id
 @param error 发送结果的成功失败信息
 */
- (void)imClient:(id)client
sendResultWithMsgID:(NSString *)msgID
        chatType:(PhotonIMChatType)chatType
        chatWith:(NSString * _Nullable)chatWith
        error:( PhotonIMError* _Nullable)error DEPRECATED_MSG_ATTRIBUTE("Use imClient:sendResultWithMessage:succceed: error.");

/**
消息发送的结果回调

@param client client
@param message 发送后的nmessage对象
@param succceed 发送是否成功
@param error 发送结果的成功失败信息
*/
- (void)imClient:(id)client
sendResultWithMessage:(PhotonIMMessage *)message
        succceed:(BOOL)succceed
           error:( PhotonIMError* _Nullable)error;

/**
消息中资源上传完成的时回调，更新UI层的进度显示
@param client client
@param message 发送后的nmessage对象
@param progess 文件上传的进度，((float)progess.completedUnitCount/(float)progess.totalUnitCount)）>= 1.0是表示文件上传完成
*/
- (void)imClient:(id)client
transportProgressWithMessage:(PhotonIMMessage *)message
         progess:(NSProgress *_Nullable)progess;

/**
消息问价下载完成
@param client client
@param message 发送后的nmessage对象
@param error 文件传输中的错误提示
*/
- (void)imClient:(id)client
downloadCompletionWithMessage:(PhotonIMMessage *)message
        filePath:(NSString* _Nullable)filePath
           error:(PhotonIMError* _Nullable)error;
@end
#endif /* PhotonIMClientProtocol_h */
NS_ASSUME_NONNULL_END
