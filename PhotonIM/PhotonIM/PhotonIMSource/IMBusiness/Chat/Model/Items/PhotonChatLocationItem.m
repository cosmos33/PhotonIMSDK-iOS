//
//  PhotonLocationChatItem.m
//  PhotonIM
//
//  Created by Bruce on 2020/1/10.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonChatLocationItem.h"

@implementation PhotonChatLocationItem
- (CGSize)contentSize{
    CGFloat defaultWith = PhotoScreenWidth * 0.58;
    return CGSizeMake(defaultWith, 160);
}

- (CGFloat)itemHeight{
    return [super itemHeight];
}
@end
