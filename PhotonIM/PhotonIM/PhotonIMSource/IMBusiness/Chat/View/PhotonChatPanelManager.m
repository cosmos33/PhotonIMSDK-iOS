//
//  PhotonChatPanelManager.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/20.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonChatPanelManager.h"
#import <Photos/Photos.h>
#import <Masonry/Masonry.h>
#import "PhotonMoreKeyBoard.h"
#import "PhotonEmojiKeyboard.h"
#import "PhotonAudioRecorder.h"
#import "PhotonUtil.h"
#import "PhotonRecorderIndicator.h"
#import "PhotonMessageCenter.h"
#import "PhotonLocationViewContraller.h"
#import "PhotonUINavigationController.h"

#import "UIViewController+HXExtension.h"
#import "HXPhotoPicker.h"

static NSString  *ATCharater = @"@";

@interface PhotonChatPanelManager()<PhotonCharBarDelegate,
PhotonBaseKeyBoardDelegate,
PhotonMoreKeyBoardDelegate,
PhotonEmojiKeyboardDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
PhotonAudioRecorderDelegate>
{
    PhotonChatBarStatus lastStatus;
    PhotonChatBarStatus curStatus;
}
@property(nonatomic,strong)UIView *view;
// chatBar
@property(nonatomic,strong,nullable)PhotonCharBar *chatBar;
// 更多面板
@property(nonatomic, strong, nullable)PhotonMoreKeyBoard *moreKeyboard;

// emoji面板
@property(nonatomic, strong, nullable)PhotonEmojiKeyboard *emojiKeyboard;

// 录音设备

@property(nonatomic, strong, nullable)PhotonAudioRecorder  *audioRecorder;

@property(nonatomic, strong, nullable)PhotonRecorderIndicator *recorderIndicatorView;

@property(nonatomic, copy, nullable)NSString *identifier;

@property (strong, nonatomic) HXPhotoManager *manager;

@property (copy,nonatomic)NSString *contentText;
@end
@implementation PhotonChatPanelManager
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithIdentifier:(NSString *)identifier{
    self = [self init];
    if (self) {
        _identifier = identifier;
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)addChatPanelWithSuperView:(UIView *)superView{
     _view = superView;
     [self p_initPanel];
}

- (void)dismissKeyboard
{
    if (curStatus == PhotonChatBarStatusMore) {
        [self.moreKeyboard dismissWithAnimation:YES];
        curStatus = PhotonChatBarStatusInit;
    }
    if (curStatus == PhotonChatBarStatusEmoji) {
        [self.emojiKeyboard dismissWithAnimation:YES];
        curStatus = PhotonChatBarStatusInit;
    }
    [self.chatBar resignFirstResponder];
}


#pragma mark ------- private method -----------
- (void)p_initPanel{
    [self.view addSubview:self.chatBar];
    PhotonMoreKeyboardItem *imageItem = [PhotonMoreKeyboardItem createByType:PhotonMoreKeyboardItemTypeImage
                                                                       title:@"照片"
                                                                   imagePath:@"moreKB_image"];
    PhotonMoreKeyboardItem *cameraItem = [PhotonMoreKeyboardItem createByType:PhotonMoreKeyboardItemTypeCamera
                                                                        title:@"拍照"
                                                                    imagePath:@"moreKB_capture"];
    
    PhotonMoreKeyboardItem *vedioItem = [PhotonMoreKeyboardItem createByType:PhotonMoreKeyboardItemTypeVideo
                                                                       title:@"短视频"
                                                                   imagePath:@"video"];
    
    PhotonMoreKeyboardItem *locationItem = [PhotonMoreKeyboardItem createByType:PhotonMoreKeyboardItemTypeLocation
                                                                          title:@"位置"
                                                                      imagePath:@"location"];
    
    PhotonMoreKeyboardItem *chennalSetItem = [PhotonMoreKeyboardItem createByType:PhotonMoreKeyboardItemTypeChennalSet
                                                                             title:@"通道set消息"
                                                                         imagePath:@"location"];
    PhotonMoreKeyboardItem *chennalSyncItem = [PhotonMoreKeyboardItem createByType:PhotonMoreKeyboardItemTypeChennalSync
                                                                                title:@"通道sync消息"
                                                                            imagePath:@"location"];
    PhotonMoreKeyboardItem *unsaveItem = [PhotonMoreKeyboardItem createByType:PhotonMoreKeyboardItemTypemUNSaveMsg
        title:@"消息不入库"
    imagePath:@"location"];
    PhotonMoreKeyboardItem *timeoutMsgItem = [PhotonMoreKeyboardItem createByType:PhotonMoreKeyboardItemTypemMSGTimeOUT
        title:@"带超时消息"
    imagePath:@"location"];
    
    PhotonMoreKeyboardItem *unReadItem = [PhotonMoreKeyboardItem createByType:PhotonMoreKeyboardItemTypemUNRead
        title:@"消息接收不增未读数"
    imagePath:@"location"];
    
    [self.moreKeyboard setDelegate:self];
    [self.moreKeyboard setKeyboardDelegate:self];
    [self.emojiKeyboard setDelegate:self];
    [self.emojiKeyboard setKeyboardDelegate:self];
    
    [self.moreKeyboard setChatMoreKeyboardItems:[@[imageItem,cameraItem,locationItem,chennalSetItem,chennalSyncItem,timeoutMsgItem,unsaveItem,unReadItem] mutableCopy]];
    [self.emojiKeyboard setChatEmojiKeyboardItems:nil];
    
    [self addMasonry];
}

- (void)addMasonry{
    [self.chatBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).mas_offset(-SAFEAREA_INSETS_BOTTOM);
        make.height.mas_greaterThanOrEqualTo(54.5);
    }];
    [self.view layoutIfNeeded];
}

