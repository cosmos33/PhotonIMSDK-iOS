//
//  PhotonIMEnum.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/1.
//  Copyright © 2019 Bruce. All rights reserved.
//

#ifndef PhotonIMEnum_h
#define PhotonIMEnum_h



#pragma MARK -------- IM连接登录相关枚举 --------

/**
 IM登录状态

 - PhotonIMLoginStatusUnknow: 未知
 - PhotonIMLoginStatusConnecting: 连接服务器中。。。
 - PhotonIMLoginStatusConnected: 已连接服务器
 - PhotonIMLoginStatusConnectFailed: 连接服务器失败
 - PhotonIMLoginStatusLogining: 登录中
 - PhotonIMLoginStatusLoginSucceed: 登录成功
 - PhotonIMLoginStatusFailed: 登录失败
 - PhotonIMLoginStatusDisconnecting: 断开连接中。。。
 - PhotonIMLoginStatusDisconnected: 连接已断开
 */
typedef NS_ENUM(NSInteger, PhotonIMLoginStatus) {
    PhotonIMLoginStatusUnknow = 0,
    PhotonIMLoginStatusConnecting,
    PhotonIMLoginStatusConnected,
    PhotonIMLoginStatusConnectFailed,
    PhotonIMLoginStatusLogining,
    PhotonIMLoginStatusLoginSucceed,
    PhotonIMLoginStatusLoginFailed,
    PhotonIMLoginStatusDisconnecting,
    PhotonIMLoginStatusDisconnected,
};

/**
 登录失败类型

 - PhotonIMLoginFailedTypeUnknow: 未知
 - PhotonIMLoginFailedTypeTimeOut: 登录超时
 - PhotonIMLoginFailedTypeTokenError: auth失败，token校验失败(403)
 - PhotonIMLoginFailedTypeParamterError: auth参数错误（404）
 - PhotonIMLoginFailedTypeAbnormal: auth异常，重试（405）使用已有数据重新连接一次
 - PhotonIMLoginFailedTypeKick: 当前用户在其他ap登录，踢掉当前连接（409）被踢掉，回到登录界面
 - PhotonIMLoginFailedTypeReConnect: 重连，让当前用户在其他ap重新连接(410) // 内部处理，使用返回的ap在内部处理连接
 */
typedef NS_ENUM(NSInteger, PhotonIMLoginFailedType) {
    PhotonIMLoginFailedTypeUnknow = 0,
    PhotonIMLoginFailedTypeTimeOut,
    PhotonIMLoginFailedTypeTokenError,
    PhotonIMLoginFailedTypeParamterError,
    PhotonIMLoginFailedTypeAbnormal,
    PhotonIMLoginFailedTypeKick,
    PhotonIMLoginFailedTypeReConnect,
};


/**
 拉取消息是的状态
Start---End 之间可以显示消息拉取中的提示
 - PhotonIMSyncStatusSyncStart: 消息开始拉取
 - PhotonIMSyncStatusSyncEnd: 消息拉取结束
 - PhotonIMSyncStatusSyncTimeout: 消息拉取超时
 */
typedef NS_ENUM(NSInteger,PhotonIMSyncStatus) {
    PhotonIMSyncStatusSyncStart,
    PhotonIMSyncStatusSyncEnd,
    PhotonIMSyncStatusSyncTimeout
};


/**
 使用数据可的模式

 - PhotonIMDBModeNoDB: 不使用数据库
 - PhotonIMDBModeDBSync: 同步使用数据库
 - PhotonIMDBModeDBAsync: 异步使用数据库
 */
typedef NS_ENUM(NSInteger,PhotonIMDBMode) {
    PhotonIMDBModeNoDB = 0,
    PhotonIMDBModeDBSync = 1,
    PhotonIMDBModeDBAsync = 2
};


#pragma MARK -------- 消息数据相关枚举 --------

/**
 会话的类型
 
 - PhotonIMChatTypeSingle: 单聊类型
 - PhotonIMChatTypeGroup: 群聊类型
 - PhotonIMChatTypeCustom: 自定义类型
 
 - PhotonIMChatTypeSingleWithDraw: 单聊撤回类型
 - PhotonIMChatTypeGroupWithDraw: 群聊撤回类型
 - PhotonIMMessageTypeRead: 已读类型
 */
typedef NS_ENUM(NSInteger,PhotonIMChatType){
    PhotonIMChatTypeSingle = 1,
    PhotonIMChatTypeGroup,
    PhotonIMChatTypeCustom,
    
    PhotonIMChatTypeSingleWithDraw = 66,
    PhotonIMChatTypeGroupWithDraw = 67,
    PhotonIMChatTypeRead = 68
};

