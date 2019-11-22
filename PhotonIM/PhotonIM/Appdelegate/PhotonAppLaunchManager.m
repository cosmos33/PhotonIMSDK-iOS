//
//  PhotonAppLaunchManager.m
//  PhotonIM
//
//  Created by Bruce on 2019/7/2.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonAppLaunchManager.h"

#import "PhotonConversationListViewController.h"
#import "PhotonUINavigationController.h"
#import "PhotonSingleContactViewController.h"
#import "PhotonPersonViewController.h"
#import "PhotonLoginViewController.h"
#import "PhotonContent.h"
#import "PhotonMessageCenter.h"
#import "PhotonDBManager.h"
#import "PhotonContactViewController.h"

static PhotonAppLaunchManager *lauchManager = nil;
@interface PhotonAppLaunchManager()
@property (nonatomic, strong, nullable)UIWindow  *window;

@end
@implementation PhotonAppLaunchManager
+ (instancetype)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lauchManager = [[PhotonAppLaunchManager alloc] init];
    });
    return lauchManager;
}
+ (void)registerWithWindow:(UIWindow *)window{
    [[PhotonAppLaunchManager defaultManager] registerWithWindow:window];
}

-(void)registerWithWindow:(UIWindow *)window{
    self.window = window;
}

+ (void)launchInWindow{
    [[PhotonAppLaunchManager defaultManager] launchInWindow];
}

- (void)launchInWindow{
    UITabBarController *tabVC = [[UITabBarController alloc] init];
    UIWindow *window = self.window ? self.window : [UIApplication sharedApplication].keyWindow;
    for (id view in window.subviews) {
        [view removeFromSuperview];
    }
    NSArray *data;
    if ([[PhotonContent currentUser].userID isNotEmpty]) {
        
        [PhotonContent login];
        [[PhotonMessageCenter sharedCenter] login];
        PhotonConversationListViewController *conversationVC = [[PhotonConversationListViewController alloc] init];
        PhotonContactViewController *contactVC = [[PhotonContactViewController alloc] init];
        PhotonPersonViewController *personVC = [[PhotonPersonViewController alloc] init];
        data = @[addNavigationController(conversationVC),
                          addNavigationController(contactVC),
                          addNavigationController(personVC),
                          ];
        [tabVC setViewControllers:data];
        [window setRootViewController:tabVC];
        [window addSubview:tabVC.view];
        [window makeKeyAndVisible];
        // 在此处请求token接口获取token
       
        
    }else{
        __weak typeof(self)weakSelf = self;
        PhotonLoginViewController *LoginVCL = [[PhotonLoginViewController alloc] init];
        [LoginVCL setCompletionBlock:^{
            [PhotonContent persistenceCurrentUser];
            [weakSelf launchInWindow];
        }];
        UINavigationController *navictl = addNavigationController(LoginVCL);
        [window setRootViewController:navictl];
        [window addSubview:navictl.view];
        [window makeKeyAndVisible];
    }
}


UINavigationController *addNavigationController(UIViewController *viewController)
{
    PhotonUINavigationController *navC = [[PhotonUINavigationController alloc] initWithRootViewController:viewController];
    return navC;
}
@end
