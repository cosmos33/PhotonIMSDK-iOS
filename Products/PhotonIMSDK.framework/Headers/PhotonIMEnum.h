/*!

 @header PhotonIMEnum.h

 @abstract 枚举集合

 @author Created by Bruce on 2019/6/27.

 @version 2.1.1 2019/12/25 Creation

*/

#ifndef PhotonIMEnum_h
#define PhotonIMEnum_h


#pragma MARK -------- IM连接登录相关枚举 --------

/*!
 @typedef  PhotonIMLoginStatus
 @brief IM登录状态
 
 @constant PhotonIMLoginStatusUnknow 未知
 @constant PhotonIMLoginStatusConnecting 连接服务器中
 @constant PhotonIMLoginStatusConnected 已连接服务器
 @constant PhotonIMLoginStatusConnectFailed 连接服务器失败
 @constant PhotonIMLoginStatusLogining 登录中
 @constant PhotonIMLoginStatusLoginSucceed 登录成功
 @constant PhotonIMLoginStatusLoginFailed 登录失败
 @constant PhotonIMLoginStatusDisconnecting 断开连接中
 @constant PhotonIMLoginStatusDisconnected 连接已断开
 */
typedef enum{
    PhotonIMLoginStatusUnknow = 0,
    PhotonIMLoginStatusConnecting,
    PhotonIMLoginStatusConnected,
    PhotonIMLoginStatusConnectFailed,
    PhotonIMLoginStatusLogining,
    PhotonIMLoginStatusLoginSucceed,
    PhotonIMLoginStatusLoginFailed,
    PhotonIMLoginStatusDisconnecting,
    PhotonIMLoginStatusDisconnected
}PhotonIMLoginStatus;

/*!
 @typedef  PhotonIMLoginFailedType
 @brief 登录失败类型
 @constant PhotonIMLoginFailedTypeUnknow 未知
 @constant PhotonIMLoginFailedTypeTimeOut 登录超时
 @constant PhotonIMLoginFailedTypeTokenError auth失败，token校验失败(403)
 @constant PhotonIMLoginFailedTypeParamterError auth参数错误（404）
 @constant PhotonIMLoginFailedTypeAbnormal auth异常，重试（405）使用已有数据重新连接一次
 @constant PhotonIMLoginFailedTypeKick 当前用户在其他ap登录，踢掉当前连接（409）被踢掉，回到登录界面
 @constant PhotonIMLoginFailedTypeReConnect 重连，让当前用户在其他ap重新连接(410) // 内部处理，使用返回的ap在内部处理连接
*/
typedef enum{
    PhotonIMLoginFailedTypeUnknow = 0,
    PhotonIMLoginFailedTypeTimeOut,
    PhotonIMLoginFailedTypeTokenError,
    PhotonIMLoginFailedTypeParamterError,
    PhotonIMLoginFailedTypeAbnormal,
    PhotonIMLoginFailedTypeKick,
    PhotonIMLoginFailedTypeReConnect,
}PhotonIMLoginFailedType;


/*!
 @typedef  PhotonIMSyncStatus
 @brief 拉取消息是的状态Start和End之间可以显示消息拉取中的提示
 @constant PhotonIMSyncStatusSyncStart 消息开始拉取
 @constant PhotonIMSyncStatusSyncEnd 消息拉取结束
 @constant PhotonIMSyncStatusSyncTimeout 消息拉取超时
 */
typedef enum{
    PhotonIMSyncStatusSyncStart = 0,
    PhotonIMSyncStatusSyncEnd,
    PhotonIMSyncStatusSyncTimeout
}PhotonIMSyncStatus;


/*!
 @typedef  PhotonIMDBMode
 @brief 使用数据可的模式
 @constant PhotonIMDBModeNoDB 不使用数据库
 @constant PhotonIMDBModeDBSync 同步使用数据库
 @constant PhotonIMDBModeDBAsync 异步使用数据库
 */
typedef enum{
    PhotonIMDBModeNoDB = 0,
    PhotonIMDBModeDBSync = 1,
    PhotonIMDBModeDBAsync = 2
}PhotonIMDBMode;


#pragma MARK -------- 消息数据相关枚举 --------

/*!
 @typedef PhotonIMChatType
 @brief 会话的类型
 @constant PhotonIMChatTypeDefault 默认
 @constant PhotonIMChatTypeSingle 单聊类型
 @constant PhotonIMChatTypeGroup 群聊类型
 @constant PhotonIMChatTypeCustom 自定义类型
 @constant PhotonIMChatTypeSingleWithDraw 单聊撤回类型
 @constant PhotonIMChatTypeGroupWithDraw 群聊撤回类型
 @constant PhotonIMMessageTypeRead 已读类型
 */
typedef enum{
    PhotonIMChatTypeDefault = 0,
    PhotonIMChatTypeSingle = 1,
    PhotonIMChatTypeGroup,
    PhotonIMChatTypeCustom,
    PhotonIMChatTypeSingleWithDraw = 66,
    PhotonIMChatTypeGroupWithDraw = 67,
    PhotonIMChatTypeRead = 68
}PhotonIMChatType;

/*!
 @typedef  PhotonIMMessageType
 @brief 消息类型
 @constant PhotonIMMessageTypeUnknow 位置
 @constant PhotonIMMessageTypeRaw 自定义
 @constant PhotonIMMessageTypeText 文本消息
 @constant PhotonIMMessageTypeImage 图片
 @constant PhotonIMMessageTypeAudio 语音
 @constant PhotonIMMessageTypeVideo 视频
 */

