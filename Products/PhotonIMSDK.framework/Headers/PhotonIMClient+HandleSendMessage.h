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

/// 消息发送方法，此方法适用于不使用SDK的文件托管功能(即SDK负责文件的上传和发送，操作一体化)
/// @param message 消息对象
/// @param completion 消息发送完成回调，succeed=YES 发送成功此时error = nil;succeed=NO 发送失败此时error包含失败的原因
- (void)sendMessage:(nullable PhotonIMMessage *)message
         completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;

/// 消息发送方法，此方法支持文件托管功能(即SDK负责文件的上传和发送，操作一体化)
/// @param message 消息对象
/// @param readyToSendBlock 消息准备完成，将要上传和发送，业务端可使用此回调加载刷新ui显示
/// @param progress 文件的上传进度回调，当上传到totalUnitCount=completedUnitCount时，表示文件上传成功
/// @param completion 消息发送完成回调，succeed=YES 发送成功此时error = nil;succeed=NO 发送失败此时error包含失败的原因
- (void)sendMessage:(nullable PhotonIMMessage *)message
   readyToSendBlock:(nullable void(^)(PhotonIMMessage * _Nullable message ))readyToSendBlock
 fileUploadProgress:(nullable void(^)(NSProgress * _Nonnull uploadProgress))progress
      completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error))completion;

/// 消息发送方法，此方法支持文件托管功能(即SDK负责文件的上传和发送，操作一体化)。
/// 此方法取消了progress来回调文件上传进度，更换使用代理方法 - (void)imClient:transportProgressWithMessage:progess:回调上传的进度。
/// 取消了completion来回调消息发送完成的结果，更换使用代理方法- (void)imClient:sendResultWithMessage:succceed:error:回调消息发送完成的结果。
/// @param message 消息对象
/// @param readyToSendBlock 消息准备完成，将要上传和发送，业务端可使用此回调加载刷新ui显示
- (void)sendMessage:(nullable PhotonIMMessage *)message
   readyToSendBlock:(nullable void(^)(PhotonIMMessage * _Nullable message ))readyToSendBlock;


/**
 单人聊天中发送消息的撤回
 
 @param message 要被撤回的那条消息的对象
 */
- (void)sendWithDrawMessage:(PhotonIMMessage *)message completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;


/**
 单人聊天中发送消息的撤回
 
 @param msgID 撤回消息的id
 @param fromid 撤回者的id，即消息发送者的id（即自己）
 @param toid 撤回的消息发送对象的id （即对方）
 */
- (void)sendSingleWithDrawMessage:(NSString *)msgID fromid:(NSString *)fromid toid:(NSString *)toid completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;

/**
 
 群组中发送消息的撤回
 
 @param msgID 撤回消息的id
 @param originMsgTime 撤回消息的携带的时间戳
 @param fromid 撤回者的id，即消息发送者的id（即自己）
 @param toid 群组的id
 */
- (void)sendGroupWithDrawMessage:(NSString *)msgID
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
