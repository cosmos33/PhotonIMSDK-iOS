//
//  PhotonChatViewController+Delegate.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/22.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonChatViewController+Delegate.h"

#import "PhotonMessageCenter.h"

#import "PhotonChatViewController+Send.h"
#import "PhotonChatTextMessageCell.h"
#import "PhotonChatTextMessageItem.h"

#import "PhotonChatImageMessageItem.h"
#import "PhotonChatImageMessageCell.h"

#import "PhotonChatVoiceMessageItem.h"
#import "PhotonChatVoiceMessageCell.h"

#import "PhotonChatNoticItem.h"
#import "PhotonChatNoticCell.h"

#import "PhotonImageBrowser.h"

#import "PhotonFriendDetailViewController.h"
#import "PhotonMessageCenter.h"

#import "PhotonDownLoadFileManager.h"

#import "PhotonChatTransmitListViewController.h"
#import "PhotonChatLocationCell.h"
#import "PhotonChatLocationItem.h"
#import "PhotonLocationViewContraller.h"
#import "PhotonUINavigationController.h"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
@interface PhotonChatViewController()<PhotonBaseChatCellDelegate,UIActionSheetDelegate,PhotonMenuViewDelegate>
@end
@implementation PhotonChatViewController (Delegate)

#pragma mark ------ UITableViewDelegate ------

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.panelManager dismissKeyboard];
    [self.menuView dismiss];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [self.panelManager dismissKeyboard];
     [self.menuView dismiss];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[PhotonChatTextMessageCell class]]) {
        PhotonChatTextMessageCell *tempCell = (PhotonChatTextMessageCell *)cell;
        tempCell.delegate = self;
    }else if([cell isKindOfClass:[PhotonChatImageMessageCell class]]){
        PhotonChatImageMessageCell *tempCell = (PhotonChatImageMessageCell *)cell;
        tempCell.delegate = self;
    }else if([cell isKindOfClass:[PhotonChatVoiceMessageCell class]]){
        PhotonChatVoiceMessageCell *tempCell = (PhotonChatVoiceMessageCell *)cell;
        tempCell.delegate = self;
    }
    else if([cell isKindOfClass:[PhotonChatLocationCell class]]){
        PhotonChatLocationCell *tempCell = (PhotonChatLocationCell *)cell;
        tempCell.delegate = self;
    }
    
}

