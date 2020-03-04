//
//  MDOpusPlayer.h
//  MomoChat
//
//  Created by Jc on 16/10/21.
//  Copyright © 2016年 wemomo.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MDOpusPlayerDelegate;

@interface MDOpusPlayerOptions : NSObject

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, assign) BOOL enableMetering;
@property (nonatomic, assign) float volume;
@property (nonatomic, assign) NSTimeInterval startAtTime; //开始播放时间

@end

/*
 Opus播放器,利用AudioQueue和OpusFile边解码边播放
 */
@interface MDOpusPlayer : NSObject

@property (nonatomic, weak) id<MDOpusPlayerDelegate> delegate;

@property (nonatomic, assign, readonly) NSTimeInterval duration;
@property (nonatomic, assign) float volume;

- (BOOL)isPlaying;
- (float)peak;

- (BOOL)startPlayingWithOptions:(MDOpusPlayerOptions *)options;
- (void)stopPlaying;

- (NSTimeInterval)currentPlayedTime;

@end

@protocol MDOpusPlayerDelegate <NSObject>

- (void)opusPlayer:(MDOpusPlayer *)sender didFinishPlaying:(BOOL)flag;
- (void)opusPlayer:(MDOpusPlayer *)sender didOccurError:(NSError *)error;
- (void)opusPlayer:(MDOpusPlayer *)sender didStop:(BOOL)flag;

@end
