#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "PhotonIMClient+ConversationManager.h"
#import "PhotonIMClient+HandleLog.h"
#import "PhotonIMClient+HandleReceiveMessge.h"
#import "PhotonIMClient+HandleSendMessage.h"
#import "PhotonIMClient+MessageManager.h"
#import "PhotonIMClient.h"
#import "PhotonIMClientConfigProtocol.h"
#import "PhotonIMClientProtocol.h"
#import "PhotonIMEnum.h"
#import "PhotonIMError.h"
#import "PhotonIMConversation.h"
#import "PhotonIMAudioBody.h"
#import "PhotonIMBaseBody.h"
#import "PhotonIMBaseMessage.h"
#import "PhotonIMCustomBody.h"
#import "PhotonIMFileBaseBody.h"
#import "PhotonIMFileBody.h"
#import "PhotonIMImageBody.h"
#import "PhotonIMLocationBody.h"
#import "PhotonIMMediaBody.h"
#import "PhotonIMMessage.h"
#import "PhotonIMTextBody.h"
#import "PhotonIMVideoBody.h"
#import "NSArray+PhotonIMAdd.h"
#import "NSDictionary+PhotonAdditions.h"
#import "NSDictionary+PhotonIMAdd.h"
#import "PhotonIMAssert.h"
#import "PhotonIMAuthData.h"
#import "PhotonIMDispatchSource.h"
#import "PhotonIMNetworkChangeManager.h"
#import "PhotonIMReachabilityManager.h"
#import "PhotonIMThreadSafeArray.h"
#import "PhotonIMThreadSafeDictionary.h"
#import "PhotonIMTimer.h"
#import "PhotonIMUtils.h"
#import "UIDevice+PhotonIMHardware.h"
#import "PhotonIMSDK.h"

FOUNDATION_EXPORT double PhotonIMSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char PhotonIMSDKVersionString[];

