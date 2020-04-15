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
 发送通用消息
 
 @param message 消息
 @param completion 消息发送的回执，succeed=YES 发送成功此时error = nil;succeed=NO 发送失败此时error包含失败的原因
 */
- (void)sendMessage:(nullable PhotonIMMessage *)message completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;



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
 已读消息
 
 @param readMsgIDs 已读消息的ids
 @param fromid 消息接收者的id （即自己）
 @param toid 消息发送者的id，也就是对方
 */
- (void)sendReadMessage:(NSArray<NSString *> *)readMsgIDs fromid:(NSString *)fromid toid:(NSString *)toid completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;


/**
已读消息
@param chatType 删除这批消息的所属的会话类型
@param chatWith 删除这批消息的所属的会话id
@param delMsgIds 删除消息的消息id的集合
@param completion 删除操作的回调
*/
- (void)sendDeleteMessageWithChatType:(PhotonIMChatType)chatType
                     chatWith:(NSString *)chatWith
                    delMsgIds:(NSArray<NSString *> *)delMsgIds
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
