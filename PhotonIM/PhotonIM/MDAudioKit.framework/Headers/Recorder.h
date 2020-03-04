//
//  Recorder.h
//  MomoChat
//
//  Created by Jichuan on 16/7/4.
//  Copyright © 2016年 Momo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

static const int kRecorderNumberBuffers = 3;
typedef struct {
    AudioStreamBasicDescription mDataFormat;                        // 数据格式
    AudioQueueRef               mQueue;                             // Audio Queue
    AudioQueueBufferRef         mBuffers[kRecorderNumberBuffers];   // Buffers
    AudioFileID                 mAudioFile;                         // Audio File
    UInt32                      mBufferByteSize;                    // Buffer字节大小
    SInt64                      mCurrentPacket;                     // packet index
    bool                        mIsRunning;                         // 是否正在运行
} RecorderState;

@class Recorder;

@protocol RecorderDelegate <NSObject>

@required
// 录制结束
- (void)recorderEnd:(Recorder *)recorder;

@end

/*
 Recorder新增Bus功能,能够将录制的PCM信号发送到Bus实例.
 Bus类应该实现下面的协议方法,并且处理PCM信号时应该有自己的线程队列.
 */
@protocol RecorderBusDelegate

@required
- (void)sendPcmPrepareWithASBD:(AudioStreamBasicDescription)asbd;
- (void)sendPcm:(void * const)pcmData byteSize:(UInt32)byteSize;
- (void)sendPcmOver;
- (void)sendPcmCancel;

@end

@interface Recorder : NSObject

@property (nonatomic, weak) id<RecorderDelegate> delegate;
@property (nonatomic, strong, readonly) NSMutableArray *busArray;

/**
 自定义录制采样率，可在startRecording前设置，默认使用16000.f
 */
@property (nonatomic, assign) Float64 sampleRate;

// 新增的信号Bus功能
- (void)addBus:(id<RecorderBusDelegate>)bus;

- (BOOL)startRecording:(NSString *)filePath;
- (void)stopRecording:(BOOL)isCancel;

- (void)stopRecordingMerely;

- (BOOL)isRecording;

- (float)averagePower;

#pragma mark - private
//- (void)addNumPackets:(UInt32)numPackets;

@end
