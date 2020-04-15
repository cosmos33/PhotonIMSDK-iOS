//
//  PhotonGroup.h
//  PhotonIM
//
//  Created by Bruce on 2019/9/23.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotonGroup : NSObject
@property(nonatomic, copy, nullable)NSString *gid;
@property(nonatomic, copy, nullable)NSString *gname;
@property(nonatomic, copy, nullable)NSString *gavatar;
@end

NS_ASSUME_NONNULL_END
