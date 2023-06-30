//
//  PhotonIMUtils.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/3.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#define SDK_VERSION  2
@interface PhotonIMUtils : NSObject
// 获取message id
+ (NSString *)generateMsgID;

//获取deviceid
+ (NSString *)deviceID;

// 设备信息
+ (NSString *)deviceInfo;

+ (NSString *)appBuildVersion;

+ (NSString *)appBundleShortVersion;

#pragma mark ----- 存储相关 --------
+(NSString *) getValueForKey:(NSString *)key;

+(void) putValue:(NSString *)value forKey:(NSString *)key;

+(id) getObjForKey:(NSString *)key;

+(void) putObj:(id)value forKey:(NSString *)key;

+(void) deleteValue:(NSString *)key;


#pragma mark  ----------- 网络请求相关 -----------
+ (NSString *)userAgentString;
+ (BOOL)hostIsIPAddress:(NSString *)host;


#pragma mark ------

+ (NSString *)documentsPath;

+ (BOOL)createDirectoryIfExit:(NSString *)dPath;

#pragma mark--- 获取chatWith ---

+ (NSString *)chatWith:(NSString *)userId fr:(NSString *)fr to:(NSString *)to;

+ (NSString *)md5:(NSString *)content;

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;

+ (NSArray *)sortFileByTimeWithRootPath:(NSString *)rpath;

+ (BOOL)isLegalTime:(NSString *)path interval:(NSInteger)interval;
+ (int)intervalSinceNow:(NSString *)theDate;
@end

NS_ASSUME_NONNULL_END