#pragma mark ----------- Getter ----------
- (PhotonCharBar *)chatBar{
    if (!_chatBar) {
        _chatBar = [[PhotonCharBar alloc]init];
        [_chatBar addContent:self.draft];
        [_chatBar setDelegate:self];
    }
    return _chatBar;
}

- (PhotonMoreKeyBoard *)moreKeyboard{
    return [PhotonMoreKeyBoard sharedKeyBoard];
}

-(PhotonEmojiKeyboard *)emojiKeyboard{
    return [PhotonEmojiKeyboard sharedKeyBoard];
}

- (PhotonAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        _audioRecorder = [[PhotonAudioRecorder alloc] init];
        _audioRecorder.delegate = self;
    }
    return _audioRecorder;
}

- (PhotonRecorderIndicator *)recorderIndicatorView{
    if (!_recorderIndicatorView) {
        _recorderIndicatorView = [[PhotonRecorderIndicator alloc] init];
    }
    return _recorderIndicatorView;
}
#pragma mark --------- keyboard noti event ---
- (void)keyboardWillShow:(NSNotification *)notification
{
    if (curStatus != PhotonChatBarStatusKeyboard) {
        return;
    }
    if (lastStatus == PhotonChatBarStatusMore) {
        [self.moreKeyboard dismissWithAnimation:NO];
    }
    else if (lastStatus == PhotonChatBarStatusEmoji) {
        [self.emojiKeyboard dismissWithAnimation:NO];
    }
    
    if ([self.delegate respondsToSelector:@selector(keyboardWillShow)]) {
           [self.delegate keyboardWillShow];
       }
    
    if ([self.delegate respondsToSelector:@selector(scrollToBottomWithAnimation:)]) {
        [self.delegate scrollToBottomWithAnimation:YES];
    }
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    if (curStatus != PhotonChatBarStatusKeyboard) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(scrollToBottomWithAnimation:)]) {
        [self.delegate scrollToBottomWithAnimation:YES];
    }
}

- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    if (curStatus != PhotonChatBarStatusKeyboard && lastStatus != PhotonChatBarStatusKeyboard) {
        return;
    }
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (lastStatus == PhotonChatBarStatusMore || lastStatus == PhotonChatBarStatusEmoji) {
        if (keyboardFrame.size.height <= HEIGHT_CHAT_KEYBOARD) {
            return;
        }
    }
    else if (curStatus == PhotonChatBarStatusEmoji || curStatus == PhotonChatBarStatusMore) {
        return;
    }
    [self.chatBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(MIN(-keyboardFrame.size.height, -SAFEAREA_INSETS_BOTTOM));
    }];
    [self.view layoutIfNeeded];
    
    if ([self.delegate respondsToSelector:@selector(scrollToBottomWithAnimation:)]) {
        [self.delegate scrollToBottomWithAnimation:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (curStatus != PhotonChatBarStatusKeyboard && lastStatus != PhotonChatBarStatusKeyboard) {
        return;
    }
    if (curStatus == PhotonChatBarStatusEmoji || curStatus == PhotonChatBarStatusMore) {
        return;
    }
    [self.chatBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(-SAFEAREA_INSETS_BOTTOM);
    }];
    [self.view layoutIfNeeded];
}

