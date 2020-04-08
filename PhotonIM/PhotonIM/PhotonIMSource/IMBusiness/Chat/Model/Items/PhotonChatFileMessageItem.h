//
//  PhotonChatFileItem.h
//  PhotonIM
//
//  Created by Bruce on 2020/2/17.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonChatBaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotonChatFileMessageItem : PhotonChatBaseItem
@property(nonatomic, copy)NSString *filePath;
@property(nonatomic, copy)NSString *fileName;
@property(nonatomic, copy)NSString *fileSize;
@property(nonatomic, strong)UIImage *fileICon;
@end

NS_ASSUME_NONNULL_END
