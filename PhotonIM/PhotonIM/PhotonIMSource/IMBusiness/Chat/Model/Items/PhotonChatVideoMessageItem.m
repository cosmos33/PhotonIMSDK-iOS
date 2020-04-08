//
//  PhotonChatVideoMessageItem.m
//  PhotonIM
//
//  Created by Bruce on 2020/1/15.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonChatVideoMessageItem.h"

@implementation PhotonChatVideoMessageItem
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (CGSize)contentSize{
    CGFloat scale = 1.5;
    CGSize imageSize = CGSizeZero;
    CGFloat defaultWith = PhotoScreenWidth * 0.3;
    CGFloat realHeight = defaultWith * scale;
    imageSize = CGSizeMake(defaultWith, realHeight);
    return imageSize;
}
- (CGFloat)itemHeight{
    return [super itemHeight];
}
@end
