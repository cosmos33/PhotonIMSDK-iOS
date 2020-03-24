//
//  PhotonMessageCenter.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/27.
//  Copyright © 2019 Bruce. All rights reserved.
//  业务端处理消息的管理类，单利的方式实现

#import "PhotonMessageCenter.h"
#import <MMKV/MMKV.h>
#import "PhotonFileUploadManager.h"
#import "PhotonDownLoadFileManager.h"
#import "PhotonDBManager.h"
#import "PhotonNetworkService.h"
#import "PhotonCharBar.h"
#import <PhotonIMSDK/PhotonIMSDK.h>
static PhotonMessageCenter *center = nil;
@interface PhotonMessageCenter()<PhotonIMClientProtocol>
@property (nonatomic, strong, nullable)PhotonNetworkService *netService;
@property (nonatomic, strong, nullable) PhotonIMClient *imClient;
@property (nonatomic, strong, nullable) NSHashTable *observers;

@property (nonatomic, assign) NSInteger unreadCount;


// 处理已读相关
@property (nonatomic, strong, nullable)PhotonIMThreadSafeArray *readMsgIdscCache;
@property (nonatomic, strong, nullable)NSDictionary*readMsgIdscDict;
@property (nonatomic, strong, nullable)PhotonIMTimer   *timer;

@property (nonatomic, strong,nullable) NSMutableArray<PhotonIMMessage *> *messages;
@end

#define TOKENKEY [NSString stringWithFormat:@"photonim_token_%@",[PhotonContent currentUser].userID]
@implementation PhotonMessageCenter
+ (instancetype)sharedCenter{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[self alloc] init];
        [[PhotonIMClient sharedClient] addObservers:center];
       
    });
    return center;
}
- (void)handleAppWillEnterForegroundNotification:(id)enter{
}

- (void)initPhtonIMSDK{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppWillEnterForegroundNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    PhotonIMServerType serverType = [PhotonContent getServerSwitch];
   [[PhotonIMClient sharedClient] setServerType:serverType];
//#ifdef DEBUG
    // 是否在写log时开启控制台日志输出，debug模式下建议开启
    [[PhotonIMClient sharedClient] openPhotonIMLog:YES];
    
//     是否开启断言，debug模式下推荐开启
    [[PhotonIMClient sharedClient] setAssertEnable:NO];
//#else
//    [[PhotonIMClient sharedClient] openPhotonIMLog:NO];
//    [[PhotonIMClient sharedClient] setAssertEnable:NO];
//#endif
    
    // 通过注册appid 完成sdk的初始化
    if (serverType == PhotonIMServerTypeInland) {
        [[PhotonIMClient sharedClient] registerIMClientWithAppid:APP_ID_INLAND];
    }else if (serverType == PhotonIMServerTypeOverseas){
         [[PhotonIMClient sharedClient] registerIMClientWithAppid:APP_ID_OVERSEAS];
    }
    
    // 指定使用sdk内的数据库模式，推荐使用异步模式
    [[PhotonIMClient sharedClient] setPhotonIMDBMode:PhotonIMDBModeDBAsync];
    [[PhotonIMClient sharedClient] supportGroup];
    
}

- (void)login{
    // 客户端登录后
    [[PhotonIMClient sharedClient] bindCurrentUserId:[PhotonContent currentUser].userID];
    // 获取token
    [self getToken];
}

- (void)logout{
    
    [[PhotonIMClient sharedClient] logout];
    [[MMKV defaultMMKV] removeValueForKey:TOKENKEY];
    [PhotonContent logout];
}

- (NSInteger)unreadMsgCount{
    _unreadCount = [self.imClient getAllUnreadCount];
    return _unreadCount;
}

- (PhotonIMClient *)imClient{
    if (!_imClient) {
        _imClient = [PhotonIMClient sharedClient];
    }
    return _imClient;
}

- (NSHashTable *)observers{
    if (!_observers) {
        _observers = [NSHashTable weakObjectsHashTable];
    }
    return _observers;
}

- (void)addObserver:(id<PhotonMessageProtocol>)target{
    if (![self.observers containsObject:target]) {
        [self.observers addObject:target];
    }
    if (self.imClient) {
        [self.imClient addObservers:target];
    }
}

