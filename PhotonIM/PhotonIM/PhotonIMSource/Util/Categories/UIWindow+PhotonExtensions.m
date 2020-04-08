//
//  UIWindow+Extensions.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/27.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "UIWindow+PhotonExtensions.h"
#import <objc/runtime.h>
#import <DatabaseVisual/DatabaseManager.h>
#import <PhotonIMSDK/PhotonIMSDK.h>
@implementation UIWindow (PhotonExtensions)

void __Method_Swizzle__(Class cls, SEL origSel_, SEL altSel_)
{
    Method origMethod = class_getInstanceMethod(cls, origSel_);
    Method altMethod = class_getInstanceMethod(cls, altSel_);
    
    if(class_addMethod(cls, origSel_, method_getImplementation(altMethod), method_getTypeEncoding(altMethod)))
        class_replaceMethod(cls, altSel_, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, altMethod);
}

+ (void)load
{
    __Method_Swizzle__(self, @selector(motionBegan:withEvent:), @selector(md_motionBegan:withEvent:));
}
- (void)md_motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
//        [DatabaseManager sharedInstance].dbDocumentPath = [[[PhotonIMClient sharedClient] getDBPath] stringByDeletingLastPathComponent];
//        [[DatabaseManager sharedInstance] showTables];
    }
}


- (UIViewController *)visibleViewController {
    UIViewController *rootViewController = self.rootViewController;
    return [UIWindow getVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [UIWindow getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}
@end
