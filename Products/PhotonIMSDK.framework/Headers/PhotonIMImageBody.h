//
//  PhotonIMImageBody.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/6/28.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PhotonIMBaseBody.h"
NS_ASSUME_NONNULL_BEGIN
/// 图片消息的消息体，构建此消息体发送图片消息，其对应的消息类型是PhotonIMMessageType::PhotonIMMessageTypeImage
@interface PhotonIMImageBody : PhotonIMBaseBody
/**
 服务端缩略图地址
 */
@property (nonatomic, copy, nullable)NSString *thumbURL;

/**
 图片的宽高比
 */
@property (nonatomic, assign)CGFloat whRatio;

/// 遍历构造ImageBody
/// @param url 服务端保存的原图地址
/// @param thumbURL 服务端保存的缩略图地址
/// @param localFileName 文件本地存储相对路径
/// @param whRatio <#whRatio description#>
+ (PhotonIMImageBody *)imageBodyWithURL:(NSString *)url
                            thumbURL:(nullable NSString *)thumbURL
                               localFileName:(nullable NSString *)localFileName
                                whRatio:(CGFloat)whRatio;


/// 遍历构造ImageBody
/// @param url 服务端保存的原图地址
/// @param thumbURL 服务端保存的缩略图地址
/// @param localFileName 文件本地存储相对路径
/// @param whRatio <#whRatio description#>
/// @param srcDescription  资源描述，此字段会入库，内容可作为全文搜索使用
+ (PhotonIMImageBody *)imageBodyWithURL:(NSString *)url
                            thumbURL:(nullable NSString *)thumbURL
                               localFileName:(nullable NSString *)localFileName
                                whRatio:(CGFloat)whRatio
                         srcDescription:(nullable NSString *)srcDescription;
@end

NS_ASSUME_NONNULL_END
