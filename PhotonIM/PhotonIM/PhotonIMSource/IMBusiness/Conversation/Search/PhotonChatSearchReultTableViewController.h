//
//  PhotonChatSearchReultTableViewController.h
//  PhotonIM
//
//  Created by Bruce on 2020/1/10.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonBaseViewController.h"
#import "PotonTableViewDataSource.h"
NS_ASSUME_NONNULL_BEGIN
@interface PhotonChatSearchReultDataSource:PotonTableViewDataSource
@end
@interface PhotonChatSearchReultTableViewController : PhotonBaseViewController
- (instancetype)initWithChatType:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;
@end

NS_ASSUME_NONNULL_END
