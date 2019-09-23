//
//  PhotonContacDataSource.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/27.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonContacDataSource.h"
#import "PhotonBaseContactItem.h"
#import "PhotonBaseContactCell.h"
@implementation PhotonContacDataSource
- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object{
    if ([object isKindOfClass:[PhotonBaseContactItem class]]) {
        return [PhotonBaseContactCell class];
    }
    return [super tableView:tableView cellClassForObject:object];
}
@end