#pragma mark ---- PhotonCharBarDelegate -------

- (void)chatBarTextViewDidChange:(PhotonCharBar *)charBar{
    if ([charBar.currentInputText isEqualToString:ATCharater]) {
          // 如果是@
        if(self.delegate && [self.delegate respondsToSelector:@selector(processAtAction:)]){
            [self.delegate processAtAction:charBar];
        }
    }
    
}

- (void)chatBar:(PhotonCharBar *)chatBar changeStatusFrom:(PhotonChatBarStatus)fromStatus to:(PhotonChatBarStatus)toStatus{
    if (curStatus == toStatus) {
        return;
    }
    lastStatus = fromStatus;
    curStatus = toStatus;
    if (toStatus == PhotonChatBarStatusInit) {
        if (fromStatus == PhotonChatBarStatusMore) {
            [self.moreKeyboard dismissWithAnimation:YES];
        }
        else if (fromStatus == PhotonChatBarStatusEmoji) {
            [self.emojiKeyboard dismissWithAnimation:YES];
        }
    }
    else if (toStatus == PhotonChatBarStatusVoice) {
        if (fromStatus ==PhotonChatBarStatusMore) {
            [self.moreKeyboard dismissWithAnimation:YES];
        }
        else if (fromStatus == PhotonChatBarStatusEmoji) {
            [self.emojiKeyboard dismissWithAnimation:YES];
        }
    }
    else if (toStatus == PhotonChatBarStatusEmoji) {
        if (fromStatus ==PhotonChatBarStatusMore) {
            [self.moreKeyboard dismissWithAnimation:YES];
        }
            [self.emojiKeyboard showInView:self.view withAnimation:YES];
    }
    else if (toStatus == PhotonChatBarStatusMore) {
        if (fromStatus == PhotonChatBarStatusEmoji) {
            [self.emojiKeyboard dismissWithAnimation:YES];
        }
        [self.moreKeyboard showInView:self.view withAnimation:YES];
    }
}

- (void)chatBar:(PhotonCharBar *)chatBar didChangeTextViewHeight:(CGFloat)height{
    if ([self.delegate respondsToSelector:@selector(scrollToBottomWithAnimation:)]) {
        [self.delegate scrollToBottomWithAnimation:NO];
    }
}

// 发送
- (void)chatBar:(PhotonCharBar *)chatBar sendText:(NSString *)text{
    NSString *sendText = text.trim;
    if ([sendText length] == 0) {
        return;
    }
    _contentText = sendText;
    if ([self.delegate respondsToSelector:@selector(sendTextMessage:atItems:type:msgType:)]) {
        NSArray *infos = [chatBar.atInfos copy];
        [self.delegate sendTextMessage:text atItems:infos type:chatBar.atType msgType:0];
        chatBar.atInfos = [@[] copy];
        chatBar.atType = AtTypeNoAt;
    }
}

#pragma mark ---------- 语音录制相关 ---------
// 开始录音
- (void)chatBarStartRecording:(PhotonCharBar *)chatBar{
    [self.audioRecorder startRecording];
    
    [self.recorderIndicatorView setStatus:PhotonRecorderStatusRecording];
    [self.view addSubview:self.recorderIndicatorView];
    [self.recorderIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(205, 205));
    }];
    
}

// 将要结束录音
- (void)chatBarWillCancelRecording:(PhotonCharBar *)chatBar cancel:(BOOL)cancel{
      [self.recorderIndicatorView setStatus:cancel ? PhotonRecorderStatusWillCancel : PhotonRecorderStatusRecording];
}

