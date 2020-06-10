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

@interface PhotonIMClient (HandleSendMessage)
#pragma mark ----- 发送消息相关 ------
/**
 发送通用消息（不带超时逻辑，内部支持重发）
 
 @param message 消息体
 @param completion 消息发送的回执，succeed=YES 发送成功此时error = nil;succeed=NO 发送失败此时error包含失败的原因
 */
- (void)sendMessage:(nullable PhotonIMMessage *)message completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;


///  发送通用消息（超时逻辑，超时期间重试内存失败）
/// @param message 消息体
/// @param timeout <#timeout description#>
/// @param completion 消息发送的回执，succeed=YES 发送成功此时error = nil;succeed=NO 发送失败此时error包含失败的原因
- (void)sendMessage:(nullable PhotonIMMessage *)message timeout:(NSTimeInterval)timeout completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;



/**
 单人聊天中发送消息的撤回
 
 @param message 要被撤回的那条消息的对象
 */
- (void)sendWithDrawMessage:(PhotonIMMessage *)message completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;


/**
 单人聊天中发送消息的撤回
 
 @param MsgID 撤回消息的id
 @param fromid 撤回者的id，即消息发送者的id（即自己）
 @param toid 撤回的消息发送对象的id （即对方）
 */
- (void)sendSingleWithDrawMessage:(NSString *)MsgID fromid:(NSString *)fromid toid:(NSString *)toid completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;

/**
 
 群组中发送消息的撤回
 
 @param MsgID 撤回消息的id
 @param originMsgTime 撤回消息的携带的时间戳
 @param fromid 撤回者的id，即消息发送者的id（即自己）
 @param toid 群组的id
 */
- (void)sendGroupWithDrawMessage:(NSString *)MsgID
                   originMsgTime:(int64_t)originMsgTime
                          fromid:(NSString *)fromid
                            toid:(NSString *)toid
                      completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;

/**
 发送已读消息
 
 @param readMsgIDs 已读消息的ids
 @param fromid 消息接收者的id （即自己）
 @param toid 消息发送者的id，也就是对方
 */
- (void)sendReadMessage:(NSArray<NSString *> *)readMsgIDs fromid:(NSString *)fromid toid:(NSString *)toid completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;


/**
发送删除消息
@param chatType 删除这批消息的所属的会话类型
@param chatWith 删除这批消息的所属的会话id
@param delMsgIds 删除消息的消息id的集合
@param completion 删除操作的回调
*/
- (void)sendDeleteMessageWithChatType:(PhotonIMChatType)chatType
                     chatWith:(NSString *)chatWith
                    delMsgIds:(NSArray<NSString *> *)delMsgIds
                   completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;



/// 发送简单的通道消息（适用通知消息），此方法发送用户自定义的消息，此方法发送的消息为不可靠消息，不保证发送成功和送到。消息不入库
/// @param fromid 发送方的id
/// @param toid 接收方的id
/// @param msgBody 送法的消息体内容
/// @param assuredDelivery 是否确保消息被送达。(NO,如果对端不在线，发送成功的消息会丢掉。YES ，发送成功的发送的消息，不管对端在不在线，对端上线后可拉取到)
/// @enablePush 此条消息是否支持给对方发送push
/// @param timeout 消息的超时时间（单位秒）。(如果 timeout <= 0 则timeout默认为15秒)
/// @return 返回值为发送消息的id(SDK内部生成的唯一消息id，业务端可获取用来做存储数据的id)
- (NSString *)sendChennalMsgWithFromid:(NSString *)fromid
                            toid:(NSString *)toid
                         msgBody:(PhotonIMCustomBody *)msgBody
                          assuredDelivery:(BOOL)assuredDelivery
                            enablePush:(BOOL)enablePush
                            timeout:(NSTimeInterval)timeout
                                completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;
/**
 发送推送通知icon上展示的角标

 @param count 角标展示的数字
 */
- (void)sendCurrentBadge:(NSInteger)count;


/**
 是否自动消费lt lv 消息偏移
 
 @param autoConsume 如果设置为NO,需要业务端调用以下方法发送lv
 */
- (void)setAutoConsumePacket:(BOOL)autoConsume;

/**
 消费 lt, lv
 
 @param savedDict lt lv 集合
 */
- (void)consumePacket:(NSDictionary<NSString*, NSNumber*> *)savedDict;

/**
 消费 lt, lv
 
 @param lt 消息类型
 @param lv 偏移量
 */
- (void)consumePacket:(NSString *)lt lv:(int64_t)lv;
@end

NS_ASSUME_NONNULL_END
