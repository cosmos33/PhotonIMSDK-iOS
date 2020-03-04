/*!

 @header PhotonIMConversation.h

 @abstract 会话类，包含会话中的各个属性

 @author Created by Bruce on 2019/6/27.

 @version 2.1.1 2019/12/25 Creation

*/

#import <Foundation/Foundation.h>
#import "PhotonIMEnum.h"
NS_ASSUME_NONNULL_BEGIN
/*!

@class PhotonIMConversation

@abstract 会话类，包含会话中的各个属性

*/
@interface PhotonIMConversation : NSObject
/*!

@property chatWith

@abstract 会话中对方id

*/
@property(nonatomic, copy, nullable) NSString *chatWith;

/*!

@property chatType

@abstract 回话所属类型，单人 or 群组

*/
@property(nonatomic, assign) PhotonIMChatType chatType;

/*!
 
 property lastTimeStamp
 
 @abstract 会话最近一次操作的时间戳
 
 */
@property(nonatomic, assign) uint64_t lastTimeStamp;

/*!

@property draft

@abstract 会话中的草稿

*/
@property(nonatomic, copy, nullable) NSString *draft;

/*!
 @property lastMsgId
 
 @abstract 会话中最近一条消息
 
 */
@property(nonatomic, copy, nullable) NSString *lastMsgId;

/*!
@property lastMsgContent

@abstract 会话中最近一条消息内容
 */
@property(nonatomic, copy, nullable) NSString *lastMsgContent;


/*!
@property unReadCount

@abstract 消息的未读数
 */
@property(nonatomic, assign) NSInteger unReadCount;

/*!
@property lastMsgType

@abstract 消息类型(文本，语音 or 视频)
 */
@property(nonatomic, assign) PhotonIMMessageType lastMsgType;

/*!
@property lastMsgFr

@abstract 最近一条消息的发送方
 */
@property(nonatomic, copy, nullable) NSString *lastMsgFr;

/*!
@property lastMsgTo

@abstract 最近一条消息的接收方
 */
@property(nonatomic, copy, nullable) NSString *lastMsgTo;


/*!
@property lastMsgStatus

@abstract 最近一条消息的发送状态
 */
@property(nonatomic, assign) PhotonIMMessageStatus lastMsgStatus;

/*!
 
@property FName

@abstract 会话中好友名
 
 */
@property(nonatomic, copy, nullable) NSString *FName;

/*!
 
@property FAvatarPath

@abstract 会话中好头像
 
 */
@property(nonatomic, copy, nullable) NSString *FAvatarPath;


/*!
 
@property extra

@abstract 额外的信息
 */
@property(nonatomic, copy, nullable)NSDictionary<NSString *, NSString *> *extra;

/*!
 
@property lastMsgArg1

@abstract session中最后一条消息自定义扩展字段参数
 */
@property (nonatomic, assign)int  lastMsgArg1;

/*!
 
@property lastMsgArg2

@abstract session中最后一条消息自定义扩展字段参数
 */
@property (nonatomic, assign)int  lastMsgArg2;

/*!
 
@property customArg1

@abstract session中自定义扩展字段参数
 */
@property (nonatomic, assign)int  customArg1;

/*!
 
@property customArg2

@abstract session中自定义扩展字段参数
 */
@property (nonatomic, assign)int  customArg2;

/*!
 
@property lastMsgIsReceived

@abstract 最后一天消息是否为接收的消息
 */
@property(nonatomic,assign)BOOL lastMsgIsReceived;

#pragma mark ----- 会话操作设置相关 ------

/*!
 
@property ignoreAlert

@abstract 会话是否设置免打扰 默认值为NO（不设置免打扰）
 */
@property(nonatomic, assign) BOOL ignoreAlert;

/*!
 
@property sticky

@abstract 会话是否设置置顶 默认值为NO（不置顶）
 
 */
@property(nonatomic, assign) BOOL sticky;



/*!
 
@property atType

@abstract 2.0及以上版本支持此功能
 
 */
@property(nonatomic, assign)PhotonIMConversationAtType atType;

/*!

 @abstract 初始化方法
 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @return 会话对象
 
 */
- (instancetype)initWithChatType:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;
@end

NS_ASSUME_NONNULL_END
