//
//  NotificationService.m
//  PhotonIMNotificationService
//
//  Created by Bruce on 2019/8/5.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "NotificationService.h"
#import <CoreServices/CoreServices.h>
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
    [self request];
    NSDictionary *dict = self.bestAttemptContent.userInfo;
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
- (void)request{
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://push.immomo.com/alpha/test/iosarrive?data=haha"]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {    
        }else{
            NSDictionary *dict = nil;
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


@end
