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

/// 消息相关的基类
@interface PhotonIMBaseMessage : NSObject

/**
 消息类型，初始化时默认产生，业务端也可设置
 */
@property(nonatomic, copy, nullable) NSString *messageID;

/**
 消息的fr to中不等于im当前连接登录用户id的一方，二人聊天为对方id，群聊指的是群组id。房间为房间id
 上行消息业务端非必需设置。
 */
@property(nonatomic, copy, nullable)NSString *chatWith;

/**
 时间，以毫秒为单位，消息发送时SDK会设置，上行消息业务端非必需设置
 */
@property(nonatomic, assign) int64_t timeStamp;

/**
 发送方id，必需
 */
@property(nonatomic, copy, nullable) NSString *fr;
/**
 接收方id，必需
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
 是否在本地保存此消息，默认值为YES（保存）
 */
@property (nonatomic,assign,readonly)BOOL saveMessage;

/**
 是否在服务端保存此消息，默认值为YES（保存）
 */
@property (nonatomic,assign,readonly)BOOL saveMessageOnServer;

/**
 是否针对此条消息给对方发送push，默认值为YES（发送）
 */
@property (nonatomic,assign,readonly)BOOL needSendPush;


/**
表示此条消息的接收方消息的未读数自增，YES为未读数自增，NO为不自增。默认值为YES.
 */
@property (nonatomic,assign,readonly)BOOL autoIncUnRN;

/**
表示接收端是否在接收到消息后，对应的会话的排序更新到最新，YES为未不做控制，使用sdk默认，NO为控制
 */
@property (nonatomic,assign,readonly)BOOL unUpdateSessionOrder;

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
 设置在本地数据库不保存此条消息
 */
- (void)unSaveMessage;

/**
 设置在服务端数据库不保存此条消息
 */
- (void)unSaveMessageOnServer;


/**
  针对此条消息不给对方发送push

 */
- (void)unSendPush;


/**
 设置此条消息的接收方未读数不自增

*/
- (void)notAutoIncrementUnReadNumber;

/**
 设置接收方接收到消息后都要改变session的排序

*/
- (void)updateSessionOrder;

#pragma mark ------ Extra数据操作 用于扩展功能 ------

/// 通过key获取extra对应的value
/// @param key 业务方指定
- (nullable NSString *)extraValueForKey:(NSString *)key;

/// 设置extra中的value值。存在key则修改替换，不存在则追加。message未入库时此操作
/// @param value Extra中设置的value
/// @param key Extra中设置的key
- (void)setExtraValue:(NSString *)value forKey:(NSString *)key;

/// 通过key删除extra对应的value
/// @param key 业务方指定
- (void)removeExtraValueForKey:(NSString *)key;
@end



@interface PhotonIMMessageQueryPara : NSObject

/// 查找的条数。
/// 默认：20
/// 此属性不适用查询消息的条数（-getMessageCountByParamter:chatWith:queryParameter:）
@property(nonatomic, assign)NSInteger size;

/// 查找的数据为锚点之前之后的数据，YES为查找锚点之前的数据（即早于锚点消息的数据）
/// NO为查找锚点之后的数据（即晚于于锚点消息的数据）。
/// 默认：YES。
/// 此属性不适用查询消息的条数（-getMessageCountByParamter:chatWith:queryParameter:）
@property(nonatomic, assign)BOOL beforeAnchor;

/// 锚点
/// 当beforeAnchor==YES时，取查询结果list的第一个元素消息（firstObject）的消息id作为锚点。
/// 当beforeAnchor==NO时，取查询结果list的最后一个元素消息（lastObject）的消息id作为锚点。
/// 此属性不适用查询消息的条数（-getMessageCountByParamter:chatWith:queryParameter:）
@property(nonatomic, copy, nullable)NSString *anchorMsgId;


/// 开始时间,单位毫秒
@property(nonatomic, assign)int64_t beginTimeStamp;

/// 结束时间,单位毫秒
@property(nonatomic, assign)int64_t endTime;

