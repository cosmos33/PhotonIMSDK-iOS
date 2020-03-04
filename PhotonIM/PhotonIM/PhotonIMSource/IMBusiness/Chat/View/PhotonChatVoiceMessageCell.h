//
//  PhotonVoiceMessageChatCell.h
//  PhotonIM
//
//  Created by Bruce on 2019/6/25.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotonChatBaseCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface PhotonChatVoiceMessageCell : PhotonChatBaseCell
@property (nonatomic, readonly, assign) BOOL isDoingAnimation;
- (void)stopAudioAnimating;
@end

NS_ASSUME_NONNULL_END
