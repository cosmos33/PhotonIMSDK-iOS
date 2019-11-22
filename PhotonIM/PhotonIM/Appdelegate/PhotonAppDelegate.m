//
//  AppDelegate.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/19.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonAppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import <pushsdk/MoPushManager.h>
#import "PhotonAppLaunchManager.h"
#import "PhotonMessageCenter.h"
@interface PhotonAppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation PhotonAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[PhotonMessageCenter sharedCenter] initPhtonIMSDK];
    
    [self registerPushSDK];
    
    UNUserNotificationCenter.currentNotificationCenter.delegate = self;
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
    return YES;
}

- (void)registerPushSDK{
     [MoPushManager initSDK:APP_ID];
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
    PhotonLog(@"AppDelegate callback ----->> commandName:%@,  code: %d, message:%@", [message commandName],[message resultCode], [message message]);
}

#pragma mark - Notification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PhotonLog(@"获取到deviceToken -- %@", deviceToken); //SDK内部hook，业务层无需配置
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    PhotonLog(@"获取失败deviceToken -- %@", error.localizedDescription);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSDictionary *dict = response.notification.request.content.userInfo;
        NSLog(@"%@",dict);
    }
    completionHandler();
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


@end
