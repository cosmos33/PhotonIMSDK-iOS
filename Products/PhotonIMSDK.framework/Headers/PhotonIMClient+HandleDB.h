//
//  PhotonIMClient+HandleDB.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/19.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonIMClient.h"
NS_ASSUME_NONNULL_BEGIN

@interface PhotonIMClient(HandleDB)


/**
 获取总的未读数

 @return <#return value description#>
 */
- (NSInteger)getAllUnreadCount;


/**
 判断消息是否在数据库中存储

 @param message <#message description#>
 @return <#return value description#>
 */
- (BOOL)isMessageExist:(PhotonIMMessage *)message;

/**
 存储或者更新数据 如果数据不存在，则插入一条数据，数据存在则更新
 @param update 是否同时更新会话中的最后一条消息
 @param message <#message description#>
 */
- (void)insertOrUpdateMessage:(PhotonIMMessage *)message
             updateConversion:(BOOL)update;


/**
 批量保存消息到数据库

 @param chatType 查找的会话类型
 @param chatWith 会话中对方的id
 @param messageList 保存的消息列表，如果其中的消息已在表中，则不保存
 */
- (void)saveMessageBatch:(PhotonIMChatType)chatType
                chatWith:(NSString *)chatWith
             messageList:(NSArray<PhotonIMMessage *>*)messageList;

/**
 更新消息状态
 使用场景: 只更新数据库中的消息状态时推荐调用
 @param message <#message description#>
 */
- (void)updateMessageStatus:(PhotonIMMessage *)message;

/**
 更新消息状态
 使用场景: 只更新数据库中的消息文本内容时推荐调用
 @param message <#message description#>
 */
- (void)updateMessageContent:(PhotonIMMessage *)message;

/**
 更新消息中多媒体的时长
 使用场景: 只更新数据库中的消息多媒体的时长时推荐调用
 @param message <#message description#>
 */
- (void)updateMessageMediaTime:(PhotonIMMessage *)message;

/**
 更新消息中资源服务端地址
 使用场景: 只更新数据库中的消息资源服务端地址时推荐调用
 @param message <#message description#>
 */
- (void)updateMessageFileUrl:(PhotonIMMessage *)message;

/**
 更新消息中资源本地地址
 使用场景: 只更新数据库中的消息资源本地地址时推荐调用
 @param message <#message description#>
 */
- (void)updateMessageLocalFile:(PhotonIMMessage *)message;

/**
 更新消息中多媒体资源是否播放的状态
 使用场景: 只更新数据库中的消息多媒体资源是否播放的状态时推荐调用
 @param message <#message description#>
 */
- (void)updateMessageLocalMediaPlayed:(PhotonIMMessage *)message;

/**
 更新消息中额外信息
 使用场景: 只更新数据库中的消息额外信息时推荐调用
 @param message <#message description#>
 */
- (void)updateMessageExtra:(PhotonIMMessage *)message;

/**
 更新消息中自定义消息体
 使用场景: 只更新数据库中的消息自定义消息体时推荐调用
 @param message <#message description#>
 */
- (void)updateMessageCustom:(PhotonIMMessage *)message;


/**
 删除消息
 
 @param message <#message description#>
 */
- (void)deleteMessage:(PhotonIMMessage *)message;


/**
 清空指定会话下的所有消息
 
 @param conversation 会话对象
 */
- (void)clearMessagesWithConversation:(PhotonIMConversation *)conversation;

/**
 清空指定会话下的所有消息
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id
 注:chatType 和 chatWith 二者确定会话的唯一性
 */
- (void)clearMessagesWithChatType:(PhotonIMChatType)chatType
                         chatWith:(NSString *)chatWith;

/**
 查找消息

 @param message 以此消息为锚点进行查询
 @param beforeAuthor 是否查找锚点之前的数据
 @param asc 是否为升序
 @param size 以锚点为中心，要查找的消息的个数
 @return <#return value description#>
 */
- (NSArray<PhotonIMMessage *> *)findMessageListByIdRange:(PhotonIMMessage *)message
                                            beforeAuthor:(BOOL)beforeAuthor
                                                     asc:(BOOL)asc size:(int)size;

/**
查找消息

@param chatType 查找的会话类型
@param chatWith 会话中对方的id
@param msgId 消息id 
@return <#return value description#>
*/
- (PhotonIMMessage *)findMessage:(PhotonIMChatType)chatType
                        chatWith:(NSString *)chatWith
                           msgId:(nullable NSString *)msgId;
