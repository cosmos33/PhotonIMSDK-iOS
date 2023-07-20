//
//  PhotonIMClient+ConversationManager.h
//  PhotonIMSDK
//
//  Created by Bruce on 2020/1/9.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotonIMClient.h"
NS_ASSUME_NONNULL_BEGIN


/// [ConversationManager](https://cosmos.immomo.com/cosmos_sdk_apidoc/imios/html/Classes/PhotonIMClient.html#//api/name/saveConversation:) 会话的管理，处理会话数据的数据库相关操作;
@interface PhotonIMClient (ConversationManager)
#pragma mark ------ 回话数据操作相关 --------

/**
 @brief 创建存储一个会话

 @param conversation <#conversation description#>
 */
- (void)saveConversation:(PhotonIMConversation *)conversation;


/**
 @brief 批量存储会话

 @param conversations <#conversations description#>
 */
- (void)saveConversationBatch:(NSArray<PhotonIMConversation *>*)conversations;

/**
 @brief 更新会话的免打扰设置

 @param conversation <#conversation description#>
 */
- (void)updateConversationIgnoreAlert:(PhotonIMConversation *)conversation DEPRECATED_MSG_ATTRIBUTE("Please use 'updateConversationIgnoreAlert:chatWith:ignoreAlert:' instead");

/**
 @brief 更新会话的免打扰设置
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
 @param ignoreAlert YES 设置打扰 NO 取消免打扰设置
 */
- (void)updateConversationIgnoreAlert:(PhotonIMChatType)chatType
                             chatWith:(NSString *)chatWith
                          ignoreAlert:(BOOL)ignoreAlert;


/**
 @brief 更新会话的置顶的设置
 
 @param conversation <#conversation description#>
 */
- (void)updateConversationSticky:(PhotonIMConversation *)conversation DEPRECATED_MSG_ATTRIBUTE("Please use 'updateConversationSticky:chatWith:sticky:' instead");

/**
 @brief 更新会话的置顶的设置
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
 @param sticky YES 设置置顶 NO 取消置顶
 */
- (void)updateConversationSticky:(PhotonIMChatType)chatType
                        chatWith:(NSString *)chatWith
                          sticky:(BOOL)sticky;

/**
 @brief 会话草稿

 @param conversation <#conversation description#>
 */
- (void)updateConversationDraft:(PhotonIMConversation *)conversation DEPRECATED_MSG_ATTRIBUTE("Please use 'alterConversationDraft:chatWith:draft:' instead");


/// @brief 添加会话的中草稿
/// @param chatType 会话类型
/// @param chatWith 会话中对方的id 群组为群组id
/// @param draft 草稿内容
- (void)addConversationDraft:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith draft:(nullable NSString *)draft;


/// @brief 修改会话的中草稿
/// @param chatType 会话类型
/// @param chatWith 会话中对方的id
/// @param draft 草稿内容
- (void)alterConversationDraft:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith draft:(nullable NSString *)draft;

/// @brief 添加会话的中的草稿
/// @param chatType 会话类型
/// @param chatWith 会话中对方的id 群组为群组id
- (void)deleteConversationDraft:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;

/**
 @brief 更新会话的额外信息

 @param conversation <#conversation description#>
 */
- (void)updateConversationExtra:(PhotonIMConversation *)conversation DEPRECATED_MSG_ATTRIBUTE("Please use 'updateConversationExtra:chatWith:extra:' instead");

/**
 @brief 更新会话的额外信息
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
 @param extra 额外信息
 */
- (void)updateConversationExtra:(PhotonIMChatType)chatType
                       chatWith:(NSString *)chatWith
                          extra:(NSDictionary *)extra;

/**
 @brief 更新会话的未读数
 
 @param conversation <#conversation description#>
 */
- (void)updateConversationUnReadCount:(PhotonIMConversation *)conversation DEPRECATED_MSG_ATTRIBUTE("Please use 'updateConversationUnReadCount:chatWith:count:' instead");


/**
 @brief 更新会话的未读数
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
 @param count 未读数
 */
- (void)updateConversationUnReadCount:(PhotonIMChatType)chatType
                             chatWith:(NSString *)chatWith
                                count:(NSInteger)count;

/**
 @brief 清空一个会话的未读数
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
 */
- (void)clearConversationUnReadCount:(PhotonIMChatType)chatType
                            chatWith:(NSString *)chatWith;

/**
 @brief 删除会话

 @param conversation 会话对象
 @param clearChatMessage 是否同时清空会话中的消息
 */
- (void)deleteConversation:(PhotonIMConversation *)conversation
          clearChatMessage:(BOOL)clearChatMessage DEPRECATED_MSG_ATTRIBUTE("Please use 'deleteConversation:chatWith:clearChatMessage:' instead");

/**
 @brief 删除会话

 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
 @param clearChatMessage 是否同时清空会话中的消息
 */
- (void)deleteConversation:(PhotonIMChatType)chatType
                  chatWith:(NSString *)chatWith
          clearChatMessage:(BOOL)clearChatMessage;

/**
 @brief 判断会话是否存在

 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
 @return YES 会话存在 NO 会话不存在
 */
- (BOOL)isConversationExist:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;

/**
 @brief 查找会话
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
 @return 会话对象
 */
- (nullable PhotonIMConversation *)findConversation:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;