- (void)removeObserver:(id<PhotonMessageProtocol>)target{
    if ([self.observers containsObject:target]) {
        [self.observers removeObject:target];
    }
    if (self.imClient) {
        [self.imClient removeObserver:target];
    }
}

- (void)removeAllObserver{
    [self.observers removeAllObjects];
    if (self.imClient) {
        [self.imClient removeAllObservers];
    }
}

- (void)sendTextMessage:(PhotonChatTextMessageItem *)item conversation:(nullable PhotonIMConversation *)conversation completion:(nullable CompletionBlock)completion{
    
    // 文本消息，直接构建文本消息对象发送
    PhotonIMMessage *message = [PhotonIMMessage commonMessageWithFrid:[PhotonContent currentUser].userID toid:conversation.chatWith messageType:PhotonIMMessageTypeRaw chatType:conversation.chatType];
//    NSMutableArray *uids = [[NSMutableArray alloc] init];
//    for (PhotonChatAtInfo *atInfo in item.atInfo) {
//        if ([atInfo.userid isNotEmpty]) {
//            [uids addObject:atInfo.userid ];
//        }
//    }
//    [message setAtInfoWithAtType:(PhotonIMAtType)(item.type) atList:uids];
//    PhotonIMTextBody *body = [[PhotonIMTextBody alloc] initWithText:item.messageText];
    
    PhotonIMCustomBody *body = [PhotonIMCustomBody customBodyWithArg1:100 arg2:100 customData:[NSData new]];
    [message setMesageBody:body];
    item.userInfo = message;
    
    
    [self _sendMessage:message completion:completion];
    
}

- (void)sendTex:(NSString *)text conversation:(nullable PhotonIMConversation *)conversation completion:(nullable CompletionBlock)completion{
    
    // 文本消息，直接构建文本消息对象发送
    PhotonIMMessage *message = [PhotonIMMessage commonMessageWithFrid:[PhotonContent currentUser].userID toid:conversation.chatWith messageType:PhotonIMMessageTypeText chatType:conversation.chatType];
    NSMutableArray *uids = [[NSMutableArray alloc] init];
    [message setAtInfoWithAtType:PhotonIMAtTypeNoAt atList:uids];
    PhotonIMTextBody *body = [[PhotonIMTextBody alloc] initWithText:text];
    [message setMesageBody:body];
    
    [self _sendMessage:message completion:completion];
    
}

- (void)sendImageMessage:(PhotonChatImageMessageItem *)item conversation:(nullable PhotonIMConversation *)conversation completion:(nullable CompletionBlock)completion{
    // 文本消息，直接构建文本消息对象发送
    PhotonIMMessage *message = [PhotonIMMessage commonMessageWithFrid:[PhotonContent currentUser].userID toid:conversation.chatWith messageType:PhotonIMMessageTypeImage chatType:conversation.chatType];
    
    PhotonIMImageBody *body = [[PhotonIMImageBody alloc] init];
    body.localFileName = item.fileName;
    body.whRatio = item.whRatio;
    [message setMesageBody:body];
    item.userInfo = message;
    
    // 先做图片上传处理，获得资源地址后构建图片消息对象发送消息
    [self p_sendImageMessage:message completion:completion];
}

- (void)sendVoiceMessage:(PhotonChatVoiceMessageItem *)item conversation:(nullable PhotonIMConversation *)conversation completion:(nullable CompletionBlock)completion{
    
    PhotonIMMessage *message = [PhotonIMMessage commonMessageWithFrid:[PhotonContent currentUser].userID toid:conversation.chatWith messageType:PhotonIMMessageTypeAudio chatType:conversation.chatType];
    
    PhotonIMAudioBody *body = [[PhotonIMAudioBody alloc] init];
    body.localFileName = item.fileName;
    body.mediaTime = item.duration;
    [message setMesageBody:body];
    item.userInfo = message;
    
    [[PhotonMessageCenter sharedCenter] insertOrUpdateMessage:message];
    // 先做语音上传处理，获得资源地址后构建图片消息对象发送消息
    [self p_sendVoiceMessage:message completion:completion];
}

