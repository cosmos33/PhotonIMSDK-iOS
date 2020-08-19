//
//  PhotonConversationListViewController+Delegate.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/27.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonConversationListViewController+Delegate.h"
#import "PhotonMessageCenter.h"
#import "PhotonConversationItem.h"
#import "PhotonConversationBaseCell.h"
#import "PhotonChatViewController.h"
#import "PhotonFriendDetailViewController.h"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
@implementation PhotonConversationListViewController (Delegate)
#pragma mark --------- UITableViewDelegate -----
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSource.items.count <= indexPath.row) {
        return @[];
    }
    __weak typeof(self)weakSelf = self;
    UITableViewRowAction *delAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                         title:@"删除"
                                                                       handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                           [weakSelf p_deleteCellWithIndexPath:indexPath];
                                                                              [tableView setEditing:NO animated:YES];
                                                                       }];
    
    PhotonConversationItem *item = self.dataSource.items[indexPath.row];
    if (!item.userInfo) {
          return @[delAction];
    }
    NSInteger count = [item.userInfo unReadCount];
    NSString *readTitle = @"标为已读";
    if (count == 0) {
        readTitle = @"标为未读";
    }
    UITableViewRowAction *readAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                            title:readTitle
                                                                          handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                 [tableView setEditing:NO animated:YES];
                                                                          }];
    return @[delAction,readAction];
}

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)){
    if (self.dataSource.items.count <= indexPath.row) {
           return nil;
    }
    __weak typeof(self)weakSelf = self;
    if (@available(iOS 11.0, *)) {
        UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
             [weakSelf p_deleteCellWithIndexPath:indexPath];
             [tableView setEditing:NO animated:YES];
        }];
        deleteRowAction.backgroundColor = [UIColor redColor];
        NSMutableArray *actions = [NSMutableArray array];
        [actions addObject:deleteRowAction];
        
        PhotonConversationItem *item = self.dataSource.items[indexPath.row];
        if (item.userInfo) {
            NSInteger count = [item.userInfo unReadCount];
            NSString *readTitle = @"标为已读";
            if (count == 0) {
                readTitle = @"标为未读";
            }
            UIContextualAction *readAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:readTitle handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
                 [tableView setEditing:NO animated:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [weakSelf reacAction:indexPath];
                });
             }];
            readAction.backgroundColor = [UIColor grayColor];
            [actions addObject:readAction];
        }
       
        
    
        UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:actions];
        config.performsFirstActionWithFullSwipe = false;
        return config;
    }else{
        return nil;
    }
    return nil;
}




- (void)p_deleteCellWithIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.model.items.count) {
        PhotonConversationItem *item = [self.model.items objectAtIndex:indexPath.row];
        [self.model.items removeObjectAtIndex:indexPath.row];
        self.dataSource.items = self.model.items;
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
        [[PhotonMessageCenter sharedCenter] deleteConversation:item.userInfo clearChatMessage:YES];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSource.items.count > indexPath.row) {
        PhotonConversationItem *item = [[self.model.items objectAtIndex:indexPath.row] isNil];
        if (!item) {
            return;
        }
        PhotonChatViewController *chatvc = [[PhotonChatViewController alloc] initWithConversation:item.userInfo];
        [chatvc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chatvc animated:YES];
        [[PhotonMessageCenter sharedCenter]clearConversationUnReadCount:item.userInfo];
        [[PhotonMessageCenter sharedCenter] resetAtType:item.userInfo];
         
    }
}

- (void)reacAction:(NSIndexPath *)indexPath{
    if (self.dataSource.items.count <= indexPath.row) {
        return;
    }
    PhotonConversationItem *item = [[self.model.items objectAtIndex:indexPath.row] isNil];
    if (!item.userInfo) {
        return;
    }
    NSInteger count = [item.userInfo unReadCount];
    PhotonIMConversation *conver = item.userInfo;
    if (count > 0) {
        [[PhotonIMClient sharedClient] setConversationRead:[conver chatType] chatWith:[conver chatWith]];
    }else{
        [[PhotonIMClient sharedClient] setConversationUnRead:[conver chatType] chatWith:[conver chatWith]];
    }
}
@end
#pragma clang diagnostic pop
