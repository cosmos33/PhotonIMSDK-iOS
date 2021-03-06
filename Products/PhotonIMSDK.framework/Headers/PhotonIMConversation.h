//
//  PhotonIMConversation.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/1.
//  Copyright © 2019 Bruce. All rights reserved.
//  会话类型

#import <Foundation/Foundation.h>
#import "PhotonIMEnum.h"
NS_ASSUME_NONNULL_BEGIN

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
 会话最近一次操作的时间戳
 */
@property(nonatomic, assign) uint64_t lastTimeStamp;


@property(nonatomic, copy, nullable) NSString *draft;

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
@property(nonatomic, copy, nullable)NSDictionary<NSString *, NSString *> *extra;

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
 初始化方法

 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @return <#return value description#>
 */
- (instancetype)initWithChatType:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;
@end

NS_ASSUME_NONNULL_END
