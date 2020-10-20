//
//  PhotonChatPanelManager.h
//  PhotonIM
//
//  Created by Bruce on 2019/6/20.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "PhotonCharBar.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol PhotonChatPanelDelegate <NSObject>

@optional
// 聊天面板高度改变，控制相关视图的移动
- (void)scrollToBottomWithAnimation:(BOOL)animation;
// 发送文本，emoji信息
- (void)sendTextMessage:(NSString *)text atItems:(NSArray<PhotonChatAtInfo *>*)atItems type:(AtType)atType msgType:(int)msgType;

// 发送图片信息
- (void)sendImageMessage:(NSData *)imageData;
// 发送语音信息
- (void)sendVoiceMessage:(NSString *)fileName duraion:(CGFloat)duraion;

//  发送视频信息
- (void)sendVideoMessage:(NSString *)fileName duraion:(CGFloat)duraion;

//初始输入at的处理
- (void)processAtAction:(PhotonCharBar *)charBar;

// 发送位置
- (void)sendLocationMessage:(NSString *)address detailAddress:(NSString *)detailAddress locationCoordinate:(CLLocationCoordinate2D)locationCoordinate;

/**
* 编辑结束
*/
- (void)textViewDidEndEditing:(NSString *)text;

- (void)keyboardWillShow;
@end

@interface PhotonChatPanelManager : NSObject
@property(nonatomic, weak)id<PhotonChatPanelDelegate> delegate;
@property(nonatomic,strong,readonly)PhotonCharBar *chatBar;
@property(nonatomic,copy, nullable)NSString *draft;
- (instancetype)initWithIdentifier:(NSString *)identifier;
- (void)addChatPanelWithSuperView:(UIView *)superView;
- (void)dismissKeyboard;
@end

@interface MXPermissionCarmera:NSObject
+ (BOOL)isCarmeraPermissionOpen;
+ (BOOL)isPhotoPermissionOpen;
@end
NS_ASSUME_NONNULL_END
