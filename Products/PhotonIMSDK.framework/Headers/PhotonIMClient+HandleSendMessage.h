//
//  PhotonIMClient+HandleSendMessage.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/3.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotonIMClient.h"
NS_ASSUME_NONNULL_BEGIN

/// [HandleSendMessage](https://cosmos.immomo.com/cosmos_sdk_apidoc/imios/html/Classes/PhotonIMClient.html#//api/name/sendMessage:completion:) 处理消息的发送;
@interface PhotonIMClient (HandleSendMessage)
#pragma mark ----- 发送消息相关 ------
/**
 @brief 消息发送方法（不带超时逻辑，内部支持重发），此方法适用于不使用SDK的文件托管功能(即SDK负责文件的上传和发送，操作一体化)
 针对消息正在发送过程中，app被kill掉的情况，app重启后，kill之前的消息会被尝试发送，此时接入端需要实现[-imClient:(id)client sendResultWithMsgID:chatType:chatWith:](https://cosmos.immomo.com/cosmos_sdk_apidoc/imios/html/Protocols/PhotonIMClientProtocol.html#//api/name/imClient:sendResultWithMsgID:chatType:chatWith:error:) 协议方法来处理被重发消息的发送状态。而针对带有资源上传的消息（图片，语音，视频等），如果是资源上传失败导致的消息未能发送，因为不会调用到sendMessage方法，此种情况需要业务端处理此类失败消息重发的逻辑，即在数据库中获取此类消息，重新上传文件，调用消息发送。
 @param message [PhotonIMMessage](https://cosmos.immomo.com/cosmos_sdk_apidoc/imios/html/Classes/PhotonIMMessage.html) 消息体
 @param completion 消息发送的回执，succeed=YES 发送成功此时error = nil;succeed=NO 发送失败此时error包含失败的原因
 */
- (void)sendMessage:(nullable PhotonIMMessage *)message
         completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;

/// @brief 发送通用消息（超时逻辑，超时期间内失败的消息重发）
/// 使用此方法发送聊天消息，在消息发送和等待服务端发送结果的回执之间启动超时机制，超时时间内消息未收到服务端的回执则告知服务端消息发送失败。
/// 针对消息正在发送过程中，app被kill掉的情况，重启app后消息的状态
/// @param message [PhotonIMMessage](https://cosmos.immomo.com/cosmos_sdk_apidoc/imios/html/Classes/PhotonIMMessage.html) 消息体
/// @param timeout 超时时间，单位秒
/// @param completion 消息发送的回执，succeed=YES 发送成功此时error = nil;succeed=NO 发送失败此时error包含失败的原因
- (void)sendMessage:(nullable PhotonIMMessage *)message
            timeout:(NSTimeInterval)timeout
         completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;


/// 消息发送方法，此方法支持文件托管功能(即SDK负责文件的上传和发送，操作一体化)。
/// 此方法取消了progress来回调文件上传进度，更换使用代理方法 - (void)imClient:transportProgressWithMessage:progess:回调上传的进度。
/// 取消了completion来回调消息发送完成的结果，更换使用代理方法- (void)imClient:sendResultWithMessage:succceed:error:回调消息发送完成的结果。
/// @param message 消息对象
/// @param readyToSendBlock 消息准备完成，将要上传和发送，业务端可使用此回调加载刷新ui显示
- (void)sendMessage:(nullable PhotonIMMessage *)message
   readyToSendBlock:(nullable void(^)(PhotonIMMessage * _Nullable message ))readyToSendBlock;


/// 消息发送方法，此方法支持文件托管功能(即SDK负责文件的上传和发送，操作一体化)。
/// 此方法使用代理方法 - (void)imClient:transportProgressWithMessage:progess:回调文件上传的进度。
/// 使用代理方法- (void)imClient:sendResultWithMessage:succceed:error:回调消息发送完成的结果。
/// @param message 消息对象
/// @param timeout 超时时间，单位秒,此时间不包含文件上传的时间。
/// @param readyToSendBlock 消息准备完成，将要上传和发送，业务端可使用此回调加载刷新ui显示
- (void)sendMessage:(nullable PhotonIMMessage *)message
            timeout:(NSTimeInterval)timeout
   readyToSendBlock:(nullable void(^)(PhotonIMMessage * _Nullable message ))readyToSendBlock;


/**
 @brief 单人和群聊中撤回消息的发送
 
 @param message [PhotonIMMessage](https://cosmos.immomo.com/cosmos_sdk_apidoc/imios/html/Classes/PhotonIMMessage.html) 要被撤回的那条消息的对象
 @param completion 消息发送的回执，succeed=YES 发送成功此时error = nil;succeed=NO 发送失败此时error包含失败的原因
 */
- (void)sendWithDrawMessage:(PhotonIMMessage *)message
                 completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;


/**
 @brief 单人聊天中发送消息的撤回
 
 @param msgID 撤回消息的id
 @param fromid 撤回者的id，即消息发送者的id（即自己）
 @param toid 撤回的消息发送对象的id （即对方）
 @param completion 消息发送的回执，succeed=YES 发送成功此时error = nil;succeed=NO 发送失败此时error包含失败的原因
 */
- (void)sendSingleWithDrawMessage:(NSString *)msgID
                           fromid:(NSString *)fromid
                             toid:(NSString *)toid completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;


/**
 
 @brief 群组中发送消息的撤回
 
 @param msgID 撤回消息的id
 @param fromid 撤回者的id，即消息发送者的id（即自己）
 @param toid 群组的id
 @param completion 消息发送的回执，succeed=YES 发送成功此时error = nil;succeed=NO 发送失败此时error包含失败的原因
 */
