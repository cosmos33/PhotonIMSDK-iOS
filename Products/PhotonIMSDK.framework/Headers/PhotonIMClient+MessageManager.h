//
//  PhotonIMClient+MessageManager.h
//  PhotonIMSDK
//
//  Created by Bruce on 2020/1/9.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotonIMClient.h"
NS_ASSUME_NONNULL_BEGIN
/// [MessageManager](https://cosmos.immomo.com/cosmos_sdk_apidoc/imios/html/Classes/PhotonIMClient.html#//api/name/getAllUnreadCount) 消息的管理，处理消息数据的数据库相关操作;
@interface PhotonIMClient (MessageManager)


/// SDK默认不支持全文搜索功能，如果需要开启支持全文搜索功能，需要调用此方法。
- (void)supportFTS;
/**
 获取所有会话的消息未读的总和

 @return 未读数总和
 */
- (NSInteger)getAllUnreadCount;

/**
 判断消息是否在数据库中存储

 @param message 消息对象
 @return YES消息已存储在数据库中，NO消息未存储在数据库中
 */
- (BOOL)isMessageExist:(PhotonIMMessage *)message;

/**
 存储或者更新数据 如果数据不存在，则插入一条数据，数据存在则更新
@param message 消息对象
 */
- (void)saveOrUpdateMessage:(PhotonIMMessage *)message;

/**
 存储或者更新数据到数据库 如果数据不存在，则插入一条数据，数据存在则更新
@param message 消息对象
@param update 是否同时更新会话中的最后一条消息
 */
- (void)insertOrUpdateMessage:(PhotonIMMessage *)message
             updateConversion:(BOOL)update DEPRECATED_MSG_ATTRIBUTE("Please use 'saveOrUpdateMessage:' instead");

/**
 批量保存消息到数据库,如果数据存在于数据库中，则数据不重复保存

 @param chatType 查找的会话类型
 @param chatWith 会话中对方的id
 @param messageList 保存的消息列表，如果其中的消息已在表中，则不保存
 */
- (void)saveMessageBatch:(PhotonIMChatType)chatType
                chatWith:(NSString *)chatWith
             messageList:(NSArray<PhotonIMMessage *>*)messageList;

/**
批量保存消息到数据库,如果数据不存在，则插入操作，数据存在则更新

@param chatType 查找的会话类型
@param chatWith 会话中对方的id
@param messageList 保存的消息列表，如果其中的消息已在表中，则不保存
*/
- (void)saveOrUpdateMessageBatch:(PhotonIMChatType)chatType
                        chatWith:(NSString *)chatWith
                     messageList:(NSArray<PhotonIMMessage *> *)messageList;

/**
 更新消息状态
 使用场景: 只更新数据库中的消息状态时推荐调用
 @param message 消息对象
 */
- (void)updateMessageStatus:(PhotonIMMessage *)message;

/**
 更新消息状态
 使用场景: 只更新数据库中的消息文本内容时推荐调用
 @param message 消息对象
 */
- (void)updateMessageContent:(PhotonIMMessage *)message;

/**
 更新消息中多媒体的时长
 使用场景: 只更新数据库中的消息多媒体的时长时推荐调用
 @param message 消息对象
 */
- (void)updateMessageMediaTime:(PhotonIMMessage *)message;

/**
 更新消息中资源服务端地址
 使用场景: 只更新数据库中的消息资源服务端地址时推荐调用
 @param message 消息对象
 */
- (void)updateMessageFileUrl:(PhotonIMMessage *)message;

/**
 更新消息中资源本地地址
 使用场景: 只更新数据库中的消息资源本地地址时推荐调用
 @param message 消息对象
 */
- (void)updateMessageLocalFile:(PhotonIMMessage *)message;

/**
 更新消息中多媒体资源是否播放的状态
 使用场景: 只更新数据库中的消息多媒体资源是否播放的状态时推荐调用
 @param message 消息对象
 */
- (void)updateMessageLocalMediaPlayed:(PhotonIMMessage *)message;

/**
 更新消息中额外信息
 使用场景: 只更新数据库中的消息额外信息时推荐调用
 @param message 消息对象
 */
- (void)updateMessageExtra:(PhotonIMMessage *)message;

/**
 更新消息中自定义消息体
 使用场景: 只更新数据库中的消息自定义消息体时推荐调用
 @param message 消息对象
 */