- (void)sendVideoMessage:(nullable PhotonChatVideoMessageItem *)item conversation:(nullable PhotonIMConversation *)conversation completion:(nullable CompletionBlock)completion{
      PhotonIMMessage *message = [PhotonIMMessage commonMessageWithFrid:[PhotonContent currentUser].userID toid:conversation.chatWith messageType:PhotonIMMessageTypeVideo chatType:conversation.chatType];
    PhotonIMVideoBody *body = [[PhotonIMVideoBody alloc] init];
    body.localFileName = item.fileName;
    body.mediaTime = item.duration;
    [message setMesageBody:body];
    item.userInfo = message;
    [[PhotonMessageCenter sharedCenter] insertOrUpdateMessage:message];
    [self p_sendVideoMessage:message completion:^(BOOL succeed, PhotonIMError * _Nullable error) {
        
    }];
    
}

- (void)sendLocationMessage:(PhotonChatLocationItem *)item conversation:(nullable PhotonIMConversation *)conversation completion:(nullable CompletionBlock)completion{
     PhotonIMMessage *message = [PhotonIMMessage commonMessageWithFrid:[PhotonContent currentUser].userID toid:conversation.chatWith messageType:PhotonIMMessageTypeLocation chatType:conversation.chatType];
    
    PhotonIMLocationBody *locationBody = [PhotonIMLocationBody locationBodyWithCoordinateSystem:CoordinateSystem_BD09 address:item.address detailedAddress:item.detailAddress lng:item.locationCoordinate.longitude lat:item.locationCoordinate.latitude];
    [message setMesageBody:locationBody];
    item.userInfo = message;
    [self _sendMessage:message completion:completion];
}


#pragma mark  -------- Private ---------------
- (void)p_sendImageMessage:(PhotonIMMessage *)message completion:(nullable CompletionBlock)completion{
    // 存储文件上传前的message
    [[PhotonMessageCenter sharedCenter] insertOrUpdateMessage:message];
    // 先做图片上传处理，获得资源地址后构建图片消息对象发送消息
    PhotonIMImageBody *body =(PhotonIMImageBody *)message.messageBody;
    PhotonUploadFileInfo *fileInfo = [[PhotonUploadFileInfo alloc]init];
    fileInfo.name = @"fileUpload";
    fileInfo.fileName = @"chatimage.jpg";
    fileInfo.mimeType = @"image/jpeg";
    fileInfo.fileURLString = [[PhotonMessageCenter sharedCenter] getImageFilePath:message.chatWith fileName:body.localFileName];
    PhotonWeakSelf(self)
    [[PhotonFileUploadManager defaultManager] uploadRequestMethodWithMutiFile:PHOTON_IMAGE_UPLOAD_PATH paramter:nil header:@{} fromFiles:@[fileInfo] progressBlock:^(NSProgress * _Nonnull progress) {
    } completion:^(NSDictionary * _Nonnull dict) {
        [weakself p_sendMessag:message result:dict completion:completion];
    } failure:^(PhotonErrorDescription * _Nonnull error) {
        [weakself p_sendMessag:message result:nil completion:completion];
    }];
}

- (void)p_sendVoiceMessage:(PhotonIMMessage *)message completion:(nullable CompletionBlock)completion{
    // 存储文件上传前的message
    [[PhotonMessageCenter sharedCenter] insertOrUpdateMessage:message];
    // 先做图片上传处理，获得资源地址后构建图片消息对象发送消息
    PhotonIMAudioBody *body =(PhotonIMAudioBody *)message.messageBody;
    PhotonUploadFileInfo *fileInfo = [[PhotonUploadFileInfo alloc]init];
    fileInfo.name = @"fileUpload";
    fileInfo.fileName = @"chataudio.opus";
    fileInfo.mimeType = @"audio/opus";
    fileInfo.fileURLString = [[PhotonMessageCenter sharedCenter] getVoiceFilePath:message.chatWith fileName:body.localFileName];
    PhotonWeakSelf(self)
    [[PhotonFileUploadManager defaultManager] uploadRequestMethodWithMutiFile:PHOTON_AUDIO_UPLOAD_PATH  paramter:nil header:@{} fromFiles:@[fileInfo] progressBlock:^(NSProgress * _Nonnull progress) {
    } completion:^(NSDictionary * _Nonnull dict) {
        [weakself p_sendMessag:message result:dict completion:completion];
    } failure:^(PhotonErrorDescription * _Nonnull error) {
        [weakself p_sendMessag:message result:nil completion:completion];
    }];
}

