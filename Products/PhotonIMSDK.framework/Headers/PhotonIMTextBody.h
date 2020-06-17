//
//  PhotonIMImageBody.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/6/28.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotonIMBaseBody.h"
NS_ASSUME_NONNULL_BEGIN


/// 文本消息的消息体，构建此消息体发送文本消息，其对应的消息类型是PhotonIMMessageType::PhotonIMMessageTypeText
@interface PhotonIMTextBody : PhotonIMBaseBody

/// 文本内容
@property (nonatomic, copy, readonly, nullable)NSString *text;

/// 使用文本内容初始化TextBody
/// @param text 文本内容
- (instancetype)initWithText:(NSString *)text;

/// 便利构造TextBody
/// @param text 文本内容
+ (PhotonIMTextBody *)textBodyWithText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
