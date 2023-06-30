//
//  NSDictionary.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/11/15.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+PhotonIMAdd.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (PhotonIMAdd)
-(id)photonValueForKey:(NSString *)key defaultValue:(nullable id)vlaue;
-(id)photonObjectForKey:(id)key defaultValue:(nullable id)defaultValue;
@end

NS_ASSUME_NONNULL_END
