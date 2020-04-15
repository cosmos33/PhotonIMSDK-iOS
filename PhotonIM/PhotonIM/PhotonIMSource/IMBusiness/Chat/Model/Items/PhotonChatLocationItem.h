//
//  PhotonLocationChatItem.h
//  PhotonIM
//
//  Created by Bruce on 2020/1/10.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonChatBaseItem.h"
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN

@interface PhotonChatLocationItem : PhotonChatBaseItem
@property(nonatomic, copy,nullable)NSString *address;
@property(nonatomic, copy,nullable)NSString *detailAddress;
@property(nonatomic, assign)CLLocationCoordinate2D locationCoordinate;
@end

NS_ASSUME_NONNULL_END