// 结束录音
- (void)chatBarDidCancelRecording:(PhotonCharBar *)chatBar{
    [self.audioRecorder cancleRecording];
    [self.recorderIndicatorView removeFromSuperview];
}

// 录音完成，发送
- (void)chatBarFinishedRecoding:(PhotonCharBar *)chatBar{
    [self.audioRecorder stopRecording];
}

#pragma mark --------- PhotonAudioRecorderDelegate ---
// 发送中，监控音量
- (void)audioRecorder:(nullable PhotonAudioRecorder *)recorder volume:(CGFloat)volume{
    NSLog(@"volume = %@",@(volume));
}
// 完成发送
- (void)finishAudioRecorder:(nullable PhotonAudioRecorder *)recorder time:(CGFloat)time{
    if (time < 1.0){
        // 录音时间较短，无法发送
        return;
    }
    [self.recorderIndicatorView removeFromSuperview];
    NSString *filePath = recorder.cachePath;
    NSLog(@"filePath = %@",filePath);
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSString *fileName = [NSString stringWithFormat:@"%.0lf.opus", [NSDate date].timeIntervalSince1970 * 1000];
        NSString *path = [[PhotonMessageCenter sharedCenter] getVoiceFilePath:_identifier fileName:fileName];
        if (![path isNotEmpty]) {
            return;
        }
        NSError *error;
        [[NSFileManager defaultManager] moveItemAtPath:filePath toPath:path error:&error];
        if (error) {
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(sendVoiceMessage:duraion:)]) {
            [self.delegate sendVoiceMessage:fileName duraion:time];
        }
        
    }
}
// 取消发送
- (void)cancleAudioRecorder:(nullable PhotonAudioRecorder *)recorder{
   
}

- (void)textViewDidEndEditing:(PhotonCharBar *)charBar{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.delegate textViewDidEndEditing:charBar.textView.text];
    }
}

// 录制时间太短
- (void)audioRecorderTimeTooShort:(PhotonAudioRecorder *)recorder{
     [self.recorderIndicatorView setStatus:PhotonRecorderStatusTooShort];
   
}
////////////


#pragma mark --------- PhotonBaseKeyBoardDelegate ---
-(void)chatKeyboardWillShow:(id)keyboard animated:(BOOL)animated{
    if ([self.delegate respondsToSelector:@selector(scrollToBottomWithAnimation:)]) {
        [self.delegate scrollToBottomWithAnimation:YES];
    }
}

- (void)chatKeyboardDidShow:(id)keyboard animated:(BOOL)animated{
    if ([self.delegate respondsToSelector:@selector(scrollToBottomWithAnimation:)]) {
        [self.delegate scrollToBottomWithAnimation:YES];
    }
}

- (void)chatKeyboardWillDismiss:(id)keyboard animated:(BOOL)animated{
    
}

- (void)chatKeyboardDidDismiss:(id)keyboard animated:(BOOL)animated{
    
}

- (void)chatKeyboard:(id)keyboard didChangeHeight:(CGFloat)height{
    [self.chatBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(MIN(-height, -SAFEAREA_INSETS_BOTTOM));
    }];
    [self.view layoutIfNeeded];
    
    if ([self.delegate respondsToSelector:@selector(scrollToBottomWithAnimation:)]) {
        [self.delegate scrollToBottomWithAnimation:YES];
    }
}

