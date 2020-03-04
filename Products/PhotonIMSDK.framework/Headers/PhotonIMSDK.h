//
//  PhotonIMSDK.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/6/27.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for PhotonIMSDK.
FOUNDATION_EXPORT double PhotonIMSDKVersionNumber;

//! Project version string for PhotonIMSDK.
FOUNDATION_EXPORT const unsigned char PhotonIMSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <PhotonIMSDK/PublicHeader.h>

// client
#import <PhotonIMSDK/PhotonIMClient.h>
#import <PhotonIMSDK/PhotonIMClient+HandleReceiveMessge.h>
#import <PhotonIMSDK/PhotonIMClient+HandleSendMessage.h>
#import <PhotonIMSDK/PhotonIMClient+HandleLog.h>
#import <PhotonIMSDK/PhotonIMClient+ConversationManager.h>
#import <PhotonIMSDK/PhotonIMClient+MessageManager.h>
// conversation
#import <PhotonIMSDK/PhotonIMConversation.h>

// messsage
#import <PhotonIMSDK/PhotonIMMessage.h>
#import <PhotonIMSDK/PhotonIMTextBody.h>
#import <PhotonIMSDK/PhotonIMImageBody.h>
#import <PhotonIMSDK/PhotonIMAudioBody.h>
#import <PhotonIMSDK/PhotonIMCustomBody.h>
#import <PhotonIMSDK/PhotonIMVideoBody.h>
#import <PhotonIMSDK/PhotonIMLocationBody.h>
#import <PhotonIMSDK/PhotonIMFileBody.h>

// protocol
#import <PhotonIMSDK/PhotonIMClientProtocol.h>

// utils
#import <PhotonIMSDK/PhotonIMNetworkChangeManager.h>
#import <PhotonIMSDK/PhotonIMThreadSafeArray.h>
#import <PhotonIMSDK/PhotonIMThreadSafeDictionary.h>
#import <PhotonIMSDK/PhotonIMTimer.h>
#import <PhotonIMSDK/PhotonIMError.h>
#import <PhotonIMSDK/PhotonIMDispatchSource.h>
