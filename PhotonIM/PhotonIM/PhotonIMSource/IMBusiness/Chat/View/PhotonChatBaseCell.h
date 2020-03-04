//
//  PhotonBaseChatCell.h
//  PhotonIM
//
//  Created by Bruce on 2019/6/21.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Masonry/Masonry.h>
#import "PhotonTableViewCell.h"
#import "PhotonChatBaseItem.h"
NS_ASSUME_NONNULL_BEGIN
@class PhotonChatBaseCell;
@protocol PhotonBaseChatCellDelegate <NSObject>

@optional
/**
 点击头像事件代理

 @param cell <#cell description#>
 */
- (void)chatCell:(PhotonChatBaseCell *)cell didSelectAvatar:(nullable PhotonChatBaseItem *)chatItem;
/**
 重发状态

 @param cell <#cell description#>
 */
- (void)chatCell:(PhotonChatBaseCell *)cell resendChatMessage:(nullable PhotonChatBaseItem *)chatItem;

/**
 长按事件，处理

 @param chatItem chatItem description
 @param rect <#rect description#>
 */
- (void)chatCell:(PhotonChatBaseCell *)cell chatMessageCellLongPress:(nullable PhotonChatBaseItem *)chatItem rect:(CGRect)rect;


/**
 单击事件

 @param chatItem <#chatItem description#>
 */
- (void)chatCell:(PhotonChatBaseCell *)cell chatMessageCellTap:(nullable PhotonChatBaseItem *)chatItem;
@end

@interface PhotonChatBaseCell : PhotonTableViewCell
@property (nonatomic, weak, nullable)id<PhotonBaseChatCellDelegate> delegate;
/**
 文字背景
 */
@property (nonatomic, strong, readonly, nullable)UIImageView *contentBackgroundView;

@property (nonatomic, strong, readonly, nullable)UIButton *avatarBtn;

@property (nonatomic, strong, readonly,nullable)UILabel  *timeLabel;

- (void)longPressBGView:(UIGestureRecognizer *)gestureRecognizer;

- (void)tapBackgroundView;
- (void)subview_layout;
@end

NS_ASSUME_NONNULL_END
