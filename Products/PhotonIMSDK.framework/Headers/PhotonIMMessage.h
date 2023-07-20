//
//  PhotonIMMessage.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/6/29.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonIMBaseMessage.h"
#import "PhotonIMBaseBody.h"
NS_ASSUME_NONNULL_BEGIN


///PhotonIMBaseMessage的子类，管理消息相关的数据
@interface PhotonIMMessage : PhotonIMBaseMessage

/**
 消息体,
 */
@property (nonatomic, strong, readonly ,nullable)PhotonIMBaseBody *messageBody;

///////////////// 消息撤回相关 ///////////////////

/**
 撤回消息的id，上行此值是撤回消息的id，下行则为对方接收后又被撤回的那条消息的id
 */
@property (nonatomic, copy, nullable)NSString *withdrawMsgID;

/**
消息撤回后的提示,上行消息非必需
 */

@property (nonatomic, copy, nullable)NSString *withdrawNotice;



///////////////// 消息已读相关 ///////////////////
/**
 已读消息的id集合
 */
@property (nonatomic, copy, nullable)NSArray  *readMsgIDs;


/**
 消息发送如果有at的内容请设置设（at部分人还是全部群组成员）
 */
@property(nonatomic, readonly) PhotonIMAtType msgAtType;

/**
 at用户的id列表
 */
@property(nonatomic, readonly, copy) NSArray<NSString*> *msgAtList;

/**
 此是否前是否有历史消息存储在服务端
 */
@property(nonatomic, assign)BOOL remainHistory;

/**
 普通消息构造函数

 @param frid 消息从谁发出
 @param toid 消息发给谁
 @param messageType 消息类型
 @param chatType 所属会话类型
 @return 构建好的i消息对象
 */
+ (PhotonIMMessage *)commonMessageWithFrid:(NSString *)frid
                                toid:(NSString *)toid
                         messageType:(PhotonIMMessageType)messageType
                            chatType:(PhotonIMChatType)chatType;
/**
 设置消息体

 @param mesageBody <#mesageBody description#>
 */
- (void)setMesageBody:(PhotonIMBaseBody * _Nullable)mesageBody;

/**
 撤回消息构造函数
 
 @param msgID 被撤回消息的id
 @param frid 消息从谁发出
 @param toid 消息发给谁
 @param messageType 消息类型
 @param chatType 所属会话类型
 @return 构建好的i消息对象
 */
+ (PhotonIMMessage *)withDrawMessageWithMsgID:(NSString *)msgID
                                        frid:(NSString *)frid
                                toid:(NSString *)toid
                         messageType:(PhotonIMMessageType)messageType
                            chatType:(PhotonIMChatType)chatType;

/// 2.0及以上版本支持此功能
/// 设置at信息
/// @param sendAtType at类型
/// @param atList 存储at对象的id
- (void)setAtInfoWithAtType:(PhotonIMAtType)sendAtType
                     atList:(nullable NSArray<NSString *> *)atList;
@end

NS_ASSUME_NONNULL_END
