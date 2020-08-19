//
//  PhotonIMConversation.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/1.
//  Copyright © 2019 Bruce. All rights reserved.
//  会话类型

#import <Foundation/Foundation.h>
#import "PhotonIMEnum.h"
#import "PhotonIMMessage.h"
NS_ASSUME_NONNULL_BEGIN


/// 会话相关,管理会话的相关属性.
@interface PhotonIMConversation : NSObject

/**
 会话中对方id
 */
@property(nonatomic, copy, nullable) NSString *chatWith;


/**
 回话所属类型，单人 or 群组
 */
@property(nonatomic, assign) PhotonIMChatType chatType;

/**
 会话创建时的时间戳
 */
@property(nonatomic, assign) uint64_t createTimeStamp;

/**
 会话最近一次操作的时间戳
 */
@property(nonatomic, assign) uint64_t lastTimeStamp;

/**
会话的草稿
*/
@property(nonatomic, copy, nullable) NSString *draft;

/**
会话中最新一条消息的对象
*/
@property(nonatomic,strong, nullable)PhotonIMMessage *lastMessage;

/**
 会话中最近一条消息
 */
@property(nonatomic, copy, nullable) NSString *lastMsgId;
/**
 会话中最近一条消息
 */
@property(nonatomic, copy, nullable) NSString *lastMsgContent;


/**
 消息的未读数
 */
@property(nonatomic, assign) NSInteger unReadCount;

/**
 消息类型(文本，语音 or 视频)
 */
@property(nonatomic, assign) PhotonIMMessageType lastMsgType;

/**
 最近一条消息的发送方
 */
@property(nonatomic, copy, nullable) NSString *lastMsgFr;

/**
 最近一条消息的接收方
 */
@property(nonatomic, copy, nullable) NSString *lastMsgTo;


/**
 最近一条消息的发送状态
 */
@property(nonatomic, assign) PhotonIMMessageStatus lastMsgStatus;

/**
 会话中好友名
 */
@property(nonatomic, copy, nullable) NSString *FName;

/**
 会话中好头像
 */
@property(nonatomic, copy, nullable) NSString *FAvatarPath;


/**
 额外的信息
 */
@property(nonatomic, strong, nullable)NSMutableDictionary<NSString *, NSString *> *extra;

/*
 session中最后一条消息自定义扩展字段参数
 */
@property (nonatomic, assign)int  lastMsgArg1;
@property (nonatomic, assign)int  lastMsgArg2;

/**
 session中自定义扩展字段参数
 */
@property (nonatomic, assign)int  customArg1;
@property (nonatomic, assign)int  customArg2;

/**
 最后一天消息是否为接收的消息
 */
@property(nonatomic,assign)BOOL lastMsgIsReceived;

#pragma mark ----- 会话操作设置相关 ------

/**
 会话是否设置免打扰 默认值为NO（不设置免打扰）
 */
@property(nonatomic, assign) BOOL ignoreAlert;
/**
 会话是否设置置顶 默认值为NO（不指定）
 */
@property(nonatomic, assign) BOOL sticky;



/**
 2.0及以上版本支持此功能
PhotonIMConversationAtTypeNoAt,//会话不包含at
PhotonIMConversationAtTypeAtMe,//会话处于at中，非全部，包含我
PhotonIMConversationTypeAtAl,//会话处于at所有群成员
 */
@property(nonatomic, assign)PhotonIMConversationAtType atType;


@property(nonatomic, assign)NSInteger   ftsResultCount;



/**
 初始化方法

 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @return <#return value description#>
 */
- (instancetype)initWithChatType:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;


#pragma mark ------ Extra数据操作 用于扩展功能 ------
/// 通过key获取extra对应的value
/// @param key 业务方指定
- (nullable NSString *)extraValueForKey:(NSString *)key;

/// 设置extra中的value值。存在key则修改替换，不存在则追加
/// @param value Extra中设置的value
/// @param key Extra中设置的key
- (void)setExtraValue:(NSString *)value forKey:(NSString *)key;

/// 通过key删除extra对应的value
/// @param key 业务方指定
- (void)removeExtraValueForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
