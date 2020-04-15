//
//  PhotonAccountViewController.h
//  PhotonIM
//
//  Created by Bruce on 2019/6/27.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotonBaseViewController.h"
#import "PhotonNetworkService.h"
NS_ASSUME_NONNULL_BEGIN

@interface PhotonAccountViewController : PhotonBaseViewController
@property (nonatomic, strong, readonly, nullable)PhotonNetworkService *netService;
@property (nonatomic, copy, readonly, nullable)void (^completion)(void);
- (void)setCompletionBlock:(void(^)(void))completionBlock;
- (void)wrapData:(NSDictionary *)dict;
- (void)resignResponder;
- (void)forbidUpload:(id)gesture;

@end

NS_ASSUME_NONNULL_END
