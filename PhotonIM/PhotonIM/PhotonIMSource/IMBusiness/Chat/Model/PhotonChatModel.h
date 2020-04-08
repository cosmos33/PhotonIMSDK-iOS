//
//  PhotonChatModel.h
//  PhotonIM
//
//  Created by Bruce on 2019/6/21.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonBaseModel.h"
#import "PhotonMessageCenter.h"
#import "PhotonChatTextMessageItem.h"
#import "PhotonChatImageMessageItem.h"
#import "PhotonChatVoiceMessageItem.h"
#import "PhotonConversationItem.h"
#import "PhotonChatNoticItem.h"
#import "PhotonChatLocationItem.h"
#import "PhotonChatVideoMessageItem.h"
#import "PhotonChatFileMessageItem.h"
NS_ASSUME_NONNULL_BEGIN
@class PhotonIMMessage;
@interface PhotonChatModel : PhotonBaseModel
@property (nonatomic,copy,nullable)NSString *anchorMsgId;
@property(nonatomic, assign)BOOL loadFtsData;
- (void)loadMoreMeesages:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith beforeAuthor:(BOOL)beforeAnchor asc:(BOOL)asc finish:(void (^)(NSDictionary * _Nullable))finish;

- (void)loadMoreFtsMeesages:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith beforeAuthor:(BOOL)beforeAnchor asc:(BOOL)asc finish:(void (^)(NSDictionary * _Nullable))finish;

- (PhotonBaseTableItem *)wrapperMessage:(PhotonIMMessage *)message;

- (BOOL)wrapperWithdrawMessage:(PhotonIMMessage *)messag;

- (BOOL)wrapperReadMessage:(PhotonIMMessage *)message;
- (void)addItem:(id)item;

- (void)resetFtsSearch;

- (NSIndexPath *)getFtsSearchContentIndexpath;

- (NSInteger)getPageSize;
@end

NS_ASSUME_NONNULL_END
