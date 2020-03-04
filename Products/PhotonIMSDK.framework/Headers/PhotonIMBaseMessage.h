//
//  PhotonIMBaseMessage.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/6/28.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotonIMEnum.h"
NS_ASSUME_NONNULL_BEGIN
@interface PhotonIMBaseMessage : NSObject

/**
 消息类型，初始化时默认产生，业务端也可设置
 */
@property(nonatomic, copy, nullable) NSString *messageID;

/**
 对方id SDK内部处理，上行消息业务端非必需设置
 */
@property(nonatomic, copy, nullable)NSString *chatWith;

/**
 时间，以毫秒为单位，消息发送时SDK会设置，上行消息业务端非必需设置
 */
@property(nonatomic, assign) int64_t timeStamp;

/**
 发送者，必需
 */
@property(nonatomic, copy, nullable) NSString *fr;
/**
 接收者，必需
 */
@property(nonatomic, copy, nullable) NSString *to;

/**
 消息类型，必需
 */
@property(nonatomic, assign)PhotonIMMessageType messageType;

/**
 会话类型，必需
 */
@property(nonatomic, assign)PhotonIMChatType chatType;


/**
 扩展信息，非必需
 */
@property(nonatomic, strong, nullable) NSMutableDictionary<NSString*, NSString*> *extra;


/**
 snippet content
 */
@property(nonatomic, copy, nullable) NSString *snippetContent;

#pragma mark ---- 协议外的消息状态 ---------

/**
 消息送达状态
 */
@property (nonatomic, assign)PhotonIMMessageStatus messageStatus;


/**
 消息发送回执的提醒文本，比如（被拒收或者触发spam）
 */
@property (nonatomic,copy, nullable)NSString  *notic;


/**
 是否在服务端保存此消息，默认值为YES（保存）
 */
@property (nonatomic,assign,readonly)BOOL saveMessageOnServer;

/**
 是否针对此条消息给对方发送push，默认值为YES（发送）
 */
@property (nonatomic,assign,readonly)BOOL needSendPush;


#pragma mark ----- 消息在服务端的位置标记，使用sdk的数据库不需要关注此项 -----
/**
 当前消息属于哪个消息队列
 */
@property (nonatomic, copy, nullable) NSString *lt;

/**
 当前消息在队列中的游标
 */
@property (nonatomic, assign) int64_t lv;


/**
 设置在服务端数据库不保存此条消息
 */
- (void)unSaveMessageOnServer;


/**
  针对此条消息不给对方发送push

 */
- (void)unSendPush;

@end

NS_ASSUME_NONNULL_END
