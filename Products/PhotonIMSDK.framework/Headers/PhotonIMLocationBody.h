//
//  PhotonIMLocationBody.h
//  PhotonIMSDK
//
//  Created by Bruce on 2020/1/7.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotonIMBaseBody.h"
NS_ASSUME_NONNULL_BEGIN


typedef enum{
    CoordinateSystem_WGS84 = 0,
    CoordinateSystem_GCJ02 = 1,
    CoordinateSystem_BD09 = 2
} CoordinateSystem;

/// 位置消息的消息体，构建此消息体发送位置消息，其对应的消息类型是PhotonIMMessageType::PhotonIMMessageTypeLocation
@interface PhotonIMLocationBody : PhotonIMBaseBody
@property(nonatomic,assign)CoordinateSystem coordinateSystem;// 坐标系类型
@property(nonatomic,copy)NSString *address;// 坐标地址名称
@property(nonatomic,copy)NSString *detailedAddress;// 坐标详细地址名称
@property(nonatomic,assign)double lng;// 经度
@property(nonatomic,assign)double lat;// 纬度


/// 遍历构造LocationBody
/// @param coordinateSystem 坐标系类型
/// @param address 坐标地址名称
/// @param detailedAddress 坐标详细地址名称
/// @param lng  经度
/// @param lat 纬度
+(PhotonIMLocationBody *)locationBodyWithCoordinateSystem:(CoordinateSystem)coordinateSystem
                                                address:(nullable NSString *)address
                                        detailedAddress:(nullable NSString *)detailedAddress
                                                    lng:(double)lng lat:(double)lat;

/// 遍历构造LocationBody
/// @param coordinateSystem 坐标系类型
/// @param address 坐标地址名称
/// @param detailedAddress 坐标详细地址名称
/// @param lng  经度
/// @param lat 纬度
/// @param srcDescription  资源描述，此字段会入库，内容可作为全文搜索使用
+(PhotonIMLocationBody *)locationBodyWithCoordinateSystem:(CoordinateSystem)coordinateSystem
                                                address:(nullable NSString *)address
                                        detailedAddress:(nullable NSString *)detailedAddress
                                                    lng:(double)lng lat:(double)lat
                                           srcDescription:(nullable NSString *)srcDescription;

@end

NS_ASSUME_NONNULL_END
