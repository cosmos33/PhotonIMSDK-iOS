//
//  PhotonDocumentViewController.h
//  PhotonIM
//
//  Created by Bruce on 2020/2/17.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonBaseViewController.h"
#import <PhotonIMSDK/PhotonIMSDK.h>
typedef void(^PhotonDocumentCompletionBlock)(id sender,NSString* ext);
NS_ASSUME_NONNULL_BEGIN

@interface PhotonDocumentViewController : PhotonBaseViewController
@property(nonatomic,copy)PhotonDocumentCompletionBlock completionBlock;
@end

NS_ASSUME_NONNULL_END
