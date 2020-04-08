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
@interface PhotonIMLocationBody : PhotonIMBaseBody
@property(nonatomic,assign)CoordinateSystem coordinateSystem;// 坐标系类型
@property(nonatomic,copy)NSString *address;// 坐标地址名称
@property(nonatomic,copy)NSString *detailedAddress;// 坐标详细地址名称
@property(nonatomic,assign)double lng;// 经度
@property(nonatomic,assign)double lat;// 纬度

/// 构建PhotonIMLocationBody对象
/// @param coordinateSystem 坐标系系统，默认使用CoordinateSystem_WGS84
/// @param address 地址
/// @param detailedAddress 地址详情
/// @param lng 经度
/// @param lat 纬度
+(PhotonIMLocationBody *)locationBodyWithCoordinateSystem:(CoordinateSystem)coordinateSystem
                                                address:(nullable NSString *)address
                                        detailedAddress:(nullable NSString *)detailedAddress
                                                    lng:(double)lng lat:(double)lat;
@end

NS_ASSUME_NONNULL_END
