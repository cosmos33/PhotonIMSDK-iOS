//
//  PhotonGroupContactViewController.m
//  PhotonIM
//
//  Created by Bruce on 2019/9/23.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonGroupContactViewController.h"
#import "PhotonBaseViewController+Refresh.h"
#import "PhotonGroupContactModel.h"
#import "PhotonContacDataSource.h"
#import "PhotonGroupContactItem.h"
#import "PhotonGroupContactCell.h"
#import "PhotonChatViewController.h"

@interface PhotonGroupContactViewController ()<PhotonGroupContactCellDelegate>
@property (nonatomic, strong, nullable)PhotonGroupContactModel *model;
@property(nonatomic,assign)NSInteger type;
@end

@implementation PhotonGroupContactViewController
- (instancetype)initWithType:(NSInteger)type{
    self = [super init];
    if (self) {
        _type = type;
        self.model = [[PhotonGroupContactModel alloc] init];
        self.model.type = type;
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.model = [[PhotonGroupContactModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRefreshHeader];
    if (_type == 2) {
        self.title = @"附近的群组";
    }else{
        self.title = @"附近的房间";
    }
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self loadPreDataItems];
}

- (void)loadPreDataItems{
    __weak typeof(self)weakSlef = self;
    [self.model loadItems:nil finish:^(NSDictionary * _Nullable dict) {
        [weakSlef removeNoDataView];
        [weakSlef p_loadDataItems];
        [weakSlef endRefreshing];
    } failure:^(PhotonErrorDescription * _Nullable error) {
        [PhotonUtil showAlertWithTitle:@"列表加载失败" message:error.errorMessage];
        [weakSlef p_loadDataItems];
        [weakSlef loadNoDataView];
        [weakSlef endRefreshing];
    }];
}
- (void)p_loadDataItems{
    PhotonContacDataSource *dataSource = [[PhotonContacDataSource alloc] initWithItems:self.model.items];
    self.dataSource = dataSource;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [PhotonUtil hiddenLoading];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[PhotonGroupContactCell class]]) {
        PhotonGroupContactCell *tempCell = (PhotonGroupContactCell *)cell;
        tempCell.delegate = self;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.model.items.count) {
        PhotonGroupContactItem *temp_Item = (PhotonGroupContactItem *)[self.model.items objectAtIndex:indexPath.row];
        if (temp_Item.isInGroup && self.type == 2) {
            PhotonIMConversation *conversation = [[PhotonIMConversation alloc] initWithChatType:PhotonIMChatTypeGroup chatWith:temp_Item.contactID];
            conversation.FName = temp_Item.contactName;
            PhotonChatViewController *chatCtl = [[PhotonChatViewController alloc] initWithConversation:conversation];
            [self.navigationController pushViewController:chatCtl animated:YES];
            
        }else if (self.type == 3){
            PhotonWeakSelf(self)
            [PhotonUtil showLoading:@"正在加入房间..."];
            [self.model enter:temp_Item.contactID finish:^(NSDictionary * _Nullable dict) {
               // 加入聊天室
               PhotonIMConversation *conversation = [[PhotonIMConversation alloc] initWithChatType:PhotonIMChatTypeRoom chatWith:temp_Item.contactID];
               // 调用绑定房间的方法
                [[PhotonIMClient sharedClient] sendJoinRoomWithId:temp_Item.contactID timeout:15 completion:^(BOOL succeed, PhotonIMError * _Nullable error) {
                    // 是否处理有业务端决定
                    if(succeed){
                        [PhotonUtil hiddenLoading];
                        PhotonUser *user = [PhotonContent userDetailInfo];
                        NSData *data = [[NSString stringWithFormat:@"%@加入房间",user.nickName] dataUsingEncoding:NSUTF8StringEncoding];
                         PhotonIMMessage *message = [PhotonIMMessage commonMessageWithFrid:[PhotonContent currentUser].userID toid:conversation.chatWith messageType:PhotonIMMessageTypeRaw chatType:PhotonIMChatTypeRoom];
                        PhotonIMCustomBody *body = [PhotonIMCustomBody customBodyWithArg1:1 arg2:2 customData:data];
                        [message setMesageBody:body];
                        [[PhotonIMClient sharedClient] sendMessage:message timeout:5 completion:^(BOOL succeed, PhotonIMError * _Nullable error) {
                        }];
                        // 绑定房间成功
                    }else{
                         [PhotonUtil hiddenLoading];
                        // 绑定房间失败
                    }
                }];
               conversation.FName = temp_Item.contactName;
               PhotonChatViewController *chatCtl = [[PhotonChatViewController alloc] initWithConversation:conversation];
               [weakself.navigationController pushViewController:chatCtl animated:YES];
            } failure:^(PhotonErrorDescription * _Nullable error) {
                [PhotonUtil hiddenLoading];
                [PhotonUtil showAlertWithTitle:@"加入房间失败" message:error.errorMessage];
            }];
            
        }
    }
}

- (void)refreshCellAfterEnterGroup:(NSIndexPath *)indexPath{
    if (indexPath.row < self.model.items.count) {
        PhotonGroupContactItem *temp_Item = (PhotonGroupContactItem *)[self.model.items objectAtIndex:indexPath.row];
        temp_Item.isInGroup = YES;
        [self.model.items replaceObjectAtIndex:indexPath.row withObject:temp_Item];
        [PhotonUtil runMainThread:^{
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    
}

- (void)cellEnterGroup:(PhotonGroupContactCell *)cell item:(id)item{
    PhotonGroupContactItem *temp_Item = (PhotonGroupContactItem *)item;
    if (!temp_Item || self.model.items.count == 0) {
        return;
    }
    NSInteger index = [self.model.items indexOfObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    PhotonWeakSelf(self);
    if (!temp_Item.isInGroup) {
        [self.model enter:temp_Item.contactID finish:^(NSDictionary * _Nullable dict) {
            [weakself refreshCellAfterEnterGroup:indexPath];
        } failure:^(PhotonErrorDescription * _Nullable erro) {
            
        }];
    }
}

@end