- (void)p_sendMessag:(PhotonIMMessage *)message result:(NSDictionary *)result completion:(nullable CompletionBlock)completion{
    NSString *fileURL = [[[[result objectForKey:@"data"] isNil] objectForKey:@"url"] isNil];
    if (!message) {
        return;
    }
    if ([fileURL isNotEmpty]) {
        if(message.messageType == PhotonIMMessageTypeImage){
            PhotonIMImageBody *body = (PhotonIMImageBody *)message.messageBody;
            body.url = fileURL;
            [message setMesageBody:body];
        }else if(message.messageType == PhotonIMMessageTypeAudio){
            PhotonIMAudioBody *body = (PhotonIMAudioBody *)message.messageBody;
            body.url = fileURL;
        }
        // 文件下载成功
        if (completion) {
            completion(YES,nil);
        }
        [self _sendMessage:message completion:completion];
    }else{
        message.messageStatus = PhotonIMMessageStatusFailed;
        [self insertOrUpdateMessage:message];
        PhotonIMError *error = [PhotonIMError errorWithDomain:@"photoimdomain" code:-1 errorMessage:@"文件上传失败" userInfo:@{}];
        if (completion) {
            completion(NO,error);
        }
        
    }
}

- (void)p_sendVideoMessage:(PhotonIMMessage *)message completion:(nullable CompletionBlock)completion{
    // 存储文件上传前的message
    [[PhotonMessageCenter sharedCenter] insertOrUpdateMessage:message];
    // 先做图片上传处理，获得资源地址后构建图片消息对象发送消息
    PhotonIMVideoBody *body =(PhotonIMVideoBody *)message.messageBody;
    PhotonUploadFileInfo *fileInfo = [[PhotonUploadFileInfo alloc]init];
    fileInfo.name = @"file";
    fileInfo.fileName = @"chataudio.mp4";
    fileInfo.mimeType = @"video/mp4";
    fileInfo.fileURLString = [[PhotonMessageCenter sharedCenter] getVoiceFilePath:message.chatWith fileName:body.localFileName];
    PhotonWeakSelf(self)
    NSString *appId = @"";
     PhotonIMServerType serverType = [PhotonContent getServerSwitch];
    if (serverType == PhotonIMServerTypeInland) {
            appId = APP_ID_INLAND;
       }else if (serverType == PhotonIMServerTypeOverseas){
           appId = APP_ID_OVERSEAS;
       }
       
    // 处理header
      NSMutableDictionary *header = [NSMutableDictionary dictionary];
      [header setValue:appId forKey:@"appId"];
      NSString *timestamp = [NSString stringWithFormat:@"%@",@((int64_t)[NSDate date].timeIntervalSince1970)];
      [header setValue:timestamp forKey:@"timestamp"];
     NSString *token = [[MMKV defaultMMKV] getStringForKey:TOKENKEY defaultValue:@""];
      NSString *signString = [NSString stringWithFormat:@"%@%@%@",appId,token,timestamp];
      signString = [signString md5];
      [header setValue:signString forKey:@"sign"];
      [header setValue:[PhotonContent currentUser].userID forKey:@"userId"];
      [header setValue:token forKey:@"Token"];
    // 处理parameter
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setValue:@"1" forKey:@"fileType"];
    [paramter setValue:@(1) forKey:@"coverOffset"];
    
    [[PhotonFileUploadManager defaultManager] uploadRequestMethodWithMutiFile:PHOTON_FILE_UPLOAD_PATH paramter:paramter header:header fromFiles:@[fileInfo] progressBlock:^(NSProgress * _Nonnull progress) {
        
    } completion:^(NSDictionary * _Nonnull dict) {
        
        [weakself p_sendMessag:message result:dict completion:completion];
        
    } failure:^(PhotonErrorDescription * _Nonnull error) {
        
        [weakself p_sendMessag:message result:nil completion:completion];
    }];
}

