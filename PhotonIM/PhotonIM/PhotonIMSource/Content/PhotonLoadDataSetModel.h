//
//  PhotonLoadDataSetModel.h
//  PhotonIM
//
//  Created by Bruce on 2020/1/16.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotonLoadDataSetModel : NSObject
@property(nonatomic, assign)NSInteger size;
@property(nonatomic, assign)NSTimeInterval beginTime;
@property(nonatomic, assign)NSTimeInterval endTime;
@property(nonatomic, assign)BOOL onlyLoadService;
- (instancetype)initWithSize:(NSInteger)size beginTime:(NSTimeInterval)beginTime endTime:(NSTimeInterval)endTime onlyLoadService:(BOOL)onlyLoadService;
@end

NS_ASSUME_NONNULL_END