- (void)sendGroupWithDrawMessage:(NSString *)msgID
                          fromid:(NSString *)fromid
                            toid:(NSString *)toid
                      completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;

/**
 
 @brief 群组中发送消息的撤回
 
 @param msgID 撤回消息的id
 @param originMsgTime 撤回消息的携带的时间戳
 @param fromid 撤回者的id，即消息发送者的id（即自己）
 @param toid 群组的id
 @param completion 消息发送的回执，succeed=YES 发送成功此时error = nil;succeed=NO 发送失败此时error包含失败的原因
 */
- (void)sendGroupWithDrawMessage:(NSString *)msgID
                   originMsgTime:(int64_t)originMsgTime
                          fromid:(NSString *)fromid
                            toid:(NSString *)toid
                      completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion DEPRECATED_MSG_ATTRIBUTE("Please use 'sendGroupWithDrawMessage:fromid:toid:completion:' instead");

/**
 @brief 发送已读消息
 
 @param readMsgIDs 已读消息的ids
 @param fromid 消息接收者的id （即自己）
 @param toid 消息发送者的id，也就是对方
 @param completion 消息发送的回执，succeed=YES 发送成功此时error = nil;succeed=NO 发送失败此时error包含失败的原因
 */
- (void)sendReadMessage:(NSArray<NSString *> *)readMsgIDs fromid:(NSString *)fromid toid:(NSString *)toid completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;


/**
@brief 发送删除消息
@param chatType 删除这批消息的所属的会话类型
@param chatWith 删除这批消息的所属的会话id
@param delMsgIds 删除消息的消息id的集合
@param completion 消息发送的回执，succeed=YES 发送成功此时error = nil;succeed=NO 发送失败此时error包含失败的原因
*/
- (void)sendDeleteMessageWithChatType:(PhotonIMChatType)chatType
                     chatWith:(NSString *)chatWith
                    delMsgIds:(NSArray<NSString *> *)delMsgIds
                   completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;



/// 发送简单的通道消息（适用通知消息），此方法发送用户自定义的消息，此方法发送的消息为不可靠消息，不保证发送成功和送到。消息不入库
/// 对端消息的接受统一通过imClient:(id) didReceiveCustomMesage:回调方法，通道消息即为灵活的自定义消息
/// @param fromid 发送方的id
/// @param toid 接收方的id
/// @param msgBody 送法的消息体内容
/// @param assuredDelivery 是否确保消息被送达。(NO,如果对端不在线，发送成功的消息会丢掉。YES ，发送成功的发送的消息，不管对端在不在线，对端上线后可拉取到)
/// @param enablePush 此条消息是否支持给对方发送push
/// @param timeout 消息的超时时间（单位秒）。(如果 timeout <= 0 则timeout默认为15秒)
/// @param completion 消息发送的回执，succeed=YES 发送成功此时error = nil;succeed=NO 发送失败此时error包含失败的原因
/// @return 返回值为发送消息的id(SDK内部生成的唯一消息id，业务端可获取用来做存储数据的id)
- (NSString *)sendChennalMsgWithFromid:(NSString *)fromid
                            toid:(NSString *)toid
                         msgBody:(PhotonIMCustomBody *)msgBody
                          assuredDelivery:(BOOL)assuredDelivery
                            enablePush:(BOOL)enablePush
                            timeout:(NSTimeInterval)timeout
                                completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;


/// @brief 发送加入房间的消息
/// @param roomId 房间的id
/// @param timeout 消息的超时时间（单位秒）。(如果 timeout <= 0 则timeout默认为15秒)
/// @param completion 消息发送的回执，succeed=YES 发送成功此时error = nil;succeed=NO 发送失败此时error包含失败的原因
- (void)sendJoinRoomWithId:(NSString *)roomId
                       timeout:(NSTimeInterval)timeout
                    completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;

/// @brief 发送退出房间的消息
/// @param roomId 房间的id
/// @param timeout 消息的超时时间（单位秒）。(如果 timeout <= 0 则timeout默认为15秒)
/// @param completion 消息发送的回执，succeed=YES 发送成功此时error = nil;succeed=NO 发送失败此时error包含失败的原因
- (void)sendQuitRoomWithId:(NSString *)roomId
                   timeout:(NSTimeInterval)timeout
                completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;

/**
 @brief 发送推送通知icon上展示的角标数

 @param count 角标展示的数字
 */
- (void)sendCurrentBadge:(NSInteger)count;


/**
 @brief 是否自动消费lt lv 消息偏移。使用场景一般是在业务端使用自己的数据库管理消息的存储，此时需要设置NO关闭自动消费lt lv功能
 
 @param autoConsume 如果设置为NO,需要业务端调用以下方法发送lv
 */
- (void)setAutoConsumePacket:(BOOL)autoConsume;

/**
 @brief 消费 lt, lv 使用场景一般是在业务端使用自己的数据库管理消息的存储,在数据库入库成功后调用，一次保证消息不会重复拉取和丢失
 
 @param savedDict lt lv 集合
 */
- (void)consumePacket:(NSDictionary<NSString*, NSNumber*> *)savedDict;

/**
 @brief消费 lt, lv 使用场景一般是在业务端使用自己的数据库管理消息的存储,在数据库入库成功后调用，一次保证消息不会重复拉取和丢失
 
 @param lt 消息类型
 @param lv 偏移量
 */
- (void)consumePacket:(NSString *)lt lv:(int64_t)lv;
@end

NS_ASSUME_NONNULL_END