#pragma mark --------- PhotonBaseChatCellDelegate ---------
// 点击内容背景
- (void)chatCell:(PhotonChatBaseCell *)cell chatMessageCellTap:(PhotonChatBaseItem *)chatItem{
    
    // 图片单击事件（预览大图）
    if([cell isKindOfClass:[PhotonChatImageMessageCell class]]){
        // 查看大图
        NSString *defaultImage = [chatItem localPath];
        if (defaultImage.length == 0) {
            defaultImage = [(PhotonChatImageMessageItem *)chatItem orignURL];
        }
        NSMutableArray<NSString *> *imageItems = [[NSMutableArray alloc] init];
        for (PhotonChatBaseItem *item in self.dataSource.items) {
            if ([item isKindOfClass:[PhotonChatImageMessageItem class]]) {
                PhotonChatImageMessageItem *imgItem = (PhotonChatImageMessageItem *)item;
                if ([imgItem localPath]) {
                    [imageItems addObject:[imgItem localPath]];
                }else if ([imgItem orignURL]) {
                     [imageItems addObject:[imgItem orignURL]];
                }
            }
        }
        
        PhotonChatImageMessageCell *imageCell = (PhotonChatImageMessageCell *)cell;
        [imageCell.contentBackgroundView enterBrowserModeWithImageURLs:imageItems defaultImageURL:defaultImage placeholderImage:nil];
    }
    // 语音点击事件 (播放语音)
    if([cell isKindOfClass:[PhotonChatVoiceMessageCell class]]){
        PhotonChatVoiceMessageCell *voiceCell = (PhotonChatVoiceMessageCell *)cell;
        PhotonChatVoiceMessageItem *voiceItem = (PhotonChatVoiceMessageItem *)chatItem;
        if(voiceItem.fromType == PhotonChatMessageFromSelf){// 自己发送的语音消息，直接播放
            NSString *path = [[PhotonMessageCenter sharedCenter] getVoiceFilePath:self.conversation.chatWith fileName:voiceItem.fileName];
           [self playAudioSource:path cell:voiceCell];
        }else if(voiceItem.fromType == PhotonChatMessageFromFriend){// 来自好友的消息，先判断本地是否已缓存，已缓存
            PhotonIMMessage *message = (PhotonIMMessage *)voiceItem.userInfo;
            PhotonIMAudioBody *audioBody = (PhotonIMAudioBody *)message.messageBody;
            audioBody.localMediaPlayed = YES;
            NSString *fileName = audioBody.localFileName;
            if(![fileName isNotEmpty]){
                fileName = [NSString stringWithFormat:@"%.0lf",[[NSDate date] timeIntervalSince1970] * 1000];
            }
            NSString *filePath = [[PhotonMessageCenter sharedCenter] getVoiceFilePath:self.conversation.chatWith fileName:fileName];
            BOOL fileExit = [PhotonUtil jugdeFileExit:filePath];
            if (fileExit) {
                [self playAudioSource:filePath cell:voiceCell];
            }else{
                [[PhotonMessageCenter sharedCenter] insertOrUpdateMessage:message];
                PhotonDownloadFileReceipt * receipt = [[PhotonDownloadFileReceipt alloc] initWithURL:audioBody.url];
                receipt.filename = fileName;
                receipt.filePath = filePath;
                PhotonWeakSelf(self);
                [[PhotonDownLoadFileManager defaultManager] downloadFileWithReceipt:receipt progress:nil destination:nil success:^(PhotonDownloadFileReceipt * _Nullable receipt, NSError * _Nullable error) {
                     [weakself playAudioSource:receipt.filePath cell:voiceCell];
                }];
            }
        }
    }
    if([cell isKindOfClass:[PhotonChatLocationCell class]]){
        PhotonChatLocationItem *locationItem = (PhotonChatLocationItem *)chatItem;
        PhotonLocationViewContraller *locationVC = [[PhotonLocationViewContraller alloc]  initWithLocation:locationItem];
        PhotonWeakSelf(self)
        [locationVC setActionBlock:^{
            PhotonChatTransmitListViewController *transmitVc = [[PhotonChatTransmitListViewController alloc] initWithMessage:locationItem.userInfo block:^(id  _Nonnull msg) {
                [weakself addItems:msg];
            }];
            [self.navigationController pushViewController:transmitVc animated:YES];
        }];
        [self.navigationController pushViewController:locationVC animated:YES];
    }
}

- (void)playAudioSource:(NSString *)path cell:(PhotonChatVoiceMessageCell *)cell{
    [[PhotonAudioPlayer sharedAudioPlayer] playAudioAtPath:path complete:^(BOOL finished) {
        if(finished){
            [cell stopAudioAnimating];
        }
    }];
}

// 长按内容背景
- (void)chatCell:(PhotonChatBaseCell *)cell chatMessageCellLongPress:(PhotonChatBaseItem *)chatItem rect:(CGRect)rect{
    NSInteger row = [self.dataSource.items indexOfObject:chatItem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
    rect.origin.y += cellRect.origin.y - self.tableView.contentOffset.y;
    if(!self.menuView.delegate){
        self.menuView.delegate = self;
    }
    self.menuView.obj = chatItem;
    [self.menuView showMenuInSuperView:self.tableView rect:rect animation:YES];
}

// 重发消息
- (void)chatCell:(PhotonChatBaseCell *)cell resendChatMessage:(PhotonChatBaseItem *)chatItem{
    __weak typeof(self)weakSelf = self;
    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:nil message:@"是否重发该条消息？" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定重发" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf resendMessage:chatItem];
    }];
    
    UIAlertAction *cacleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
      
    }];
    
    [alterController addAction:okAction];
    [alterController addAction:cacleAction];
    [self presentViewController:alterController animated:YES completion:^{
    }];
}


// 点击头像，查看详情
- (void)chatCell:(PhotonChatBaseCell *)cell didSelectAvatar:(PhotonChatBaseItem *)chatItem{
    PhotonUser *user = nil;
    PhotonIMMessage *message = (PhotonIMMessage *)chatItem.userInfo;
    if (chatItem.fromType == PhotonChatMessageFromSelf) {
        user = [PhotonContent userDetailInfo];
    }else{
        if(message.chatType == PhotonIMChatTypeSingle){
            user = [PhotonContent friendDetailInfo:message.chatWith];
        }else if (message.chatType == PhotonIMChatTypeGroup){
             user = [PhotonContent friendDetailInfo:message.fr];
        }
    }
    PhotonFriendDetailViewController * detailCTL = [[PhotonFriendDetailViewController alloc] initWithFriend:user];
    [self.navigationController pushViewController:detailCTL animated:YES];
    
}



