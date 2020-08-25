//
//  AppDelegate.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/19.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonAppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import <pushsdk/pushsdk.h>
#import "PhotonIMClientConfig.h"
#import "PhotonContent.h"
#import "PhotonAppLaunchManager.h"
#import "PhotonMessageCenter.h"
#import "YYFPSLabel.h"
#import "Growing.h"
#import <Rifle/Rifle.h>

@interface PhotonAppDelegate ()<UNUserNotificationCenterDelegate>

@property (nonatomic, strong) YYFPSLabel *fpsLabel;
@end

@implementation PhotonAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Rifle startWithAppId:APP_ID_INLAND config:nil];
    [[PhotonMessageCenter sharedCenter] initPhtonIMSDK];
    [Growing startWithAccountId:@"98874232e8f917cc"];
    [Growing setEnableLog:YES];
    [self registerPushSDK];
    
    PhotonIMClientConfig *config = [[PhotonIMClientConfig alloc] init];
    [MoPushManager setNotiCenterDelegate:config];
    UNUserNotificationCenter.currentNotificationCenter.delegate = config;
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
            }];
        }
        [PhotonUtil runMainThread:^{
            [application registerForRemoteNotifications];
        }];
    }];
    
    [PhotonAppLaunchManager registerWithWindow:self.window];
    [PhotonAppLaunchManager launchInWindow];
    
    [self addFPSLabel];
    
    return YES;
}

- (void)registerPushSDK{
    if ([PhotonContent getServerSwitch] == PhotonIMServerTypeInland) {
        [MoPushManager setServerType:MOPushServerTypeInland];
        [MoPushManager initSDK:APP_ID_INLAND];
    }else if ([PhotonContent getServerSwitch] == PhotonIMServerTypeOverseas){
        [MoPushManager setServerType:MOPushServerTypeOverseas];
        [MoPushManager initSDK:APP_ID_OVERSEAS];
    }
    
#ifdef DEBUG
    [MoPushManager setBuildStat:MOBuildStat_DEBUG];
#elif INHOUSE
    [MoPushManager setBuildStat:MOBuildStat_INHOUSE];
#else
    [MoPushManager setBuildStat:MOBuildStat_RELEASE];
#endif
    [MoPushManager addCommandListener:@selector(onMoPushManagerCommand:) target:self];
    [MoPushManager registerToken];
   
}
- (void)onMoPushManagerCommand:(CallbackMessage *)message {
    PhotonLog(@"onMoPushManagerCommand ----->> commandName:%@,  code: %d, message:%@", [message commandName],[message resultCode], [message message]);
}

- (void)addFPSLabel {
    _fpsLabel = [YYFPSLabel new];
    _fpsLabel.frame = CGRectMake(135, 35, 50, 30);
    [_fpsLabel sizeToFit];
    [self.window addSubview:_fpsLabel];
}


#pragma mark - Notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    PhotonLog(@"获取到deviceToken --");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"cdscds" message:@"vxvsd" delegate:self cancelButtonTitle:@"" otherButtonTitles:@"ok", nil];
    [alert show];
    
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PhotonLog(@"获取到deviceToken -- %@", deviceToken); //SDK内部hook，业务层无需配置
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    PhotonLog(@"获取失败deviceToken -- %@", error.localizedDescription);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
     [[NSUserDefaults standardUserDefaults] setValue:[@([[NSDate date] timeIntervalSince1970]) stringValue] forKey:@"timeStamp_pushqq"];
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSDictionary *dict = response.notification.request.content.userInfo;
        NSLog(@"%@",[dict description]);
    }
    completionHandler();
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler __API_AVAILABLE(macos(10.14), ios(10.0), watchos(3.0), tvos(10.0)){
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    if ([Growing handleUrl:url]) // 请务必确保该函数被调用
       {
           return YES;
       }
       return NO;
}


@end