// 重发消息
- (void)resendMessage:(nullable PhotonChatBaseItem *)item completion:(nullable CompletionBlock)completion{
    PhotonIMMessage *message = (PhotonIMMessage *)item.userInfo;
    if(message.messageStatus != PhotonIMMessageStatusDefault){
        message.messageStatus = PhotonIMMessageStatusSending;
    }
    // 文件发送
    if (completion) {
        completion(YES,nil);
    }
    if(message.messageType == PhotonIMMessageTypeImage || message.messageType == PhotonIMMessageTypeAudio){
        PhotonIMBaseBody *body = message.messageBody;
        if ([body.url isNotEmpty]) {// 文件上传完成，直接发送
            [self _sendMessage:message completion:completion];
        }else{// 文件上传未完成，先上再发送
            if (message.messageType == PhotonIMMessageTypeImage) {
                [self p_sendImageMessage:message completion:completion];
            }else if (message.messageType == PhotonIMMessageTypeAudio){
                [self p_sendVoiceMessage:message completion:completion];
            }
        }
    }else if(message.messageType == PhotonIMMessageTypeText){//文本直接发送
        [self _sendMessage:message completion:completion];
    }
}

// 重新发送未发送完成的消息
- (void)reSendAllSendingMessages{
    if(self.messages){
        __weak typeof(self)weakSelf = self;
        NSArray<PhotonIMMessage *> *messages = [self.messages copy];
        for(PhotonIMMessage *message in messages){
            message.timeStamp = [[NSDate date] timeIntervalSince1970] * 1000.0;
            if(message.messageType == PhotonIMMessageTypeImage || message.messageType == PhotonIMMessageTypeAudio){
                PhotonIMBaseBody *body = message.messageBody;
                if ([body.url isNotEmpty]) {// 文件上传完成，直接发送
                    [self _sendMessage:message completion:^(BOOL succeed, PhotonIMError * _Nullable error) {
                        if (succeed) {
                             [weakSelf.messages removeObject:message];
                        }
                       
                    }];
                }else{// 文件上传未完成，先上再发送
                    if (message.messageType == PhotonIMMessageTypeImage) {
                        [self p_sendImageMessage:message completion:^(BOOL succeed, PhotonIMError * _Nullable error) {
                            if (succeed) {
                                [weakSelf.messages removeObject:message];
                            }
                        }];
                    }else if (message.messageType == PhotonIMMessageTypeAudio){
                        [self p_sendVoiceMessage:message completion:^(BOOL succeed, PhotonIMError * _Nullable error) {
                            if (succeed) {
                                [weakSelf.messages removeObject:message];
                            }
                        }];
                    }
                }
            }else if(message.messageType == PhotonIMMessageTypeText){//文本直接发送
                [self _sendMessage:message completion:nil];
            }
        }
    }
   
}

// 发送已读消息
- (void)sendReadMessage:(NSArray<NSString *> *)readMsgIDs conversation:(nullable PhotonIMConversation *)conversation completion:(nullable CompletionBlock)completion{
    if (conversation.chatType != PhotonIMChatTypeSingle) {
        return;
    }
    [self.imClient sendReadMessage:readMsgIDs fromid:[PhotonContent currentUser].userID toid:conversation.chatWith completion:^(BOOL succeed, PhotonIMError * _Nullable error) {
        [PhotonUtil runMainThread:^{
            if (completion) {
                completion(succeed,error);
            }
        }];
    }];
}
- (void)sendWithDrawMessage:(nullable PhotonChatBaseItem *)item completion:(nullable CompletionBlock)completion{
    id message = item.userInfo;
    if ([message isKindOfClass:[PhotonIMMessage class]]) {
        [self.imClient sendWithDrawMessage:message completion:^(BOOL succeed, PhotonIMError * _Nullable error) {
            [PhotonUtil runMainThread:^{
                if (completion) {
                    completion(succeed,error);
                }
            }];
        }];
    }
}

