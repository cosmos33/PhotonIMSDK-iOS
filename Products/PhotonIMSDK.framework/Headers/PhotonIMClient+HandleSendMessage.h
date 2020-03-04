/*!

 @header PhotonIMClient+HandleSendMessage.h

 @abstract PhotonIMSDK 负责消息的发送

 @author Created by Bruce on 2019/6/27.

 @version 2.1.1 2019/12/25 Creation

*/

#import <Foundation/Foundation.h>
#import "PhotonIMClient.h"
NS_ASSUME_NONNULL_BEGIN
/*!

@class PhotonIMClient (HandleSendMessage)

@abstract 负责消息的发送类别。

*/
@interface PhotonIMClient (HandleSendMessage)
#pragma mark ----- 发送消息相关 ------
/*!
@abstract 发送通用消息

@discussion 发送消息需要构建PhotonIMMessage对象，发送成功或者失败的消息会通过completion回调给业务端

@param message PhotonIMMessage的对象
 
@param completion 消息发送的回执，succeed=YES 发送成功此时error = nil;succeed=NO 发送失败此时error包含失败的原因
*/
- (void)sendMessage:(nullable PhotonIMMessage *)message completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;


/*!
@abstract 发送单人聊天中消息的撤回消息

@discussion 发送消息需要构建PhotonIMMessage对象，发送成功或者失败的消息会通过completion回调给业务端

@param message 要被撤回的那条消息的PhotonIMMessage对象
 
@param completion 消息发送的回执，succeed=YES 发送成功此时error = nil;succeed=NO 发送失败此时error包含失败的原因
 
*/


- (void)sendWithDrawMessage:(PhotonIMMessage *)message completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;


/*!
@abstract 发送单人聊天中消息的撤回消息

@discussion 发送成功或者失败的消息会通过completion回调给业务端

@param MsgID 撤回消息的id
 
@param fromid 撤回者的id，即消息发送者的id（即自己）
 
@param toid 撤回的消息发送对象的id （即对方）
 
@param completion 消息发送的回执，succeed=YES 发送成功此时error = nil;succeed=NO 发送失败此时error包含失败的原因
 
*/
- (void)sendSingleWithDrawMessage:(NSString *)MsgID fromid:(NSString *)fromid toid:(NSString *)toid completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;

/*!
@abstract 发送群组聊天中消息的撤回消息

@discussion 发送成功或者失败的消息会通过completion回调给业务端

@param MsgID 撤回消息的id
 
@param originMsgTime 撤回消息的携带的时间戳
 
@param fromid 撤回者的id，即消息发送者的id（即自己）
 
@param toid 群组的id
 
@param completion 消息发送的回执，succeed=YES 发送成功此时error = nil;succeed=NO 发送失败此时error包含失败的原因
 
*/
- (void)sendGroupWithDrawMessage:(NSString *)MsgID
                   originMsgTime:(int64_t)originMsgTime
                          fromid:(NSString *)fromid
                            toid:(NSString *)toid
                      completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;

/*!
@abstract 发送已读消息

@discussion 发送成功或者失败的消息会通过completion回调给业务端

@param readMsgIDs 已读消息的ids
 
@param fromid 消息接收者的id （即自己）
 
@param toid 消息发送者的id，也就是对方
 
@param completion 消息发送的回执，succeed=YES 发送成功此时error = nil;succeed=NO 发送失败此时error包含失败的原因
 
*/
- (void)sendReadMessage:(NSArray<NSString *> *)readMsgIDs fromid:(NSString *)fromid toid:(NSString *)toid completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;


/**
删除消息
@param chatType 删除这批消息的所属的会话类型
@param chatWith 删除这批消息的所属的会话id
@param delMsgIds 删除消息的消息id的集合
@param completion 删除操作的回调
*/
- (void)sendDeleteMessageWithChatType:(PhotonIMChatType)chatType
                     chatWith:(NSString *)chatWith
                    delMsgIds:(NSArray<NSString *> *)delMsgIds
                   completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;
/*!
 
@abstract 发送推送通知icon上展示的角标

@discussion 角标数由业务端决定
 
*/
- (void)sendCurrentBadge:(NSInteger)count;

/*!
 
@abstract 设置消息在服务端的偏移量是否自定消费

@discussion 如果设置消息的偏移量自动消费（YES），消息收到后就会告知服务端拉取消息成功而不关心业务端是否入库成功，如果业务端为入库成功，则有可能导致消息丢失的问题.
 推荐关闭消息的偏移量自动消费，当入库操作完成后在处理偏移量的移动

@param autoConsume YES支持自动消费， NO关闭自动消费
 
*/
- (void)setAutoConsumePacket:(BOOL)autoConsume;

/*!
 
@abstract 消费 lt, lv

@discussion 在设置setAutoConsumePacket为NO,关闭自动消费的情况下，业务端如果使用自己的数据库，可在数据入库成功后调用

@param savedDict lt, lv及集合@{lt:lv,lt:lv,...}
 
*/
- (void)consumePacket:(NSDictionary<NSString*, NSNumber*> *)savedDict;

/*!
 
@abstract 消费 lt, lv

@discussion 在设置setAutoConsumePacket为NO,关闭自动消费的情况下，业务端如果使用自己的数据库，可在数据入库成功后调用

@param lt 消息类型
 
@param lv 偏移量
*/
- (void)consumePacket:(NSString *)lt lv:(int64_t)lv;
@end

NS_ASSUME_NONNULL_END
