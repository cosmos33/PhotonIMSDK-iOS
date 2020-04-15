//
//  PhotonIMClient+HandleLog.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/30.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotonIMClient.h"
NS_ASSUME_NONNULL_BEGIN

@interface PhotonIMClient(HandleLog)

/**
IMLog 日志处理，调用此方法，会把日志写到本地，不调用此方法不会处理日志。
@param cansoleEnable YES：打开控制台输出日志，NO：关闭控制台c输出日志
*/
- (void)openPhotonIMLog:(BOOL)cansoleEnable;


/**
 获取mdlog的存储路径

 @return <#return value description#>
 */
- (NSString *)imlogPath;
@end

NS_ASSUME_NONNULL_END