///消息发送方,默认为空
@property(nonatomic, copy, nullable)NSString *from;

/// 消息接收方,默认为空
@property(nonatomic, copy, nullable)NSString *to;
/**
消息类型集合

- PhotonIMMessageTypeUnknow: 未知
- PhotonIMMessageTypeRaw: 自定义
- PhotonIMMessageTypeText: 文本消息
- PhotonIMMessageTypeImage: 图片
- PhotonIMMessageTypeAudio: 语音
- PhotonIMMessageTypeVideo: 视频
- PhotonIMMessageTypeFile: 文件信息
- PhotonIMMessageTypeLocation: 位置信息
*/
@property(nonatomic, copy, nullable)NSArray<NSNumber *>*messageTypeList;
/**
消息的状态集合

- PhotonIMMessageStatusDefault: 默认
- PhotonIMMessageStatusRecall: 发送或收到的消息已撤回
- PhotonIMMessageStatusSending: 消息发送中
- PhotonIMMessageStatusFailed: 消息发送失败
- PhotonIMMessageStatusSucceed: 消息已送达
- PhotonIMMessageStatusSentRead: 发送的消息对方已读
- PhotonIMMessageStatusRecvRead: 收到的消息自己已读
*/
@property(nonatomic, copy, nullable)NSArray<NSNumber *>*messageStatusList;

/// 扩展中的key
@property(nonatomic, copy, nullable)NSString *extraKey;

/// 扩展中的value
@property(nonatomic, copy, nullable)NSString *extraValue;

/**
@brief 构造查询参数对象
支持按锚点向前或向后查找
@param anchor 锚点消息id,未有可为空
@param beforeAnchor 查找的数据为锚点之前之后的数据，YES为查找锚点之前的数据（即早于锚点消息的数据） NO为查找锚点之后的数据（即晚于于锚点消息的数据）
@param size 以锚点为中心，要查找的消息的个数
@return PhotonIMMessageQueryPara 对象
*/
+ (instancetype)messageQueryParaWithAnchorMsgId:(nullable NSString *)anchor
                                   beforeAuthor:(BOOL)beforeAnchor
                                           size:(int)size;

/**
@brief 构造查询参数对象
查找符合Extra中key-value的会话消息加，支持按锚点向前或向后查找
@param anchor 锚点消息id,未有可为空
@param beforeAnchor 查找的数据为锚点之前之后的数据，YES为查找锚点之前的数据（即早于锚点消息的数据） NO为查找锚点之后的数据（即晚于于锚点消息的数据）
@param key Extra指定的key
@param value Extra指定的key对应的value值。
@param size 以锚点为中心，要查找的消息的个数
@return PhotonIMMessageQueryPara 对象
*/
+ (instancetype)messageQueryParaWithAnchorMsgId:(nullable NSString *)anchor
                                                   beforeAuthor:(BOOL)beforeAnchor
                                                       extraKey:(NSString *)key
                                                     extraValue:(NSString *)value
                                                           size:(int)size;

/**
@brief 构造查询参数对象
加载会话中指定消息类型的所有消息，支持按锚点向前或向后查找
@param anchor 开始一次查询的锚点 锚点取消息id(msgID)
@param messageTypeList PhotonIMMessageType的集合
@param beforeAnchor 查找的数据为锚点之前之后的数据，YES为查找锚点之前的数据（即早于锚点消息的数据） NO为查找锚点之后的数据（即晚于于锚点消息的数据）
@param size 以锚点为中心，要查找的消息的个数
@return PhotonIMMessageQueryPara 对象
*/
+ (instancetype)messageQueryParaWithAnchorMsgId:(nullable NSString *)anchor
                                    messageTypeList:(nullable NSArray<NSNumber *>*)messageTypeList
                                       beforeAuthor:(BOOL)beforeAnchor
                                               size:(int)size;

