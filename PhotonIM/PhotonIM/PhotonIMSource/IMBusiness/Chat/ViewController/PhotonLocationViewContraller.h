//
//  PhotonLocationViewContraller.h
//  PhotonIM
//
//  Created by Bruce on 2020/1/10.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "PhotonBaseViewController.h"
#import "PhotonChatTransmitListViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface PhotonLocationViewContraller : PhotonBaseViewController
@property (nonatomic, copy) void (^sendCompletion)(CLLocationCoordinate2D aCoordinate, NSString  *_Nullable address, NSString * _Nullable detailAddress);
- (instancetype)initWithLocation:(PhotonChatLocationItem *)locationItem;

- (void)setActionBlock:(void(^)(void))actionBlock;
@end

NS_ASSUME_NONNULL_END