- (void)updateMessageCustom:(PhotonIMMessage *)message;

/**
 删除消息
 
 @param message 消息对象
 */
- (void)deleteMessage:(PhotonIMMessage *)message;


/// 删除消息
/// @param chatType 消息类型
/// @param chatWith 会话id(会话中对方id) 群组为群组id
/// @param msgId 消息id
- (void)deleteMessageWithChatType:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith msgId:(NSString *)msgId;

/**
 清空指定会话下的所有消息
 
 @param conversation 会话对象
 */
- (void)clearMessagesWithConversation:(PhotonIMConversation *)conversation;

/**
 清空指定会话下的所有消息
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
 注:chatType 和 chatWith 二者确定会话的唯一性
 */
- (void)clearMessagesWithChatType:(PhotonIMChatType)chatType
                         chatWith:(NSString *)chatWith;

/**
 查找消息

 @param message 以此消息为锚点进行查询
 @param beforeAuthor 是否查找锚点之前的数据
 @param size 以锚点为中心，要查找的消息的个数
 @return <#return value description#>
 */
- (NSArray<PhotonIMMessage *> *)findMessageListByIdRange:(PhotonIMMessage *)message
                                            beforeAuthor:(BOOL)beforeAuthor
                                                     size:(int)size DEPRECATED_MSG_ATTRIBUTE("Please use 'loadHistoryMessages: chatWith: anchorMsgId: beforeAuthor: size:' instead");

/**
查找消息

@param chatType 查找的会话类型
@param chatWith 会话中对方的id 群组为群组id
@param msgId 消息id
@return <#return value description#>
*/
- (nullable PhotonIMMessage *)findMessage:(PhotonIMChatType)chatType
                        chatWith:(NSString *)chatWith
                           msgId:(NSString *)msgId;
/**
 查找消息

 @param chatType 查找的会话类型
 @param chatWith 会话中对方的id 群组为群组id
 @param anchorMsgId 锚点消息id （未有可为空）
 @param beforeAnchor 是否查找锚点之前的数据
 @param size 以锚点为中心，要查找的消息的个数
 @return <#return value description#>
 */
- (NSArray<PhotonIMMessage *> *)findMessageListByIdRange:(PhotonIMChatType)chatType
                                                chatWith:(NSString *)chatWith
                                             anchorMsgId:(nullable NSString *)anchorMsgId
                                            beforeAuthor:(BOOL)beforeAnchor
                                                    size:(int)size DEPRECATED_MSG_ATTRIBUTE("Please use 'loadHistoryMessages: chatWith: anchorMsgId: beforeAuthor: size:' instead");



/**
 按消息的状态查找数据
 @param msgStatus 消息的状态类型
 @return 返回符合查询条件的消息列表
 */
- (NSArray<PhotonIMMessage *> *)findMessagesByStatus:(PhotonIMMessageStatus)msgStatus;
/**
 获取用户数据库中所有正在发送的消息
 
 @return 返回符合查询条件的消息列表
 */
- (NSArray<PhotonIMMessage *> *)getAllSendingMessages;

/**
@brief 查找指定类型的消息的数量

@param chatType 查找的会话类型
@param chatWith 会话中对方的id 群组为群组id
@param messageTypeList PhotonIMMessageType的集合
@return 消息总数
*/
- (NSInteger)getMessageCountWithMsgType:(PhotonIMChatType)chatType
                               chatWith:(NSString *)chatWith
                            messageType:(nullable NSArray<NSNumber *>*)messageTypeList;

/**
@brief 查找指定类型且指定时间内的消息的数量 （注：此方法可设置要拉取的时间范围（beginTimeStamp<endTime且 endTime<0），如果设置的时间范围不合法，则默认依次拉取所有的消息）
@param chatType 查找的会话类型
@param chatWith 会话中对方的id 群组为群组id
@param messageTypeList PhotonIMMessageType的集合
@param beginTimeStamp 消息的起始拉取时间，比如7天前
@param endTime 消息的结束拉取时间，比如当前时间
@return 消息总数
*/
- (NSInteger)getMessageCountWithMsgType:(PhotonIMChatType)chatType
                               chatWith:(NSString *)chatWith
                            messageType:(nullable NSArray<NSNumber *>*)messageTypeList
                         beginTimeStamp:(NSTimeInterval)beginTimeStamp
                                endTime:(NSTimeInterval)endTime;