/// @brief 构造查询参数对象
/// 加载指定时间范围的会话消息（仅同步本地数据库），支持按锚点向前或向后查找,此方法可设置要拉取的时间范围（beginTimeStamp<endTime且 endTime<0），如果设置的时间范围不合法，则默认依次拉取所有的消息。可按锚点拉取新旧消息
/// @param anchor 开始一次查询的锚点 锚点取消息id(msgID)
/// @param beginTimeStamp 消息的起始拉取时间，比如7天前
/// @param endTime 消息的结束拉取时间，比如当前时间
/// @param beforeAnchor 查找的数据为锚点之前之后的数据，YES为查找锚点之前的数据（即早于锚点消息的数据）NO为查找锚点之后的数据（即晚于于锚点消息的数据）
/// @param size 每次拉去的条数
/// @return PhotonIMMessageQueryPara 对象
+ (instancetype)messageQueryParaWithAnchorMsgId:(nullable NSString *)anchor
                                 beginTimeStamp:(int64_t)beginTimeStamp
                                        endTime:(int64_t)endTime
                                   beforeAuthor:(BOOL)beforeAnchor
                                           size:(int)size;


// @brief 构造查询参数对象 加载指定消息类型和指定时间范围的会话消息（仅同步本地数据库），支持按锚点向前或向后查找,此方法可设置要拉取的时间范围（beginTimeStamp<endTime且 endTime<0），如果设置的时间范围不合法，则默认依次拉取所有的消息，可按锚点拉取新旧消息
/// @param anchor 开始一次查询的锚点 锚点取消息id(msgID)
/// @param messageTypeList PhotonIMMessageType的集合
/// @param beginTimeStamp 消息的起始拉取时间，比如7天前
/// @param endTime 消息的结束拉取时间，比如当前时间
/// @param beforeAnchor 查找的数据为锚点之前之后的数据，YES为查找锚点之前的数据（即早于锚点消息的数据）NO为查找锚点之后的数据（即晚于于锚点消息的数据）
/// @param size 每次拉去的条数
/// @return PhotonIMMessageQueryPara 对象
+ (instancetype)messageQueryParaWithAnchorMsgId:(nullable NSString *)anchor
            messageTypeList:(nullable NSArray<NSNumber *>*)messageTypeList
             beginTimeStamp:(int64_t)beginTimeStamp
                    endTime:(int64_t)endTime
               beforeAuthor:(BOOL)beforeAnchor
                       size:(int)size;


/// @brief 构造查询参数对象 加载指定消息类型、指定时间范围以及查找符合Extra中key-value的会话消息（仅同步本地数据库），支持按锚点向前或向后查找,此方法可设置要拉取的时间范围（beginTimeStamp<endTime且 endTime<0），如果设置的时间范围不合法，则默认依次拉取所有的消息，可按锚点拉取新旧消息
/// @param anchor 开始一次查询的锚点 锚点取消息id(msgID)
/// @param messageTypeList PhotonIMMessageType的集合，为空查找所有类型消息
/// @param beginTimeStamp 消息的起始拉取时间，比如7天前
/// @param endTime 消息的结束拉取时间，比如当前时间。注:如果设置的时间范围不合法，则默认依次拉取所有的消息，可按锚点拉取新旧消息
/// @param key Extra指定的key
/// @param value Extra指定的key对应的value值。 注：key 或 value为空，查找结果忽略key-value限制
/// @param beforeAnchor 查找的数据为锚点之前之后的数据，YES为查找锚点之前的数据（即早于锚点消息的数据）NO为查找锚点之后的数据（即晚于于锚点消息的数据）
/// @param size 每次拉去的条数
/// @return PhotonIMMessageQueryPara 对象
+ (instancetype)messageQueryParaWithAnchorMsgId:(nullable NSString *)anchor
                                    messageTypeList:(nullable NSArray<NSNumber *>*)messageTypeList
                                     beginTimeStamp:(int64_t)beginTimeStamp
                                            endTime:(int64_t)endTime
                                       beforeAuthor:(BOOL)beforeAnchor
                                           extraKey:(nullable NSString *)key
                                         extraValue:(nullable NSString *)value
                                               size:(int)size;
@end
NS_ASSUME_NONNULL_END
