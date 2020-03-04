//
//  MDAudioStreamBus.h
//  MomoChat
//
//  Created by Jc on 16/10/26.
//  Copyright © 2016年 wemomo.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recorder.h"

// PCM信号接收器,它是Pcm编码到Opus/Opus文件写入/Opus数据流上传的业务统一调度封装
// 使用方法:创建Bus实例后,添加到录音器
@interface MDAudioStreamBus : NSObject <RecorderBusDelegate>

typedef void(^MDAudioStreamBusPartEncodedBlock)(MDAudioStreamBus *bus, NSData *opusBuffer, NSTimeInterval duration, u_int64_t opusFileSize);
typedef void(^MDAudioStreamBusCompletionBlock)(MDAudioStreamBus *bus, BOOL isCancel, NSTimeInterval duration, u_int64_t opusFileSize, NSString *opusFilePath, NSError *error);

/**
 降噪模式0,1,2,3表示强度，-1表示关闭降噪，默认1
 */
@property (nonatomic, assign) int noiseSuppressionMode;

- (instancetype)initWithOpusPath:(NSString *)path
                      blockQueue:(dispatch_queue_t)blockQueue
                     partEncoded:(MDAudioStreamBusPartEncodedBlock)partEncoded
                      completion:(MDAudioStreamBusCompletionBlock)completion;

#pragma mark - RecorderBusDelegate
- (void)sendPcmPrepareWithASBD:(AudioStreamBasicDescription)asbd;
- (void)sendPcm:(void * const)pcmData byteSize:(UInt32)byteSize;
- (void)sendPcmOver;
- (void)sendPcmCancel;

@end