/**
 查找消息

 @param chatType 查找的会话类型
 @param chatWith 会话中对方的id
 @param anchorMsgId 锚点消息id （未有可为空）
 @param beforeAnchor 是否查找锚点之前的数据
 @param asc 是否为升序
 @param size 以锚点为中心，要查找的消息的个数
 @return <#return value description#>
 */
- (NSArray<PhotonIMMessage *> *)findMessageListByIdRange:(PhotonIMChatType)chatType
                                                chatWith:(NSString *)chatWith
                                             anchorMsgId:(nullable NSString *)anchorMsgId
                                            beforeAuthor:(BOOL)beforeAnchor
                                                     asc:(BOOL)asc size:(int)size;

/**
 按消息的状态查找数据
 
 @return <#return value description#>
 */
- (NSArray<PhotonIMMessage *> *)findMessagesByStatus:(PhotonIMMessageStatus)msgStatus;
/**
 获取用户数据库中所有正在发送的消息
 
 @return <#return value description#>
 */
- (NSArray<PhotonIMMessage *> *)getAllSendingMessages;


#pragma mark ------ 回话数据操作相关 --------

/**
 创建存储一个会话

 @param conversation <#conversation description#>
 */
- (void)saveConversation:(PhotonIMConversation *)conversation;


/**
 批量存储会话

 @param conversations <#conversations description#>
 */
- (void)saveConversationBatch:(NSArray<PhotonIMConversation *>*)conversations;

/**
  更新会话的免打扰设置

 @param conversation <#conversation description#>
 */
- (void)updateConversationIgnoreAlert:(PhotonIMConversation *)conversation;

/**
 更新会话的免打扰设置
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @param ignoreAlert YES 设置打扰 NO 取消免打扰设置
 */
- (void)updateConversationIgnoreAlert:(PhotonIMChatType)chatType
                             chatWith:(NSString *)chatWith
                          ignoreAlert:(BOOL)ignoreAlert;


/**
  更新会话的置顶的设置
 
 @param conversation <#conversation description#>
 */
- (void)updateConversationSticky:(PhotonIMConversation *)conversation;

/**
 更新会话的置顶的设置
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @param sticky YES 设置置顶 NO 取消置顶
 */
- (void)updateConversationSticky:(PhotonIMChatType)chatType
                        chatWith:(NSString *)chatWith
                          sticky:(BOOL)sticky;

/**
 会话草稿

 @param conversation <#conversation description#>
 */
- (void)updateConversationDraft:(PhotonIMConversation *)conversation;

/**
 更新会话的额外信息

 @param conversation <#conversation description#>
 */
- (void)updateConversationExtra:(PhotonIMConversation *)conversation;

/**
 更新会话的额外信息
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @param extra 额外信息
 */
- (void)updateConversationExtra:(PhotonIMChatType)chatType
                       chatWith:(NSString *)chatWith
                          extra:(NSDictionary *)extra;

/**
 更新会话的未读数
 
 @param conversation <#conversation description#>
 */
- (void)updateConversationUnReadCount:(PhotonIMConversation *)conversation;


/**
 更新会话的未读数
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @param count 未读数
 */
- (void)updateConversationUnReadCount:(PhotonIMChatType)chatType
                             chatWith:(NSString *)chatWith
                                count:(NSInteger)count;

/**
 清空一个会话的未读数
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id
 */
- (void)clearConversationUnReadCount:(PhotonIMChatType)chatType
                            chatWith:(NSString *)chatWith;

/**
 删除会话

 @param conversation 会话对象
 @param clearChatMessage 是否同时清空会话中的消息
 */
- (void)deleteConversation:(PhotonIMConversation *)conversation
          clearChatMessage:(BOOL)clearChatMessage;

/**
 删除会话

 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @param clearChatMessage 是否同时清空会话中的消息
 */
- (void)deleteConversation:(PhotonIMChatType)chatType
                  chatWith:(NSString *)chatWith
          clearChatMessage:(BOOL)clearChatMessage;

/**
 判断会话是否存在

 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @return YES 会话存在 NO 会话不存在
 */
- (BOOL)isConversationExist:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;

/**
 查找会话
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @return 会话对象
 */
- (PhotonIMConversation *)findConversation:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;
/**
 查找会话
 @param start 开始查找的位置
 @param size 查找的个数
 @param asc 按升序还是降序查找 YES 是升序
 @return <#return value description#>
 */