- (PhotonIMMessage *)transmitMessage:(nullable PhotonIMMessage *)message conversation:(nullable PhotonIMConversation *)conversation completion:(nullable CompletionBlock)completion{
    // 文件操作，转发时将文件拷贝到转发的会话下
    if (message.messageType == PhotonIMMessageTypeImage || message.messageType == PhotonIMMessageTypeAudio) {
        PhotonIMMediaBody *imgBody = (PhotonIMMediaBody *)message.messageBody;
        NSString *fileName = imgBody.localFileName;
        NSString *originFilePath = [self getImageFilePath:message.chatWith fileName:fileName];
        if ([PhotonUtil jugdeFileExit:originFilePath]) {
            NSString *desFilePath = [self getImageFilePath:conversation.chatWith fileName:fileName];
            if (![originFilePath isEqualToString:desFilePath]) {
                NSError *error;
                [[NSFileManager defaultManager] copyItemAtPath:originFilePath toPath:desFilePath error:&error];
            } 
        }
    }
    
    PhotonIMMessage *sendMessage = [[PhotonIMMessage alloc] init];
    sendMessage.chatWith = conversation.chatWith;
    sendMessage.chatType = conversation.chatType;
    sendMessage.fr = [PhotonContent currentUser].userID;
    sendMessage.to = conversation.chatWith;
    sendMessage.timeStamp = [[NSDate date] timeIntervalSince1970] * 1000.0;
    sendMessage.messageType = message.messageType;
    sendMessage.messageStatus = PhotonIMMessageStatusSending;
    [sendMessage setMesageBody:message.messageBody];
    [self _sendMessage:sendMessage completion:completion];
    return sendMessage;
}

- (void)_sendMessage:(nullable PhotonIMMessage *)message completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion{
    PhotonWeakSelf(self);
    [[PhotonIMClient sharedClient] sendMessage:message completion:^(BOOL succeed, PhotonIMError * _Nullable error) {
        [PhotonUtil runMainThread:^{
            if (!succeed && error.code >= 1000) {
                message.notic = error.em;
            }
            if (completion) {
                completion(succeed,error);
            }else{
                NSHashTable *_observer = [weakself.observers copy];
                for (id<PhotonMessageProtocol> observer in _observer) {
                    if (observer && [observer respondsToSelector:@selector(sendMessageResultCallBack:)]) {
                        [observer sendMessageResultCallBack:message];
                    }
                }
            }
        }];
    }];
}


- (void)sendAddGrupNoticeMessage:(nullable PhotonIMMessage *)message completion:(nullable CompletionBlock)completion{
    [[PhotonIMClient sharedClient] sendMessage:message completion:^(BOOL succeed, PhotonIMError * _Nullable error) {
        [PhotonUtil runMainThread:^{
            if (completion) {
                completion(succeed,error);
            }
        }];
    }];
}

- (void)clearMessagesWithChatType:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith syncServer:(BOOL)syncServer completion:(void(^)(BOOL finish))completion{
    if (!syncServer) {
        [self clearMessagesWithChatType:chatType chatWith:chatWith];
    }else{
        [self  clear:@"" chatType:chatType chatWith:chatWith completion:completion];
    }
}

- (void)clear:(NSString *)anchorMsgId chatType:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith completion:(void(^)(BOOL finish))completion{
    PhotonWeakSelf(self)
    [self.imClient loadHistoryMessages:chatType chatWith:chatWith anchor:anchorMsgId size:100 reaultBlock:^(NSArray<PhotonIMMessage *> * _Nullable messages, NSString * _Nullable an, BOOL remainHistoryInServer) {
        if (!messages || messages.count == 0) {
            if (completion) {
                completion(YES);
            }
            return;
        }
        NSMutableArray *msgIds = [NSMutableArray arrayWithCapacity:messages.count];
        for (PhotonIMMessage *msg in messages) {
            [msgIds addObject:msg.messageID];
        }
        [weakself.imClient sendDeleteMessageWithChatType:chatType chatWith:chatWith delMsgIds:msgIds completion:^(BOOL succeed, PhotonIMError * _Nullable error) {
            if (!succeed) {
                if (completion) {
                    completion(NO);
                }
                return;
            }else{
                [weakself clear:an chatType:chatType chatWith:chatWith completion:completion];
            }
            
        }];
    }];
              
}