/// 查找指定参数的消息的数量
/// @param chatType 查找的会话类型
/// @param chatWith 会话中对方的id 群组为群组id
/// @param queryParameter 参数对象
- (NSInteger)getMessageCountByParamter:(PhotonIMChatType)chatType
                              chatWith:(NSString *)chatWith
                        queryParameter:(nullable PhotonIMMessageQueryPara *)queryParameter;



#pragma mark ---- Find Message List----
/**
@brief 加载会话中的所有消息，支持按锚点向前或向后查找

@param chatType 查找的会话类型
@param chatWith 会话中对方的id 群组为群组id
@param anchor 锚点消息id,未有可为空
@param beforeAnchor 查找的数据为锚点之前之后的数据，YES为查找锚点之前的数据（即早于锚点消息的数据） NO为查找锚点之后的数据（即晚于于锚点消息的数据）
@param size 以锚点为中心，要查找的消息的个数
@return PhotonIMMessage 对象列表
*/
- (NSArray<PhotonIMMessage *> *)loadHistoryMessages:(PhotonIMChatType)chatType
                                           chatWith:(NSString *)chatWith
                                        anchorMsgId:(nullable NSString *)anchor
                                       beforeAuthor:(BOOL)beforeAnchor
                                               size:(int)size;

/**
 @brief 加载会话中的所有消息，指定按锚点向前查找

 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
 @param anchor 开始一次查询的锚点 锚点取消息id(msgID)
 @param size 每次查询的条数
 @param result 回调的数据结构是查询到数据对象（message对象集合，锚点,和指定同步此处的消息之后是否开始拉取服务端的消息）
 */
- (void)loadHistoryMessages:(PhotonIMChatType)chatType
                   chatWith:(NSString *)chatWith
                     anchorMsgId:(nullable NSString *)anchor
                       size:(int)size
                reaultBlock:(void(^)(NSArray<PhotonIMMessage *> * _Nullable,NSString * _Nullable,BOOL))result;


/**
@brief 查找符合Extra中key-value的会话消息加，支持按锚点向前或向后查找

@param chatType 查找的会话类型
@param chatWith 会话中对方的id 群组为群组id
@param anchor 锚点消息id,未有可为空 当beforeAnchor==YES时，取查询结果list的第一个元素消息（firstObject）的消息id作为锚点。当beforeAnchor==NO时，取查询结果list的最后一个元素消息（lastObject）的消息id作为锚点。
@param beforeAnchor 查找的数据为锚点之前之后的数据，YES为查找锚点之前的数据（即早于锚点消息的数据） NO为查找锚点之后的数据（即晚于于锚点消息的数据）
@param key Extra指定的key
@param value Extra指定的key对应的value值。
@param size 以锚点为中心，要查找的消息的个数
@return PhotonIMMessage 对象列表
*/
- (NSArray<PhotonIMMessage *> *)loadHistoryMessages:(PhotonIMChatType)chatType
                                           chatWith:(NSString *)chatWith
                                        anchorMsgId:(nullable NSString *)anchor
                                       beforeAuthor:(BOOL)beforeAnchor
                                           extraKey:(NSString *)key
                                         extraValue:(NSString *)value
                                               size:(int)size;

/**
 @brief 查找符合Extra中key-value的会话消息加，指定按锚点向前查找

 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
 @param anchor 开始一次查询的锚点 锚点取消息id(msgID)
 @param key Extra指定的key
 @param value Extra指定的key对应的value值。 注：key 或 value为空，查找结果忽略key-value限制
 @param size 每次查询的条数
 @param result 回调的数据结构是查询到数据对象（message对象集合，锚点,和指定同步此处的消息之后是否开始拉取服务端的消息）
 */
- (void)loadHistoryMessages:(PhotonIMChatType)chatType
                   chatWith:(NSString *)chatWith
                     anchorMsgId:(nullable NSString *)anchor
                   extraKey:(NSString *)key
                 extraValue:(NSString *)value
                       size:(int)size
                reaultBlock:(void(^)(NSArray<PhotonIMMessage *> * _Nullable,NSString * _Nullable))result;