- (void)didSelectedItemWithType:(PhotonMenuType)Type obj:(id)obj{
    if (!obj) {
        return;
    }
    PhotonChatTextMessageItem *item = (PhotonChatTextMessageItem *)obj;
    switch (Type) {
        case PhotonMenuTypeCopy:{
            NSString *str = [item messageText];
            [[UIPasteboard generalPasteboard] setString:str];
            [self.menuView dismiss];
        }
            break;
        case PhotonMenuTypeWithdraw:{
            __weak typeof(self)weakSelf = self;
            UIAlertController *alterController = [UIAlertController alertControllerWithTitle:nil message:@"是否撤回该条消息？" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf withDrawChatMessage:item];
                
            }];
            UIAlertAction *cacleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                // 取消不做其他操作
            }];
            
            [alterController addAction:okAction];
            [alterController addAction:cacleAction];
            [self presentViewController:alterController animated:YES completion:^{
            }];
        }
            
            break;
        case PhotonMenuTypeDelete:{
            
            __weak typeof(self)weakSelf = self;
            UIAlertController *alterController = [UIAlertController alertControllerWithTitle:nil message:@"是否删除该条消息？" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf deleteChatMessage:item];
                
            }];
            
            UIAlertAction *cacleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                // 取消不做其他操作
            }];
            
            [alterController addAction:okAction];
            [alterController addAction:cacleAction];
            [self presentViewController:alterController animated:YES completion:^{
            }];
        }
            break;
        case PhotonMenuTypeTransmit:{// 转发
            PhotonWeakSelf(self)
            PhotonChatTransmitListViewController *transmitVc = [[PhotonChatTransmitListViewController alloc] initWithMessage:item.userInfo block:^(id  _Nonnull msg) {
                [weakself addItems:msg];
            }];
            [self.navigationController pushViewController:transmitVc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)addItems:(id)message{
    
    id item =  [(PhotonChatModel *)self.model wrapperMessage:message];
    [self.model.items addObject:item];
    [self reloadData];
}
#pragma mark ---- 删除消息操作 ----------
- (void)deleteChatMessage:(PhotonChatBaseItem *)item{
    if (item == nil) {
        return;
    }
   
    BOOL server = YES;
    if (server) {
        PhotonWeakSelf(self);
        [[PhotonMessageCenter sharedCenter] deleteMessage:item.userInfo completion:^(BOOL succeed, PhotonIMError * _Nullable error) {
            [weakself.model.items removeObject:item];
            if (succeed) {
               [weakself removeItem:item];
            }else{
                [PhotonUtil runMainThread:^{
                   [PhotonUtil showErrorHint:@"删除失败"];
                }];
            }
           
        }];
    }else{
        [self.model.items removeObject:item];
        [self removeItem:item];
        [[PhotonMessageCenter sharedCenter] deleteMessage:item.userInfo];
    }
    
    
}
#pragma mark ---- 撤回消息操作 ----------
- (void)withDrawChatMessage:(PhotonChatBaseItem *)item{
    if (item == nil) {
        return;
    }
    // 发送消息的撤回
    PhotonWeakSelf(self);
    [[PhotonMessageCenter sharedCenter] sendWithDrawMessage:item completion:^(BOOL succeed, PhotonIMError * _Nullable error) {
        if (succeed) {
            [weakself loadNoticItem:error.em item:item];
        }else{
            [PhotonUtil showErrorHint:error.em];
        }
    }];
}


- (void)loadNoticItem:(NSString *)em item:(id)item{
    PhotonChatNoticItem *noticItem = [[PhotonChatNoticItem alloc] init];
    noticItem.notic = em;
    noticItem.userInfo = [item userInfo];
    NSInteger index = [self.dataSource.items indexOfObject:item];
    [self.model.items replaceObjectAtIndex:index withObject:noticItem];
    [self reloadData];
}
@end
#pragma clang diagnostic pop


