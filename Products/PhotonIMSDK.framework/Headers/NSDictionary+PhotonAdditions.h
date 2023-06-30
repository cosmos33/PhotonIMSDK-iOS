//
//  NSDictionary+PhotonAdditions.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/19.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary(PhotonAdditions)
- (id) objectForKey:(id)aKey convertNSNullToNil:(BOOL) convertNSNull;
/**
 * 将字典转为json字符串
 */
- (NSString *)JSONString:(BOOL)prettyPrint;

- (NSString *)photonimStringWithFromDict;

- (id)safeObjectForKey:(id)aKey;
@end

NS_ASSUME_NONNULL_END
