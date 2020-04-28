//
//  NotificationService.m
//  PhotonIMNotificationService
//
//  Created by Bruce on 2019/8/5.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "NotificationService.h"
#import <CoreServices/CoreServices.h>
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>
#define kCacheDirectory [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
typedef NS_ENUM(NSInteger,MDPushNotificationFileType)
{
    MDPushNotificationFileTypeNone = 0,
    MDPushNotificationFileTypeImage,
    MDPushNotificationFileTypeVideo,
    MDPushNotificationFileTypeAudio,
};

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
   
    NSDictionary *dict = self.bestAttemptContent.userInfo;
    // 上传到达统计
    [self request:dict];
    // 下载图片
    if ([dict isKindOfClass:[NSDictionary class]] && dict.count > 0) {
        NSDictionary *apsDict = dict[@"aps"];
        
        if ([apsDict isKindOfClass:[NSDictionary class]] && apsDict.count > 0) {
            //获取文件类型
            MDPushNotificationFileType fileType = [[apsDict objectForKey:@"file_type"] integerValue];
            
            //获取文件路径
            NSString *fileUrlStr = [apsDict objectForKey:@"file_path"];
            if (![fileUrlStr isKindOfClass:[NSString class]] || fileUrlStr.length <= 0) {
                self.contentHandler(self.bestAttemptContent);
            }
            
            //目前仅支持图片的展示
            switch (fileType) {
                case MDPushNotificationFileTypeImage:
                {
                    __weak typeof(self) weakSelf = self;
                    [self loadAttachmentWithUrlString:fileUrlStr completionHandle:^(UNNotificationAttachment *aAttachment) {
                        if (aAttachment) {
                            weakSelf.bestAttemptContent.attachments = @[aAttachment];
                        }
                        weakSelf.contentHandler(self.bestAttemptContent);
                    }];
                    break;
                }
                case MDPushNotificationFileTypeVideo:
                case MDPushNotificationFileTypeAudio:
                default:
                {
                    self.contentHandler(self.bestAttemptContent);
                    break;
                }
            }
            
        } else {
            self.contentHandler(self.bestAttemptContent);
        }
        
    } else {
        self.contentHandler(self.bestAttemptContent);
    }
}

#pragma mark 图片下载逻辑
- (void)loadAttachmentWithUrlString:(NSString *)urlStr completionHandle:(void(^)(UNNotificationAttachment *aAttachment))completionHandler
{
    __block UNNotificationAttachment *attachment = nil;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session downloadTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            attachment = nil;
            
        } else {
            NSString *extensionType = [self extensionTypeWithStr:[urlStr pathExtension]];
            
            CFStringRef type;
            if ([extensionType isEqualToString:@"jpg"]) {
                type = kUTTypeJPEG;
            }
            else if ([extensionType isEqualToString:@"png"]) {
                type = kUTTypePNG;
            }
            else {
                type = (__bridge CFStringRef)@"";
            }
            
            NSError *attachmentError = nil;
            attachment = [UNNotificationAttachment attachmentWithIdentifier:location.path URL:location options:@{UNNotificationAttachmentOptionsTypeHintKey: (__bridge NSString*)type} error:&attachmentError];
            
            if (attachmentError) {
                attachment = nil;
                NSLog(@"%@",attachmentError.localizedDescription);
            }
        }
        [session invalidateAndCancel];
        completionHandler(attachment);
        
    }] resume];
}

- (NSString *)extensionTypeWithStr:(NSString *)str
{
    if (!str.length) return nil;
    
    if ([str containsString:@"?"]) {
        return [str componentsSeparatedByString:@"?"].firstObject;
    }
    return str;
}

- (void)serviceExtensionTimeWillExpire {
    self.contentHandler(self.bestAttemptContent);
}



#pragma mark === 到达统计逻辑 ====
- (void)request:(NSDictionary *)userInfo{
    NSString *exData = userInfo[@"_ext"];
    // 无_ext在不打日志
    if (exData.length > 0) {
        NSMutableDictionary *logDict = [NSMutableDictionary dictionary];
        NSInteger time = [[NSDate date] timeIntervalSince1970] * 1000;
        [logDict setObject:@(time) forKey:@"time"];
        [logDict setObject:@(1) forKey:@"type"];
        
        NSData *extData = [exData dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:extData options:kNilOptions error:nil];
        NSString *security = [userInfo valueForKey:@"security"];
        if(security.length == 0){
            return;
        }
        [logDict setValue:dict forKey:@"data"];
        NSMutableDictionary *resultDict = [@{@"log_content":logDict} mutableCopy];
        [resultDict setValue:security forKey:@"security"];
        NSString *content = [self stringWithFromDict:resultDict];
       
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://paas-push-api-log.immomo.com/push/log/iosarrive"]];
        NSString *requestForm = [NSString stringWithFormat:@"mzip=%@",[self urlencode:content]];
        [request setHTTPMethod:@"POST"];
        [request setTimeoutInterval:10];
        NSMutableData *postBody = [NSMutableData data];
        [postBody appendData:[requestForm dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:postBody];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
              NSDictionary *dict = nil;
            if (error) {
            }else{
               @try {
                    dict = [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves
                                                             error:&error];
                }
                @catch (NSException *e) {
                    dict = [NSDictionary dictionary];
                }
            }
            [session invalidateAndCancel];
        }]  resume];
        
    }
}

- (NSString *)stringWithFromDict:(NSDictionary *)dict{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return content;
}

- (NSString *)urlencode: (NSString*) content {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[content UTF8String];
    unsigned long sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}
@end
