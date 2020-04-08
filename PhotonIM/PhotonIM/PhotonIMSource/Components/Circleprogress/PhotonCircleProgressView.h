//
//  PhotonCircleProgressView.h
//  PhotonIM
//
//  Created by Bruce on 2020/3/19.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotonCircleProgressView : UIView

@property (nonatomic, assign) CGFloat progress;

- (void)showError;
@end

NS_ASSUME_NONNULL_END