/**
 @brief 查找会话
 @param start 开始查找的位置
 @param size 查找的个数
 @param asc 按升序还是降序查找 YES 是升序
 @return <#return value description#>
 */
- (NSArray<PhotonIMConversation *> *)findConversationList:(int)start size:(int)size asc:(BOOL)asc;

/**
@brief 查找会话
@param anchor 为chatWith,开始查找的位置，查找小于此锚点对应的排序id的数据，查找结果按降序排列
@param pageSize 每次查找的条数
@return 查找到的session列表
*/
- (NSArray<PhotonIMConversation *> *)findConversationList:(NSString *)anchor pageSize:(int)pageSize;


/**
@brief 查找会话
@param anchor 为chatWith,开始查找的位置，查找小于此锚点对应的排序id的数据，查找结果按降序排列
@param pageSize 每次查找的条数
@param completion finish表示列表拉取完成，netAnchor表示拉取下一页的锚点
@return 查找到的session列表
*/
- (NSArray<PhotonIMConversation *> *)findConversationList:(NSString *)anchor
                                                 pageSize:(int)pageSize
                                               completion:(nullable void(^)(BOOL finish, NSString * _Nullable netAnchor))completion;


/**
@brief 查找会话 符合Extra中key-value指定的会话
@param anchor 为chatWith,开始查找的位置，查找小于此锚点对应的排序id的数据，查找结果按降序排列
@param pageSize 每次查找的条数
@param key Extra指定的key
@param value Extra指定的key对应的value值。 注：key 或 value为空，查找结果忽略key-value限制
@return 查找到的session列表
*/
- (NSArray<PhotonIMConversation *> *)findConversationList:(NSString *)anchor
                                                 pageSize:(int)pageSize
                                                 extraKey:(NSString *)key
                                               extraValue:(NSString *)value;

/**
@brief 查找会话 符合Extra中key-value指定的会话
@param anchor 为chatWith,开始查找的位置，查找小于此锚点对应的排序id的数据，查找结果按降序排列
@param pageSize 每次查找的条数
@param key Extra指定的key
@param value Extra指定的key对应的value值。 注：key 或 value为空，查找结果忽略key-value限制
@param completion finish表示列表拉取完成，netAnchor表示拉取下一页的锚点
@return 查找到的session列表
*/
- (NSArray<PhotonIMConversation *> *)findConversationList:(NSString *)anchor
                                                 pageSize:(int)pageSize
                                                 extraKey:(NSString *)key
                                               extraValue:(NSString *)value
                                               completion:(nullable void(^)(BOOL finish, NSString * _Nullable netAnchor))completion;

/**
 @brief 判断会话是否存在
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
 @param arg 自定义消息中arg1参数
 */
- (void)updateConversationWithLastMsgArg1:(PhotonIMChatType)chatType
                                 chatWith:(NSString *)chatWith
                                      arg:(int)arg;

/**
 @brief 判断会话是否存在
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
 @param arg 自定义消息中arg2参数
 */
- (void)updateConversationWithLastMsgArg2:(PhotonIMChatType)chatType
                                 chatWith:(NSString *)chatWith
                                      arg:(int)arg;

/**
 @brief 给会话打标签
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
 @param arg 会话打标记使用的扩展字段arg1
 */
- (void)updateConversationWithCustomArg1:(PhotonIMChatType)chatType
                                chatWith:(NSString *)chatWith
                                     arg:(int)arg;

/**
 @brief 给会话打标签
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
 @param arg 会话打标记使用的扩展字段arg2
 */
- (void)updateConversationWithCustomArg2:(PhotonIMChatType)chatType
                                chatWith:(NSString *)chatWith
                                     arg:(int)arg;

/**
 @brief 根据自定义参数查找会话
 
 @param arg 会话打标记使用的扩展字段arg1
 @param asc 查询出的会话是否按时间降序排序
 */
- (NSArray<PhotonIMConversation *> *)findConversationListWithCustomArg1:(int)arg
                                                                    asc:(BOOL)asc;


/**
 @brief 根据自定义参数查找会话
 
 @param arg 会话打标记使用的扩展字段arg2
 @param asc 查询出的会话是否按时间降序排序
 */
- (NSArray<PhotonIMConversation *> *)findConversationListWithCustomArg2:(int)arg
                                                                    asc:(BOOL)asc;


/**
 @brief 判断会话是否存在
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
 @param atType 会话处于at的类型
 */
- (void)updateConversationAtType:(PhotonIMChatType)chatType
                        chatWith:(NSString *)chatWith
                          atType:(PhotonIMConversationAtType)atType;


/// @brief 设置会话中的消息为未读状态
/// @param chatType 会话类型
/// @param chatWith 会话中对方的id 群组为群组id
- (void)setConversationUnRead:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;


/// @brief 设置会话中的消息为已读状态
/// @param chatType 会话类型
/// @param chatWith 会话中对方的id 群组为群组id
- (void)setConversationRead:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;


/// @brief 获取会话的创建时间
/// @param chatType 会话类型
/// @param chatWith 会话中对方的id 群组为群组id
- (int64_t)findConversationCreateTime:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;


/// @brief 清空所有会话的未读数
/// @param result 清空成功（succeed:YES),失败（succeed:NO）
- (void)clearTotalUnreadCount:(void(^)(BOOL succeed))result;
@end

NS_ASSUME_NONNULL_END
