//
//  PhotonMessageCenter.h
//  PhotonIM
//
//  Created by Bruce on 2019/6/27.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PhotonIMSDK/PhotonIMSDK.h>
#import "PhotonChatVoiceMessageItem.h"
#import "PhotonChatImageMessageItem.h"
#import "PhotonChatTextMessageItem.h"
#import "PhotonChatLocationItem.h"
#import "PhotonChatVideoMessageItem.h"

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
- (void)sendTextMessage:(nullable PhotonChatTextMessageItem *)item conversation:(nullable PhotonIMConversation *)conversation type:(int)type completion:(nullable CompletionBlock)completion;

- (void)sendTex:(NSString *)text conversation:(nullable PhotonIMConversation *)conversation completion:(nullable CompletionBlock)completion;

// 发送图片消息
- (void)sendImageMessage:(nullable PhotonChatImageMessageItem *)item conversation:(nullable PhotonIMConversation *)conversation completion:(nullable CompletionBlock)completion;

// 发送语音消息
- (void)sendVoiceMessage:(nullable PhotonChatVoiceMessageItem *)item conversation:(nullable PhotonIMConversation *)conversation completion:(nullable CompletionBlock)completion;

// 发送视频消息
- (void)sendVideoMessage:(nullable PhotonChatVideoMessageItem *)item conversation:(nullable PhotonIMConversation *)conversation completion:(nullable CompletionBlock)completion;

// 发送位置消息
- (void)sendLocationMessage:(PhotonChatLocationItem *)item conversation:(nullable PhotonIMConversation *)conversation completion:(nullable CompletionBlock)completion;

// 重发消息
- (void)resendMessage:(nullable PhotonChatBaseItem *)item completion:(nullable CompletionBlock)completion;

// 发送已读消息
- (void)sendReadMessage:(NSArray<NSString *> *)readMsgIDs conversation:(nullable PhotonIMConversation *)conversation completion:(nullable CompletionBlock)completion;

// 发送撤回消息
- (void)sendWithDrawMessage:(nullable PhotonChatBaseItem *)item completion:(nullable CompletionBlock)completion;


// 转发的逻辑
- (PhotonIMMessage *)transmitMessage:(nullable PhotonIMMessage *)message conversation:(nullable PhotonIMConversation *)conversation completion:(nullable CompletionBlock)completion;


- (void)sendAddGrupNoticeMessage:(nullable PhotonIMMessage *)message  completion:(nullable CompletionBlock)completion;


#pragma mark === 资源路径的处理 ====

/**
 获取语音的缓存地址
 
 @param fileName <#fileName description#>
 @return <#return value description#>
 */
- (NSString *)getVoiceFilePath:(NSString *)chatWith fileName:(nullable NSString *)fileName;


- (NSURL *)getVoiceFileURL:(NSString *)chatWith fileName:(nullable NSString *)fileName;

- (NSURL *)getVideoFileURL:(NSString *)chatWith fileName:(nullable NSString *)fileName;

- (NSString *)getVideoFilePath:(NSString *)chatWith fileName:(nullable NSString *)fileName;

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

- (void)deleteMessage:(PhotonIMMessage *)message completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion;
- (void)clearMessagesWithChatType:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith syncServer:(BOOL)syncServer completion:(void(^)(BOOL finish))completion;
- (void)clearMessagesWithChatType:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;
- (void)deleteConversation:(PhotonIMConversation *)conversation clearChatMessage:(BOOL)clearChatMessage;

- (void)clearConversationUnReadCount:(PhotonIMConversation *)conversation;

- (void)updateConversationIgnoreAlert:(PhotonIMConversation *)conversation;

- (void)alterConversationDraft:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith draft:(NSString *)draft;

- (PhotonIMConversation *)findConversation:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;

- (void)resetAtType:(PhotonIMConversation *)conversation;
@end

NS_ASSUME_NONNULL_END