/**
@brief 加载会话中指定消息类型的所有消息，支持按锚点向前或向后查找

@param chatType 查找的会话类型
@param chatWith 会话中对方的id 群组为群组id
 @param messageTypeList PhotonIMMessageType的集合
@param anchor 开始一次查询的锚点 锚点取消息id(msgID) 当beforeAnchor==YES时，取查询结果list的第一个元素消息（firstObject）的消息id作为锚点。当beforeAnchor==NO时，取查询结果list的最后一个元素消息（lastObject）的消息id作为锚点。
@param beforeAnchor 查找的数据为锚点之前之后的数据，YES为查找锚点之前的数据（即早于锚点消息的数据） NO为查找锚点之后的数据（即晚于于锚点消息的数据）
@param size 以锚点为中心，要查找的消息的个数
@return PhotonIMMessage 对象列表
*/
- (NSArray<PhotonIMMessage *> *)loadHistoryMessages:(PhotonIMChatType)chatType
                                           chatWith:(NSString *)chatWith
                                    messageTypeList:(nullable NSArray<NSNumber *>*)messageTypeList
                                        anchorMsgId:(nullable NSString *)anchor
                                       beforeAuthor:(BOOL)beforeAnchor
                                               size:(int)size;

/**
 @brief 加载会话中指定消息类型的所有消息，指定按锚点向前查找

 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
 @param messageTypeList PhotonIMMessageType的集合
 @param anchor 开始一次查询的锚点 锚点取消息id(msgID)
 @param size 每次查询的条数
 @param result 回调的数据结构是查询到数据对象（message对象集合，锚点,和指定同步此处的消息之后是否开始拉取服务端的消息）
 */
- (void)loadHistoryMessages:(PhotonIMChatType)chatType
                   chatWith:(NSString *)chatWith
            messageTypeList:(nullable NSArray<NSNumber *>*)messageTypeList
                     anchorMsgId:(nullable NSString *)anchor
                       size:(int)size
                reaultBlock:(void(^)(NSArray<PhotonIMMessage *> * _Nullable,NSString * _Nullable))result;



/// @brief 加载指定时间范围的会话消息（仅同步本地数据库）此方法指定查找锚点值之前的数,此方法可设置要拉取的时间范围（beginTimeStamp<endTime且 endTime<0），如果设置的时间范围不合法，则默认依次拉取所有的消息
/// @param chatType 会话类型
/// @param chatWith 会话中对方的id 群组为群组id
/// @param anchor 开始一次查询的锚点 锚点取消息id(msgID)
/// @param beginTimeStamp 消息的起始拉取时间，比如7天前
/// @param endTime 消息的结束拉取时间，比如当前时间
/// @param size 每次拉去的条数
/// @param result 回调的结果（message对象集合，锚点,和指定同步此处的消息之后是否开始拉取服务端的消息）
- (void)loadHistoryMessages:(PhotonIMChatType)chatType
                   chatWith:(NSString *)chatWith
                anchorMsgId:(nullable NSString *)anchor
             beginTimeStamp:(NSTimeInterval)beginTimeStamp
                    endTime:(NSTimeInterval)endTime
                       size:(int)size
                reaultBlock:(void(^)(NSArray<PhotonIMMessage *> * _Nullable,NSString * _Nullable))result;

/// @brief 加载指定时间范围的会话消息（仅同步本地数据库），支持按锚点向前或向后查找,此方法可设置要拉取的时间范围（beginTimeStamp<endTime且 endTime<0），如果设置的时间范围不合法，则默认依次拉取所有的消息。可按锚点拉取新旧消息
/// @param chatType 会话类型
/// @param chatWith 会话中对方的id 群组为群组id
/// @param anchor 开始一次查询的锚点 锚点取消息id(msgID) 当beforeAnchor==YES时，取查询结果list的第一个元素消息（firstObject）的消息id作为锚点。当beforeAnchor==NO时，取查询结果list的最后一个元素消息（lastObject）的消息id作为锚点。
/// @param beginTimeStamp 消息的起始拉取时间，比如7天前
/// @param endTime 消息的结束拉取时间，比如当前时间
/// @param beforeAnchor 查找的数据为锚点之前之后的数据，YES为查找锚点之前的数据（即早于锚点消息的数据）NO为查找锚点之后的数据（即晚于于锚点消息的数据）
/// @param size 每次拉去的条数
/// @return PhotonIMMessage 对象列表
- (NSArray<PhotonIMMessage *> *)loadHistoryMessages:(PhotonIMChatType)chatType
                   chatWith:(NSString *)chatWith
                anchorMsgId:(nullable NSString *)anchor
             beginTimeStamp:(NSTimeInterval)beginTimeStamp
                    endTime:(NSTimeInterval)endTime
               beforeAuthor:(BOOL)beforeAnchor
                       size:(int)size;


