//
//  PhotonMessageSettingItem.m
//  PhotonIM
//
//  Created by Bruce on 2019/7/31.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonMessageSettingItem.h"

@implementation PhotonMessageSettingItem

- (instancetype)init{
    self = [super init];
    if (self) {
        _showSwitch = YES;
    }
    return self;
}

- (CGFloat)itemHeight{
    return 52.0f;
}
@end