/**
 消息类型
 
 - PhotonIMMessageTypeUnknow: 位置
 - PhotonIMMessageTypeRaw: 自定义
 - PhotonIMMessageTypeText: 文本消息
 - PhotonIMMessageTypeImage: 图片
 - PhotonIMMessageTypeAudio: 语音
 - PhotonIMMessageTypeVideo: 视频
 */
typedef NS_ENUM(NSInteger,PhotonIMMessageType) {
    PhotonIMMessageTypeUnknow = 0,
    PhotonIMMessageTypeRaw = 1,
    PhotonIMMessageTypeText = 2,
    PhotonIMMessageTypeImage = 3,
    PhotonIMMessageTypeAudio = 4,
    PhotonIMMessageTypeVideo = 5,

};

/**
 消息的状态

 - PhotonIMMessageStatusDefault: 默认
 - PhotonIMMessageStatusRecall: 发送或收到的消息已撤回
 - PhotonIMMessageStatusSending: 消息发送中
 - PhotonIMMessageStatusFailed: 消息发送失败
 - PhotonIMMessageStatusSucceed: 消息已送达
 - PhotonIMMessageStatusSentRead: 发送的消息对方已读
 - PhotonIMMessageStatusRecvRead: 收到的消息自己已读
 */
typedef NS_ENUM(NSInteger,PhotonIMMessageStatus) {
    PhotonIMMessageStatusDefault = 0,
    PhotonIMMessageStatusRecall = 1,
    PhotonIMMessageStatusSending = 2,
    PhotonIMMessageStatusFailed = 3,
    PhotonIMMessageStatusSucceed = 4,
    PhotonIMMessageStatusSentRead = 5,
    PhotonIMMessageStatusRecvRead = 6,
    
};

/**
 会话操作的事件
 
 - PhotonIMConversationEventCreate: 会话创建事件
 - PhotonIMConversationEventDelete: 会话删除事件
 - PhotonIMConversationEventUpdate: 会话更新事件
 */
typedef NS_ENUM(NSInteger,PhotonIMConversationEvent){
    PhotonIMConversationEventCreate,
    PhotonIMConversationEventDelete,
    PhotonIMConversationEventUpdate,
};


#pragma MARK -------- 网络状态的变化 --------
typedef NS_ENUM(NSInteger,PhotonIMNetworkStatus) {
    PhotonIMNetworkStatusUnknown          = -1,
    PhotonIMNetworkStatusNone             = 0,
    PhotonIMNetworkStatusWWAN             = 1,
    PhotonIMNetworkStatusWIFI             = 2,
};

typedef NS_ENUM(NSInteger, PhotonIMNetworkType) {
    PhotonIMNetworkTypeUnknown = -1,
    PhotonIMNetworkTypeNone    = 0,
    PhotonIMNetworkTypeWIFI    = 1,
    PhotonIMNetworkType2G      = 2,
    PhotonIMNetworkType3G      = 3,
    PhotonIMNetworkType4g      = 4,
};

/**
会话中的at类型

- PhotonIMConversationAtTypeNoAt: 会话不包含at
- PhotonIMConversationAtTypeAtMe: 会话中有at，非全部，包含我
- PhotonIMConversationTypeAtAll: 会话处于at所有群成员
*/
typedef NS_ENUM(NSInteger, PhotonIMConversationAtType) {
    PhotonIMConversationAtTypeNoAt = 0,
    PhotonIMConversationAtTypeAtMe = 1,
    PhotonIMConversationTypeAtAll = 2,
};

/**
消息中的at类型

- PhotonIMAtTypeNoAt: 非at消息
- PhotonIMAtTypeNotAtAll: 消息中包含at接收方，但不是at全部
- PhotonIMAtTypeAtAll: 消息为at所有人
*/
typedef NS_ENUM(NSInteger, PhotonIMAtType) {
    PhotonIMAtTypeNoAt = 0,
    PhotonIMAtTypeNotAtAll = 1,
    PhotonIMAtTypeAtAll = 2,
};

typedef NS_ENUM(NSInteger, PhotonIMForbidenAutoResendType){
    PhotonIMForbidenAutoResendTypeNO = 0,
    PhotonIMForbidenAutoResendTypeLogin = 2,
    PhotonIMForbidenAutoResendTypeColdStart = 3,
};
#endif /* PhotonIMEnum_h */