/// @brief  加载指定消息类型和指定时间范围的会话消息（仅同步本地数据库）此方法指定查找锚点值之前的数据,此方法可设置要拉取的时间范围（beginTimeStamp<endTime且 endTime<0），如果设置的时间范围不合法，则默认依次拉取所有的消息
/// @param chatType 会话类型
/// @param chatWith 会话中对方的id 群组为群组id
/// @param messageTypeList PhotonIMMessageType的集合
/// @param anchor 开始一次查询的锚点 锚点取消息id(msgID)
/// @param beginTimeStamp 消息的起始拉取时间，比如7天前
/// @param endTime 消息的结束拉取时间，比如当前时间
/// @param size 每次拉去的条数
/// @param result 回调的结果（message对象集合，锚点,和指定同步此处的消息之后是否开始拉取服务端的消息）
- (void)loadHistoryMessages:(PhotonIMChatType)chatType
                   chatWith:(NSString *)chatWith
                messageTypeList:(nullable NSArray<NSNumber *>*)messageTypeList
                anchorMsgId:(nullable NSString *)anchor
             beginTimeStamp:(NSTimeInterval)beginTimeStamp
                    endTime:(NSTimeInterval)endTime
                       size:(int)size
                reaultBlock:(void(^)(NSArray<PhotonIMMessage *> * _Nullable,NSString * _Nullable))result;


/// @brief 加载指定消息类型和指定时间范围的会话消息（仅同步本地数据库），支持按锚点向前或向后查找,此方法可设置要拉取的时间范围（beginTimeStamp<endTime且 endTime<0），如果设置的时间范围不合法，则默认依次拉取所有的消息，可按锚点拉取新旧消息
/// @param chatType 会话类型
/// @param chatWith 会话中对方的id 群组为群组id
/// @param messageTypeList PhotonIMMessageType的集合
/// @param anchor 开始一次查询的锚点 锚点取消息id(msgID) 当beforeAnchor==YES时，取查询结果list的第一个元素消息（firstObject）的消息id作为锚点。当beforeAnchor==NO时，取查询结果list的最后一个元素消息（lastObject）的消息id作为锚点。
/// @param beginTimeStamp 消息的起始拉取时间，比如7天前
/// @param endTime 消息的结束拉取时间，比如当前时间
/// @param beforeAnchor 查找的数据为锚点之前之后的数据，YES为查找锚点之前的数据（即早于锚点消息的数据）NO为查找锚点之后的数据（即晚于于锚点消息的数据）
/// @param size 每次拉去的条数
/// @return PhotonIMMessage 对象列表
- (NSArray<PhotonIMMessage *> *)loadHistoryMessages:(PhotonIMChatType)chatType
                   chatWith:(NSString *)chatWith
            messageTypeList:(nullable NSArray<NSNumber *>*)messageTypeList
                anchorMsgId:(nullable NSString *)anchor
             beginTimeStamp:(NSTimeInterval)beginTimeStamp
                    endTime:(NSTimeInterval)endTime
               beforeAuthor:(BOOL)beforeAnchor
                       size:(int)size;


/// @brief  加载指定消息类型、指定时间范围以及查找符合扩展Extra中key-value值的会话消息（仅同步本地数据库）此方法指定查找锚点值之前的数据,此方法可设置要拉取的时间范围（beginTimeStamp<endTime且 endTime<0），如果设置的时间范围不合法，则默认依次拉取所有的消息
/// @param chatType 会话类型
/// @param chatWith 会话中对方的id 群组为群组id
/// @param messageTypeList PhotonIMMessageType的集合，为空查找所有类型消息
/// @param anchor 开始一次查询的锚点 锚点取消息id(msgID) 
/// @param beginTimeStamp 消息的起始拉取时间，比如7天前
/// @param endTime 消息的结束拉取时间，比如当前时间
/// @param key Extra指定的key
/// @param value Extra指定的key对应的value值。 注：key 或 value为空，查找结果忽略key-value限制
/// @param size 每次拉去的条数
/// @param result 回调的结果（message对象集合，锚点,和指定同步此处的消息之后是否开始拉取服务端的消息）
- (void)loadHistoryMessages:(PhotonIMChatType)chatType
                   chatWith:(NSString *)chatWith
                messageTypeList:(nullable NSArray<NSNumber *>*)messageTypeList
                anchorMsgId:(nullable NSString *)anchor
             beginTimeStamp:(NSTimeInterval)beginTimeStamp
                    endTime:(NSTimeInterval)endTime
                   extraKey:(nullable NSString *)key
                   extraValue:(nullable NSString *)value
                       size:(int)size
                reaultBlock:(void(^)(NSArray<PhotonIMMessage *> * _Nullable,NSString * _Nullable))result;