- (NSArray<PhotonIMConversation *> *)findConversationList:(int)start size:(int)size asc:(BOOL)asc;



/**
 判断会话是否存在
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @param arg 自定义消息中arg1参数
 */
- (void)updateConversationWithLastMsgArg1:(PhotonIMChatType)chatType
                                 chatWith:(NSString *)chatWith
                                      arg:(int)arg;

/**
 判断会话是否存在
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @param arg 自定义消息中arg2参数
 */
- (void)updateConversationWithLastMsgArg2:(PhotonIMChatType)chatType
                                 chatWith:(NSString *)chatWith
                                      arg:(int)arg;

/**
 判断会话是否存在
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @param arg 会话打标记使用的扩展字段
 */
- (void)updateConversationWithCustomArg1:(PhotonIMChatType)chatType
                                chatWith:(NSString *)chatWith
                                     arg:(int)arg;

/**
 判断会话是否存在
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @param arg 会话打标记使用的扩展字段
 */
- (void)updateConversationWithCustomArg2:(PhotonIMChatType)chatType
                                chatWith:(NSString *)chatWith
                                     arg:(int)arg;

/**
 判断会话是否存在
 
 @param arg 根据会话打的标记查询会话
 @param asc 查询出的会话是否按时间降序排序
 */
- (NSArray<PhotonIMConversation *> *)findConversationListWithCustomArg1:(int)arg
                                                                    asc:(BOOL)asc;


/**
 判断会话是否存在
 
 @param arg 根据会话打的标记查询会话
 @param asc 查询出的会话是否按时间降序排序
 */
- (NSArray<PhotonIMConversation *> *)findConversationListWithCustomArg2:(int)arg
                                                                    asc:(BOOL)asc;


/**
 判断会话是否存在
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @param atType 会话处于at的类型
 */
- (void)updateConversationAtType:(PhotonIMChatType)chatType
                        chatWith:(NSString *)chatWith
                          atType:(PhotonIMConversationAtType)atType;

/**
 下拉获取加载更多的会话消息（仅同步本地数据库）

 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @param anchor 开始一次查询的锚点
 @param size 每次查询的条数
 @param result 回调的数据结构是查询到数据对象
 */
- (void)loadHistoryMessages:(PhotonIMChatType)chatType
                   chatWith:(NSString *)chatWith
                     anchor:(nullable NSString *)anchor
                       size:(int)size
                reaultBlock:(void(^)(NSArray<PhotonIMMessage *> * _Nullable,NSString * _Nullable,BOOL))result;



/**
 同步服务端上的历史数据

 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @param size 每次查询的条数
 @param beginTimeStamp 开始查找的时间时间戳，毫秒级（比如查询9点-11点之间的数据，beginTimeStamp指的是9点的那个时间点）
 @param result 回调的数据结构是查询到数据对象
 */
- (void)syncHistoryMessagesFromServer:(PhotonIMChatType)chatType
                             chatWith:(NSString *)chatWith
                                 size:(int)size
                       beginTimeStamp:(int64_t)beginTimeStamp
                          reaultBlock:(void (^)(NSArray<PhotonIMMessage *> * _Nullable messageList,NSString * _Nullable anchor, NSError * _Nullable error))result;



/**
 同步服务端上的历史数据

 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @param anchor 开始一次查询的锚点，在固定的时间段内查找数据，是有锚点进行查找类似下一页的操作，锚点在回调中返回，请求下一页是直接使用
 @param size 每次查询的条数
 @param beginTimeStamp 开始查找的时间时间戳，毫秒级（比如查询9点-11点之间的数据，beginTimeStamp指的是9点的那个时间点）
 @param endTimeStamp 结束查找的时间时间戳，毫秒级（比如查询9点-11点之间的数据，beginTimeStamp指的是11点的那个时间点）
 @param result
 */
- (void)syncHistoryMessagesFromServer:(PhotonIMChatType)chatType
                             chatWith:(NSString *)chatWith
                               anchor:(nullable NSString *)anchor
                                 size:(int)size beginTimeStamp:(int64_t)beginTimeStamp
                         endTimeStamp:(int64_t)endTimeStamp
                          reaultBlock:(void (^)(NSArray<PhotonIMMessage *> * _Nullable messageList,NSString * _Nullable anchor, NSError * _Nullable error))result;

@end

NS_ASSUME_NONNULL_END
