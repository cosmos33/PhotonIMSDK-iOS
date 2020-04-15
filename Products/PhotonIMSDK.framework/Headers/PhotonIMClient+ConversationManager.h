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

@interface PhotonIMClient (ConversationManager)
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
 @param chatWith 会话中对方的id 群组为群组id
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
 @param chatWith 会话中对方的id 群组为群组id
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


/// 添加会话的中草稿
/// @param chatType 会话类型
/// @param chatWith 会话中对方的id 群组为群组id
/// @param draft 草稿内容
- (void)addConversationDraft:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith draft:(nullable NSString *)draft;


/// 修改会话的中草稿
/// @param chatType 会话类型
/// @param chatWith 会话中对方的id
/// @param draft 草稿内容
- (void)alterConversationDraft:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith draft:(nullable NSString *)draft;

/// 添加会话的中的草稿
/// @param chatType 会话类型
/// @param chatWith 会话中对方的id 群组为群组id
- (void)deleteConversationDraft:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;

/**
 更新会话的额外信息

 @param conversation <#conversation description#>
 */
- (void)updateConversationExtra:(PhotonIMConversation *)conversation;

/**
 更新会话的额外信息
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
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
 @param chatWith 会话中对方的id 群组为群组id
 @param count 未读数
 */
- (void)updateConversationUnReadCount:(PhotonIMChatType)chatType
                             chatWith:(NSString *)chatWith
                                count:(NSInteger)count;

/**
 清空一个会话的未读数
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
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
 @param chatWith 会话中对方的id 群组为群组id
 @param clearChatMessage 是否同时清空会话中的消息
 */
- (void)deleteConversation:(PhotonIMChatType)chatType
                  chatWith:(NSString *)chatWith
          clearChatMessage:(BOOL)clearChatMessage;

/**
 判断会话是否存在

 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
 @return YES 会话存在 NO 会话不存在
 */
- (BOOL)isConversationExist:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;

/**
 查找会话
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
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
 @param chatWith 会话中对方的id 群组为群组id
 @param arg 自定义消息中arg1参数
 */
- (void)updateConversationWithLastMsgArg1:(PhotonIMChatType)chatType
                                 chatWith:(NSString *)chatWith
                                      arg:(int)arg;

/**
 判断会话是否存在
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
 @param arg 自定义消息中arg2参数
 */
- (void)updateConversationWithLastMsgArg2:(PhotonIMChatType)chatType
                                 chatWith:(NSString *)chatWith
                                      arg:(int)arg;

/**
 判断会话是否存在
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
 @param arg 会话打标记使用的扩展字段
 */
- (void)updateConversationWithCustomArg1:(PhotonIMChatType)chatType
                                chatWith:(NSString *)chatWith
                                     arg:(int)arg;

/**
 判断会话是否存在
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id 群组为群组id
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
 @param chatWith 会话中对方的id 群组为群组id
 @param atType 会话处于at的类型
 */
- (void)updateConversationAtType:(PhotonIMChatType)chatType
                        chatWith:(NSString *)chatWith
                          atType:(PhotonIMConversationAtType)atType;


/// 设置会话中的消息为未读状态
- (void)setConversationUnRead:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;

/// 设置会话中的消息为未读状态
- (void)setConversationRead:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;


/// 获取会话的创建时间
/// @param chatType 会话类型
/// @param chatWith 会话中对方的id 群组为群组id
- (int64_t)findConversationCreateTime:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;
@end

NS_ASSUME_NONNULL_END