/// @brief 加载指定消息类型、指定时间范围以及查找符合Extra中key-value的会话消息（仅同步本地数据库），支持按锚点向前或向后查找,此方法可设置要拉取的时间范围（beginTimeStamp<endTime且 endTime<0），如果设置的时间范围不合法，则默认依次拉取所有的消息，可按锚点拉取新旧消息
/// @param chatType 会话类型
/// @param chatWith 会话中对方的id 群组为群组id
/// @param messageTypeList PhotonIMMessageType的集合，为空查找所有类型消息
/// @param anchor 开始一次查询的锚点 锚点取消息id(msgID) 当beforeAnchor==YES时，取查询结果list的第一个元素消息（firstObject）的消息id作为锚点。当beforeAnchor==NO时，取查询结果list的最后一个元素消息（lastObject）的消息id作为锚点。
/// @param beginTimeStamp 消息的起始拉取时间，比如7天前
/// @param endTime 消息的结束拉取时间，比如当前时间。注:如果设置的时间范围不合法，则默认依次拉取所有的消息，可按锚点拉取新旧消息
/// @param key Extra指定的key
/// @param value Extra指定的key对应的value值。 注：key 或 value为空，查找结果忽略key-value限制
/// @param beforeAnchor 查找的数据为锚点之前之后的数据，YES为查找锚点之前的数据（即早于锚点消息的数据）NO为查找锚点之后的数据（即晚于于锚点消息的数据）
/// @param size 每次拉去的条数
/// @return PhotonIMMessage 对象列表
- (NSArray<PhotonIMMessage *> *)loadHistoryMessages:(PhotonIMChatType)chatType
                                           chatWith:(NSString *)chatWith
                                    messageTypeList:(nullable NSArray<NSNumber *>*)messageTypeList
                                        anchorMsgId:(nullable NSString *)anchor
                                     beginTimeStamp:(NSTimeInterval)beginTimeStamp
                                            endTime:(NSTimeInterval)endTime
                                       beforeAuthor:(BOOL)beforeAnchor
                                           extraKey:(nullable NSString *)key
                                         extraValue:(nullable NSString *)value
                                               size:(int)size;

/// 加载历史消息
/// @param chatType 会话类型
/// @param chatWith 会话中对方的id 群组为群组id
/// @param queryParameter 加载时的具体参数，详情请查看：PhotonIMMessageQueryPara
- (NSArray<PhotonIMMessage *> *)loadHistoryMessages:(PhotonIMChatType)chatType
                                           chatWith:(NSString *)chatWith
                                     queryParameter:(nullable PhotonIMMessageQueryPara *)queryParameter;


#pragma mark --- fts -----
/**
 @brief 同步服务端上的历史数据

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
 @brief 同步服务端上的历史数据

 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @param anchor 开始一次查询的锚点，在固定的时间段内查找数据，是有锚点进行查找类似下一页的操作，锚点在回调中返回，请求下一页是直接使用
 @param size 每次查询的条数
 @param beginTimeStamp 开始查找的时间时间戳，毫秒级（比如查询9点-11点之间的数据，beginTimeStamp指的是9点的那个时间点）
 @param endTimeStamp 结束查找的时间时间戳，毫秒级（比如查询9点-11点之间的数据，beginTimeStamp指的是11点的那个时间点）
 @param result 回调的数据结构是查询到数据对象
 */
- (void)syncHistoryMessagesFromServer:(PhotonIMChatType)chatType
                             chatWith:(NSString *)chatWith
                               anchor:(nullable NSString *)anchor
                                 size:(int)size
                       beginTimeStamp:(int64_t)beginTimeStamp
                         endTimeStamp:(int64_t)endTimeStamp
                          reaultBlock:(void (^)(NSArray<PhotonIMMessage *> * _Nullable messageList,
                                                NSString * _Nullable anchor,
                                                BOOL haveNext,
                                                NSError * _Nullable error))result;

