//
//  PhotonIMFileDataTask.h
//  PhotonIMSDK
//
//  Created by Bruce on 2020/2/13.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PhotonIMDataTaskProtocol <NSObject>

- (void)startTask;
- (void)cancelTask;

@end

NS_ASSUME_NONNULL_END