#pragma mark ---  数据操作相关 -----
- (void)insertOrUpdateMessage:(PhotonIMMessage *)message{
    [self.imClient insertOrUpdateMessage:message updateConversion:YES];
}
- (void)deleteMessage:(PhotonIMMessage *)message{
    [self.imClient deleteMessage:message];
}
- (void)deleteMessage:(PhotonIMMessage *)message completion:(nullable void(^)(BOOL succeed, PhotonIMError * _Nullable error ))completion{
    [self.imClient sendDeleteMessageWithChatType:message.chatType chatWith:message.chatWith delMsgIds:@[message.messageID] completion:completion];
}
- (void)deleteConversation:(PhotonIMConversation *)conversation clearChatMessage:(BOOL)clearChatMessage{
    [self.imClient deleteConversation:conversation clearChatMessage:clearChatMessage];
    if (clearChatMessage) {// 删除文件夹下的所有文件
        [self deleteAllFile:conversation.chatWith];
    }
    
}
- (void)clearConversationUnReadCount:(PhotonIMConversation *)conversation{
    [self.imClient clearConversationUnReadCount:conversation.chatType chatWith:conversation.chatWith];
}
- (void)updateConversationIgnoreAlert:(PhotonIMConversation *)conversation{
    [self.imClient updateConversationIgnoreAlert:conversation];
}

- (void)resetAtType:(PhotonIMConversation *)conversation{
    [self.imClient updateConversationAtType:conversation.chatType chatWith:conversation.chatWith atType:PhotonIMConversationAtTypeNoAt];
}
- (PhotonIMConversation *)findConversation:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith{
    return [self.imClient findConversation:chatType chatWith:chatWith];
}

- (void)alterConversationDraft:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith draft:(NSString *)draft{
    [self.imClient alterConversationDraft:chatType chatWith:chatWith draft:draft];
}

- (void)clearMessagesWithChatType:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith{
    [self.imClient clearMessagesWithChatType:chatType chatWith:chatWith];
}

#pragma mark --------- 文件操作相关 ----------------

- (NSString *)getVoiceFilePath:(NSString *)chatWith fileName:(nullable NSString *)fileName{
    if(!fileName || fileName.length == 0){
        return nil;
    }
    NSString *path = [NSString stringWithFormat:@"%@/PhotonIM/File/%@/%@/voices", [NSFileManager documentsPath], [PhotonContent currentUser].userID,chatWith];
    if (![PhotonUtil createDirectoryIfExit:path]) {
        return nil;
    }
    return [path stringByAppendingPathComponent:fileName];
}

- (NSURL *)getVideoFileURL:(NSString *)chatWith fileName:(nullable NSString *)fileName{
    if(!fileName || fileName.length == 0){
        return nil;
    }
    NSString * path =  [self getVoiceFilePath:chatWith fileName:fileName];
    if ([path isNotEmpty]) {
        return [NSURL fileURLWithPath:path];
    }
    return nil;
}

- (NSString *)getVideoFilePath:(NSString *)chatWith fileName:(nullable NSString *)fileName{
    if(!fileName || fileName.length == 0){
        return nil;
    }
    NSString *path = [NSString stringWithFormat:@"%@/PhotonIM/File/%@/%@/videos", [NSFileManager documentsPath], [PhotonContent currentUser].userID,chatWith];
    if (![PhotonUtil createDirectoryIfExit:path]) {
        return nil;
    }
    return [path stringByAppendingPathComponent:fileName];
}

- (NSURL *)getVoiceFileURL:(NSString *)chatWith fileName:(nullable NSString *)fileName{
    if(!fileName || fileName.length == 0){
        return nil;
    }
    NSString * path =  [self getVoiceFilePath:chatWith fileName:fileName];
    if ([path isNotEmpty]) {
        return [NSURL fileURLWithPath:path];
    }
    return nil;
}

- (NSString *)getImageFilePath:(NSString *)chatWith fileName:(nullable NSString *)fileName{
    if(!fileName || fileName.length == 0){
        return nil;
    }
    NSString *path = [NSString stringWithFormat:@"%@/PhotonIM/File/%@/%@/images", [NSFileManager documentsPath], [PhotonContent currentUser].userID,chatWith];
    if (![PhotonUtil createDirectoryIfExit:path]) {
        return nil;
    }
    return [path stringByAppendingPathComponent:fileName];
}
- (NSURL *)getImageFileURL:(NSString *)chatWith fileName:(nullable NSString *)fileName{
    if(!fileName || fileName.length == 0){
        return nil;
    }
    NSString * path =  [self getImageFilePath:chatWith fileName:fileName];
    if ([path isNotEmpty]) {
        return [NSURL fileURLWithPath:path];
    }
    return nil;
}