/// @brief 全文搜索（获取所有包含查询结果的会话，每个会话中包含针对此会话查询结果的条数，在ftsResultCount此属性获取）
/// @param matchQuery 搜索关键词
/// @param startIdentifier 开始标签，比如 @"<a>"
/// @param endIdentifier 结束标签，比如 @"</a>"
/// @param maxCharacterLenth 显示的最大字符数
/// @param pageSize 只查找指定数量，其他忽略。建议全查pagesize
- (NSArray<PhotonIMConversation *> *)SearchFtsSessionsWithMatchQuery:(NSString *)matchQuery
                                                     startIdentifier:(NSString *)startIdentifier
                                                       endIdentifier:(NSString *)endIdentifier
                                                   maxCharacterLenth:(NSInteger)maxCharacterLenth
                                                            pageSize:(int)pageSize;
/// @brief 全文搜索（所有会话消息）
/// @param matchQuery 搜索关键词
/// @param startIdentifier 开始标签，比如 @"<a>"
/// @param endIdentifier 结束标签，比如 @"</a>"
/// @param maxCharacterLenth 显示的最大字符数
- (NSArray<PhotonIMMessage *> *)searchMessagesWithMatchQuery:(NSString *)matchQuery
                                           startIdentifier:(NSString *)startIdentifier
                                             endIdentifier:(NSString *)endIdentifier maxCharacterLenth:(NSInteger)maxCharacterLenth DEPRECATED_MSG_ATTRIBUTE("Please use 'searchMessagesWithMatchQuery: startIdentifier: endIdentifier: maxCharacterLenth: anchor: pageSize:' instead");;

/// @brief 全文搜索（所有会话消息）,支持分页
/// @param matchQuery 搜索关键词
/// @param startIdentifier 开始标签，比如 @"<a>"
/// @param endIdentifier 结束标签，比如 @"</a>"
/// @param maxCharacterLenth 显示的最大字符数
/// @param anchor 锚点 消息id
/// @param pageSize 每页显示条数
- (NSArray<PhotonIMMessage *> *)searchMessagesWithMatchQuery:(NSString *)matchQuery
                                             startIdentifier:(NSString *)startIdentifier
                                               endIdentifier:(NSString *)endIdentifier
                                           maxCharacterLenth:(NSInteger)maxCharacterLenth
                                                      anchor:(nullable NSString *)anchor
                                                    pageSize:(int)pageSize;

/// @brief 全文搜索 （不支持支持分页）
/// @param chatType 会话类型
/// @param chatWith 会话中对方的id
/// @param startIdentifier 开始标签，比如 @"<a>"
/// @param endIdentifier 结束标签，比如 @"</a>"
/// @param maxCharacterLenth 显示的最大字符数
/// @param matchQuery 搜索关键词
- (NSArray<PhotonIMMessage *> *)searchMessagesWithChatType:(PhotonIMChatType)chatType
                                                chatWith:(NSString *)chatWith
                                         startIdentifier:(NSString *)startIdentifier
                                           endIdentifier:(NSString *)endIdentifier
                                       maxCharacterLenth:(NSInteger)maxCharacterLenth
                                              matchQuery:(NSString *)matchQuery;


/// @brief 全文搜索 （支持分页）
/// @param chatType 会话类型
/// @param chatWith 会话中对方的id
/// @param startIdentifier 开始标签，比如 @"<a>"
/// @param endIdentifier 结束标签，比如 @"</a>"
/// @param maxCharacterLenth 显示的最大字符数
/// @param matchQuery 搜索关键词
/// @param anchor 锚点，消息id
/// @param pageSize 每页显示条数
- (NSArray<PhotonIMMessage *> *)searchMessagesWithChatType:(PhotonIMChatType)chatType
                                                  chatWith:(NSString *)chatWith
                                           startIdentifier:(NSString *)startIdentifier
                                             endIdentifier:(NSString *)endIdentifier
                                         maxCharacterLenth:(NSInteger)maxCharacterLenth
                                                matchQuery:(NSString *)matchQuery
                                                    anchor:(nullable NSString *)anchor
                                                  pageSize:(int)pageSize;
@end

NS_ASSUME_NONNULL_END
