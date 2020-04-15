//
//  PhotonLoadDataSetModel.m
//  PhotonIM
//
//  Created by Bruce on 2020/1/16.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonLoadDataSetModel.h"

@implementation PhotonLoadDataSetModel
- (instancetype)initWithSize:(NSInteger)size beginTime:(NSTimeInterval)beginTime endTime:(NSTimeInterval)endTime onlyLoadService:(BOOL)onlyLoadService{
    self = [super init];
    if (self) {
        _size = size;
        _beginTime = beginTime;
        _endTime = endTime;
        _onlyLoadService = onlyLoadService;
    }
    return self;
}
@end