#pragma mark ---------- PhotonMoreKeyBoardDelegate -------
- (void)moreKeyboard:(id)keyboard didSelectedKeyboardItem:(PhotonMoreKeyboardItem *)item{
    switch (item.type) {
        case PhotonMoreKeyboardItemTypeLocation:{
            PhotonLocationViewContraller *locationVC = [[PhotonLocationViewContraller alloc]  init];
                   __weak typeof(self)weakSelf = self;
                   [locationVC setSendCompletion:^(CLLocationCoordinate2D aCoordinate, NSString * _Nullable address, NSString * _Nullable detailAddress) {
                       if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(sendLocationMessage:detailAddress:locationCoordinate:)]) {
                           [weakSelf.delegate sendLocationMessage:address detailAddress:detailAddress locationCoordinate:aCoordinate];
                       }
                   }];
                   [[self getCurrentVC].navigationController pushViewController:locationVC animated:YES];
        }
            
            break;
        case PhotonMoreKeyboardItemTypeVideo:{
            if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                  [self.view hx_showImageHUDText:@"此设备不支持相机!"];
                  return;
              }
              AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
              if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
                   [self.view hx_showImageHUDText:@"无法使用相机,请在设置-隐私-相机中允许访问相机中设置"];
                  return;
              }
                __weak typeof(self)weakSelf = self;
                [[self getCurrentVC] hx_presentCustomCameraViewControllerWithManager:self.manager done:^(HXPhotoModel *model, HXCustomCameraViewController *viewController) {

                [weakSelf compressVideo:model.videoURL completion:^(NSURL * videoURL) {
                     NSString *fileName = [NSString stringWithFormat:@"%.0lf.mp4", [NSDate date].timeIntervalSince1970 * 1000];
                     NSString *path = [[PhotonMessageCenter sharedCenter] getVideoFilePath:weakSelf.identifier fileName:fileName];
                     if (![path isNotEmpty]) {
                         return;
                     }
                     NSURL *pathurl = [NSURL fileURLWithPath:path];
                     NSError *error;
                     BOOL res = [[NSFileManager defaultManager] moveItemAtURL:videoURL toURL:pathurl error:&error];
                     if (res) {
                         [[NSFileManager defaultManager] removeItemAtURL:model.videoURL error:nil];
                         [[NSFileManager defaultManager] removeItemAtURL:videoURL error:nil];
                     }
                     if (self.delegate && [self.delegate respondsToSelector:@selector(sendVideoMessage:duraion:)]) {
                         [self.delegate sendVideoMessage:fileName duraion:model.videoDuration];
                    
                     }
                }];
            } cancel:^(HXCustomCameraViewController *viewController) {
                NSSLog(@"取消了");
            }];
        }
         
         break;
         case PhotonMoreKeyboardItemTypeImage:
        case PhotonMoreKeyboardItemTypeCamera:{
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            if (item.type == PhotonMoreKeyboardItemTypeCamera) {
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
                }
                else {
                    return;
                }
            }
            else {
                [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            }
            [imagePickerController setDelegate:self];
            
            [[self getCurrentVC] presentViewController:imagePickerController animated:YES completion:nil];
            
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if(status != PHAuthorizationStatusAuthorized){
                        [imagePickerController dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
            });
        }
         
         break;
         case PhotonMoreKeyboardItemTypeChennalSet:
         {
             NSString *sendText = self.chatBar.textView.text;
             if ([sendText length] == 0) {
                 return;
             }
             if ([self.delegate respondsToSelector:@selector(sendTextMessage:atItems:type:msgType:)]) {
                 NSArray *infos = [self.chatBar.atInfos copy];
                 [self.delegate sendTextMessage:sendText atItems:infos type:self.chatBar.atType msgType:1];
                 self.chatBar.atInfos = [@[] copy];
                 self.chatBar.atType = AtTypeNoAt;
             }
         }
         break;
            
         case PhotonMoreKeyboardItemTypeChennalSync:{
             NSString *sendText = self.chatBar.textView.text;
             if ([sendText length] == 0) {
                 return;
             }
             if ([self.delegate respondsToSelector:@selector(sendTextMessage:atItems:type:msgType:)]) {
                 NSArray *infos = [self.chatBar.atInfos copy];
                 [self.delegate sendTextMessage:sendText atItems:infos type:self.chatBar.atType msgType:2];
                 self.chatBar.atInfos = [@[] copy];
                 self.chatBar.atType = AtTypeNoAt;
             }
         }
         break;
        
        case PhotonMoreKeyboardItemTypemMSGTimeOUT:{
            NSString *sendText = self.chatBar.textView.text;
            if ([sendText length] == 0) {
                return;
            }
            if ([self.delegate respondsToSelector:@selector(sendTextMessage:atItems:type:msgType:)]) {
                NSArray *infos = [self.chatBar.atInfos copy];
                [self.delegate sendTextMessage:sendText atItems:infos type:self.chatBar.atType msgType:3];
                self.chatBar.atInfos = [@[] copy];
                self.chatBar.atType = AtTypeNoAt;
            }
        }
         break;
        case PhotonMoreKeyboardItemTypemUNSaveMsg:{
            NSString *sendText = self.chatBar.textView.text;
            if ([sendText length] == 0) {
                return;
            }
            if ([self.delegate respondsToSelector:@selector(sendTextMessage:atItems:type:msgType:)]) {
                NSArray *infos = [self.chatBar.atInfos copy];
                [self.delegate sendTextMessage:sendText atItems:infos type:self.chatBar.atType msgType:4];
                self.chatBar.atInfos = [@[] copy];
                self.chatBar.atType = AtTypeNoAt;
            }
        }
        break;
        case PhotonMoreKeyboardItemTypemUNRead:{
                   NSString *sendText = self.chatBar.textView.text;
                   if ([sendText length] == 0) {
                       return;
                   }
                   if ([self.delegate respondsToSelector:@selector(sendTextMessage:atItems:type:msgType:)]) {
                       NSArray *infos = [self.chatBar.atInfos copy];
                       [self.delegate sendTextMessage:sendText atItems:infos type:self.chatBar.atType msgType:6];
                       self.chatBar.atInfos = [@[] copy];
                       self.chatBar.atType = AtTypeNoAt;
                   }
               }
        break;
            
        default:
            break;
    }
}