- (BOOL)deleteVoiceFile:(NSString *)chatWith fileName:(nullable NSString *)fileName{
    if(!fileName || fileName.length == 0){
        return NO;
    }
    NSString *path = [self getVoiceFilePath:chatWith fileName:fileName];
    bool res = [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    return res;
}

- (BOOL)deleteImageFile:(NSString *)chatWith fileName:(nullable NSString *)fileName{
    if(!fileName || fileName.length == 0){
        return NO;
    }
    NSString *path = [self getImageFilePath:chatWith fileName:fileName];
    bool res = [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    return res;
}

- (BOOL)deleteAllFile:(NSString *)chatWith{
     NSString *path = [NSString stringWithFormat:@"%@/PhotonIM/File/%@/%@/", [NSFileManager documentsPath], [PhotonContent currentUser].userID,chatWith];
    bool res = [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    return res;
}

- (void)imClient:(id)client didReceiveCustomMesage:(PhotonIMMessage *)message{
    [PhotonUtil showInfoHint:@"这是自定义消息"];
}

#pragma mark --------- 消息接收相关 ----------------

- (void)imClientLogin:(nonnull id)client failedType:(PhotonIMLoginFailedType)failedType {
    switch (failedType) {
        case PhotonIMLoginFailedTypeTokenError:
        case PhotonIMLoginFailedTypeParamterError:{
            NSLog(@"[pim]:PhotonIMLoginFailedTypeTokenError or PhotonIMLoginFailedTypeParamterError");
            [self reGetToken];
        }
            break;
        case PhotonIMLoginFailedTypeKick:{
            [self logout];
        }
            break;
        default:
            break;
    }
}



- (void)networkChange:(PhotonIMNetworkStatus)networkStatus {
}

- (BOOL)imClientSync:(nonnull id)client syncStatus:(PhotonIMSyncStatus)status {
    return YES;
}

- (void)imClient:(id)client sendResultWithMsgID:(NSString *)msgID chatType:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith error:(PhotonIMError *)error{
    NSLog(@"[pim sendResultWithMsgID msgID=%@,chatType=%@,chatWith=%@,errorCode=%@",msgID,@(chatType),chatWith,@(error.code));
}

- (PhotonIMForbidenAutoResendType)messageWillBeAutoResend{
    return PhotonIMForbidenAutoResendTypeNO;
}


#pragma mark ---- 登录相关 ----
- (void)reGetToken{
     NSLog(@"[pim]:reGetToken");
    [[MMKV defaultMMKV] setString:@"" forKey:TOKENKEY];
    [self getToken];
}
- (void)getToken{
    id en = [[NSUserDefaults standardUserDefaults] objectForKey:@"photon_im_forbid_uploadLog"];
    NSDictionary *extra = @{};
    if(en){
        extra = @{@"photon_im_forbid_uploadLog":[NSString stringWithFormat:@"%@",en]};
    }
    NSString *token = [[MMKV defaultMMKV] getStringForKey:TOKENKEY defaultValue:@""];
    if ([token isNotEmpty]) {
         [[PhotonIMClient sharedClient] loginWithToken:token extra:extra];
    }else{
        NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
        [self.netService commonRequestMethod:PhotonRequestMethodPost queryString:PHOTON_TOKEN_PATH paramter:paramter completion:^(NSDictionary * _Nonnull dict) {
            NSString *token = [[dict objectForKey:@"data"] objectForKey:@"token"];
            [[MMKV defaultMMKV] setString:token forKey:TOKENKEY];
            [[PhotonIMClient sharedClient] loginWithToken:token extra:extra];
            PhotonLog(@"[pim] dict = %@",dict);
        } failure:^(PhotonErrorDescription * _Nonnull error) {
            PhotonLog(@"[pim] error = %@",error.errorMessage);
            [PhotonUtil showAlertWithTitle:@"Token获取失败" message:error.errorMessage];
            [self logout];
        }];
    }
}

- (PhotonNetworkService *)netService{
    if (!_netService) {
        _netService = [[PhotonNetworkService alloc] init];
        _netService.baseUrl = [PhotonContent baseUrlString];;
        
    }
    return _netService;
}
@end