typedef enum{
    PhotonIMMessageTypeUnknow = 0,
    PhotonIMMessageTypeRaw = 1,
    PhotonIMMessageTypeText = 2,
    PhotonIMMessageTypeImage = 3,
    PhotonIMMessageTypeAudio = 4,
    PhotonIMMessageTypeVideo = 5,
    PhotonIMMessageTypeFile = 6,
    PhotonIMMessageTypeLocation = 7,

}PhotonIMMessageType;

/*!
 
 @typedef  PhotonIMMessageStatus
 @brief 消息类型消息的状态
 
 @constant PhotonIMMessageStatusDefault 默认
 @constant PhotonIMMessageStatusRecall 发送或收到的消息已撤回
 @constant PhotonIMMessageStatusSending 消息发送中
 @constant PhotonIMMessageStatusFailed 消息发送失败
 @constant PhotonIMMessageStatusSucceed 消息已送达
 @constant PhotonIMMessageStatusSentRead 发送的消息对方已读
 @constant PhotonIMMessageStatusRecvRead 收到的消息自己已读
 */
typedef enum{
    PhotonIMMessageStatusDefault = 0,
    PhotonIMMessageStatusRecall = 1,
    PhotonIMMessageStatusSending = 2,
    PhotonIMMessageStatusFailed = 3,
    PhotonIMMessageStatusSucceed = 4,
    PhotonIMMessageStatusSentRead = 5,
    PhotonIMMessageStatusRecvRead = 6,
    
}PhotonIMMessageStatus;

/*!
 @typedef  PhotonIMConversationEvent
 @brief 会话操作的事件
 
 @constant PhotonIMConversationEventCreate 会话创建事件
 @constant PhotonIMConversationEventDelete 会话删除事件
 @constant PhotonIMConversationEventUpdate 会话更新事件
 */
typedef enum{
    PhotonIMConversationEventCreate,
    PhotonIMConversationEventDelete,
    PhotonIMConversationEventUpdate,
}PhotonIMConversationEvent;


#pragma MARK -------- 网络状态的变化 --------

/*!
@typedef  PhotonIMNetworkStatus
@brief 当前的网络状态
@constant PhotonIMNetworkStatusUnknown 未知
@constant PhotonIMNetworkStatusNone 无网
@constant PhotonIMNetworkStatusWWAN 蜂窝网络
@constant PhotonIMNetworkStatusWIFI WIFI
 
*/
typedef enum{
    PhotonIMNetworkStatusUnknown          = -1,
    PhotonIMNetworkStatusNone             = 0,
    PhotonIMNetworkStatusWWAN             = 1,
    PhotonIMNetworkStatusWIFI             = 2,
}PhotonIMNetworkStatus;

/*!
 
 @typedef  PhotonIMNetworkType
 @brief 当前的网络状态
 @constant PhotonIMNetworkTypeUnknown 未知
 @constant PhotonIMNetworkTypeNone 无网
 @constant PhotonIMNetworkTypeWIFI wifi
 @constant PhotonIMNetworkType2G 2G
 @constant PhotonIMNetworkType3G 3G
 @constant PhotonIMNetworkType4G 4G

*/
typedef enum{
    PhotonIMNetworkTypeUnknown = -1,
    PhotonIMNetworkTypeNone    = 0,
    PhotonIMNetworkTypeWIFI    = 1,
    PhotonIMNetworkType2G      = 2,
    PhotonIMNetworkType3G      = 3,
    PhotonIMNetworkType4G      = 4,
}PhotonIMNetworkType;

/*!

@typedef  PhotonIMConversationAtType
@brief 会话中的at类型
@constant PhotonIMConversationAtTypeNoAt 会话不包含at
@constant PhotonIMConversationAtTypeAtMe 会话中有at，非全部，包含我
@constant PhotonIMConversationTypeAtAll 会话处于at所有群成员
*/
typedef enum{
    PhotonIMConversationAtTypeNoAt = 0,
    PhotonIMConversationAtTypeAtMe = 1,
    PhotonIMConversationTypeAtAll = 2,
}PhotonIMConversationAtType;

/*!

@typedef  PhotonIMConversationAtType
@brief 消息中的at类型
@constant PhotonIMAtTypeNoAt 非at消息
@constant PhotonIMAtTypeNotAtAll 消息中包含at接收方，但不是at全部
@constant PhotonIMAtTypeAtAll 消息为at所有人
 
*/
typedef enum{
    PhotonIMAtTypeNoAt = 0,
    PhotonIMAtTypeNotAtAll = 1,
    PhotonIMAtTypeAtAll = 2,
}PhotonIMAtType;

/*!

@typedef  PhotonIMForbidenAutoResendType
@brief 关闭重发消息的类型
@constant PhotonIMForbidenAutoResendTypeNO // 允许消息重发，此为默认值
@constant PhotonIMForbidenAutoResendTypeLogin // 禁止每次登录成功后消息的重发,
@constant PhotonIMForbidenAutoResendTypeColdStart // 仅在app冷启登录时消息重新发送
 
*/
typedef enum{
    PhotonIMForbidenAutoResendTypeNO = 0,
    PhotonIMForbidenAutoResendTypeLogin = 2,
    PhotonIMForbidenAutoResendTypeColdStart = 3,
}PhotonIMForbidenAutoResendType;
#endif /* PhotonIMEnum_h */
