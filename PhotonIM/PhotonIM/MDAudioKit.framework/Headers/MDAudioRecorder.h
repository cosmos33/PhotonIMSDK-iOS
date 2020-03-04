//
//  MDAudioRecorder.h
//  MomoChat
//
//  Created by Latermoon on 12-10-27.
//  Copyright (c) 2012年 wemomo.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recorder.h"

#define NTF_PEAKANDTIME  @"peakAndTime"
// 录音错误类型
typedef NS_ENUM (NSInteger, MDAudioRecorderType) {
    MDAudioRecorderTypeNone             = 0,
    MDAudioRecorderTypeTimeTooShort     = 1, // 录音时间过短
    MDAudioRecorderTypeDeviceNotSupport = 2, // 设备不支持
    MDAudioRecorderTypeManualCancel     = 3, // 手工取消
    MDAudioRecorderTypeStartupFailed    = 4  // 启动失败
};

@class MDAudioRecorder;

@protocol MDAudioRecorderDelegate<NSObject>

@optional
- (void)audioRecorder:(MDAudioRecorder *)audioRecorder recordSucessStoreAt:(NSString *)filePath audioTime:(NSUInteger)secs;
- (void)audioRecorder:(MDAudioRecorder *)audioRecorder recordFail:(MDAudioRecorderType)errorType;

- (void)audioRecorder:(MDAudioRecorder *)audioRecorder currentRecordTiem:(NSTimeInterval)time;
@end

/**
 * 只负责录音
 */
@interface MDAudioRecorder : NSObject

@property (nonatomic,weak) id<MDAudioRecorderDelegate> delegate;
@property (nonatomic, assign,readonly) NSInteger maxDuration;

- (instancetype)initWithMaxDuration:(NSInteger)maxDuration minDuration:(NSInteger)minDuration;

- (void)addBus:(id<RecorderBusDelegate>)bus;

// 录音过程控制
- (void)startRecord;
- (void)stopRecord;
- (void)cancelRecord;
- (BOOL)isRecording;
- (NSUInteger)audioTime;
- (float)peak;

// 获取当前录制的时长
- (NSTimeInterval)currentRecordTime;
@end

