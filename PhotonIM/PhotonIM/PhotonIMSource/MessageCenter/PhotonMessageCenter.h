//
//  PhotonMessageCenter.h
//  PhotonIM
//
//  Created by Bruce on 2019/6/27.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PhotonIMSDK/PhotonIMSDK.h>
#import "PhotonVoiceMessageChatItem.h"
#import "PhotonImageMessageChatItem.h"
#import "PhotonTextMessageChatItem.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^CompletionBlock) (BOOL succeed, PhotonIMError * _Nullable error);
@protocol PhotonMessageProtocol <PhotonIMClientProtocol>
@optional
- (void)sendMessageResultCallBack:(PhotonIMMessage *)message;
@end
@interface PhotonMessageCenter : NSObject
+ (instancetype)sharedCenter;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


/**
 初始化话IMSDK
 */
- (void)initPhtonIMSDK;

/**
 登录
 */
- (void)login;

/**
 退出
 */
- (void)logout;

// 获取未读的消息数
- (NSInteger)unreadMsgCount;


//-------- 消息接收通知相关 -----------
- (void)addObserver:(id<PhotonMessageProtocol>)target;

- (void)removeObserver:(id<PhotonMessageProtocol>)target;

- (void)removeAllObserver;

//-------- 消息发送相关 -----------

// 发送文本表情消息
- (void)sendTextMessage:(nullable PhotonTextMessageChatItem *)item conversation:(nullable PhotonIMConversation *)conversation completion:(nullable CompletionBlock)completion;

// 发送图片消息
- (void)sendImageMessage:(nullable PhotonImageMessageChatItem *)item conversation:(nullable PhotonIMConversation *)conversation completion:(nullable CompletionBlock)completion;

// 发送语音消息
- (void)sendVoiceMessage:(nullable PhotonVoiceMessageChatItem *)item conversation:(nullable PhotonIMConversation *)conversation completion:(nullable CompletionBlock)completion;

// 重发消息
- (void)resendMessage:(nullable PhotonBaseChatItem *)item completion:(nullable CompletionBlock)completion;

// 发送已读消息
- (void)sendReadMessage:(NSArray<NSString *> *)readMsgIDs conversation:(nullable PhotonIMConversation *)conversation completion:(nullable CompletionBlock)completion;

// 发送撤回消息
- (void)sendWithDrawMessage:(nullable PhotonBaseChatItem *)item completion:(nullable CompletionBlock)completion;


// 转发的逻辑
- (void)transmitMessage:(nullable PhotonIMMessage *)message conversation:(nullable PhotonIMConversation *)conversation completion:(nullable CompletionBlock)completion;


#pragma mark === 资源路径的处理 ====

/**
 获取语音的缓存地址
 
 @param fileName <#fileName description#>
 @return <#return value description#>
 */
- (NSString *)getVoiceFilePath:(NSString *)chatWith fileName:(nullable NSString *)fileName;


- (NSURL *)getVoiceFileURL:(NSString *)chatWith fileName:(nullable NSString *)fileName;

/**
 获取图片的缓存地址
 
 @param fileName <#fileName description#>
 @return <#return value description#>
 */
- (NSString *)getImageFilePath:(NSString *)chatWith fileName:(nullable NSString *)fileName;
- (NSURL *)getImageFileURL:(NSString *)chatWith fileName:(nullable NSString *)fileName;

/**
 删除指定语音文件名的语音文件
 
 @param fileName <#fileName description#>
 @return <#return value description#>
 */
- (BOOL)deleteVoiceFile:(NSString *)chatWith fileName:(nullable NSString *)fileName;

/**
 删除指定图片文件名的图片文件
 
 @param fileName <#fileName description#>
 @return <#return value description#>
 */
- (BOOL)deleteImageFile:(NSString *)chatWith fileName:(nullable NSString *)fileName;

#pragma mark === 数据存储 ======
- (void)insertOrUpdateMessage:(PhotonIMMessage *)message;

- (void)deleteMessage:(PhotonIMMessage *)message;

- (void)deleteConversation:(PhotonIMConversation *)conversation clearChatMessage:(BOOL)clearChatMessage;

- (void)clearConversationUnReadCount:(PhotonIMConversation *)conversation;

- (void)updateConversationIgnoreAlert:(PhotonIMConversation *)conversation;
@end

NS_ASSUME_NONNULL_END