// 压缩视频
- (void)compressVideo:(NSURL *)videoUrl completion:(void (^)(NSURL*))completion{
    NSURL *saveUrl=videoUrl;

    // 通过文件的 url 获取到这个文件的资源
    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:saveUrl options:nil];
    // 用 AVAssetExportSession 这个类来导出资源中的属性
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];

    // 压缩视频
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]) { // 导出属性是否包含低分辨率
    // 通过资源（AVURLAsset）来定义 AVAssetExportSession，得到资源属性来重新打包资源 （AVURLAsset, 将某一些属性重新定义
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetLowQuality];
    // 设置导出文件的存放路径
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSDate    *date = [[NSDate alloc] init];
    NSString *outPutPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"output-%@.mp4",[formatter stringFromDate:date]]];
    exportSession.outputURL = [NSURL fileURLWithPath:outPutPath];
    // 是否对网络进行优化
    exportSession.shouldOptimizeForNetworkUse = true;
    // 转换成MP4格式
    exportSession.outputFileType = AVFileTypeMPEG4;
    // 开始导出,导出后执行完成的block
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        // 如果导出的状态为完成
        if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
            if (completion) {
                completion(exportSession.outputURL);
            }
        }
    }];
}
}

//MARK: UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        if (imageData && [self.delegate respondsToSelector:@selector(sendImageMessage:)]) {
            [self.delegate sendImageMessage:imageData];
        }
    }else{
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        PHAsset *imageAsset;
        if (@available(iOS 11.0, *)) {
            imageAsset = [info objectForKey:UIImagePickerControllerPHAsset];
        } else {
            NSURL *imageAssetUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
            if (imageAssetUrl) {
                PHFetchResult *results = [PHAsset fetchAssetsWithALAssetURLs:@[imageAssetUrl]
                                                                     options:nil];
                if (results.count) {
                    imageAsset = [results lastObject];
                }
            }
        }
        [[PHImageManager defaultManager] requestImageDataForAsset:imageAsset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            if (imageData && [self.delegate respondsToSelector:@selector(sendImageMessage:)]) {
                [self.delegate sendImageMessage:imageData];
            }
        }];
    }
   
    
    
}


#pragma mark ---------- PhotonEmojiKeyboardDelegate -------
- (void)emojiKeyboardDidClickRemove:(PhotonEmojiKeyboard *)emojiView{
    [self.chatBar deleteLastCharacter];
}
- (void)emojiKeyboardDidClickSend:(PhotonEmojiKeyboard *)emojiView{
    [self.chatBar sendCurrentText];
}
- (void)emojiKeyboard:(PhotonEmojiKeyboard *)emojiView selectEmojiWithText:(NSString *)emojiText{
    [self.chatBar addContent:emojiText];
}


- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}
- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        currentVC = rootVC;
    }
    return currentVC;
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.openCamera = YES;
        _manager.configuration.saveSystemAblum = NO;
        _manager.configuration.themeColor = [UIColor blackColor];
    }
    return _manager;
}
@end
