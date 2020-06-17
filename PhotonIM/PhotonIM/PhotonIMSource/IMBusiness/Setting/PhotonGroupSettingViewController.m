//
//  PhotonGroupSettingViewController.m
//  PhotonIM
//
//  Created by Bruce on 2019/9/25.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonGroupSettingViewController.h"
#import "PhotonMacros.h"
#import "PhotonGroupTitleTableViewCell.h"
#import "PhotonGroupTitleTableItem.h"
#import "PhotonMessageSettingItem.h"
#import "PhotonMessageSettingCell.h"
#import "PhotonEmptyTableItem.h"
#import "PhotonGroupMemberTableItem.h"
#import "PhotonGroupMemberCell.h"
#import "PhotonNetworkService.h"
#import "PhotonGroupMemberListViewController.h"
#import "PhotonChatSearchReultTableViewController.h"
typedef void(^Compention)(BOOL deleteMsg);
@interface PhotonGroupSettingDataSource ()
@end

@implementation PhotonGroupSettingDataSource
- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object{
    if ([object isKindOfClass:[PhotonMessageSettingItem class]]) {
        return [PhotonMessageSettingCell class];
    }else if ([object isKindOfClass:[PhotonGroupTitleTableItem class]]){
        return [PhotonGroupTitleTableViewCell class];
    }else if ([object isKindOfClass:[PhotonGroupMemberTableItem class]]){
         return [PhotonGroupMemberCell class];
    }
    return [super tableView:tableView cellClassForObject:object];
}
@end


@interface PhotonGroupSettingViewController()<PhotonMessageSettingCellDelegate>
@property (nonatomic, copy, nullable)PhotonIMConversation *conversation;
@property (nonatomic, strong, nullable)PhotonNetworkService *netService;
@property (nonatomic, copy ,nullable)Compention completion;
@end

@implementation PhotonGroupSettingViewController
- (instancetype)initWithGroupID:(PhotonIMConversation *)conversation compeltion:(void(^)(BOOL deleteMsg))completion{
    self = [super init];
    if (self) {
        _conversation = conversation;
        _completion = [completion copy];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息设置";
    [self.view setBackgroundColor:[UIColor colorWithHex:0xF3F3F3]];
    self.tableView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    self.tableView.scrollEnabled = NO;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.view).mas_equalTo(0);
        make.bottom.mas_equalTo(self.view).mas_equalTo(-SAFEAREA_INSETS_BOTTOM);
    }];
    [self loadPreDataItems];
}

- (void)loadPreDataItems{
    PhotonWeakSelf(self);
    [[PhotonContent currentUser] loadGroupProfile:self.conversation.chatWith completion:^(NSString * _Nonnull gid, BOOL success) {
        NSString *gid_ = gid;
        if (!gid_) {
            gid_ = self.conversation.chatWith;
        }
        if (gid_) {
            if(self.conversation.chatType == PhotonIMChatTypeGroup){
                [[PhotonContent currentUser] loadMembersFormGroup:gid_ completion:^(BOOL success) {
                    [weakself p_loadDataItems];
                }];
            }else if (self.conversation.chatType == PhotonIMChatTypeRoom){
                [[PhotonContent currentUser] loadMembersFormRoom:gid_ completion:^(BOOL success) {
                                   [weakself p_loadDataItems];
                }];
            }
            
        }
    }];
}

- (void)p_loadDataItems{
    PhotonUser *user = [PhotonContent friendDetailInfo:self.conversation.chatWith];
    NSArray *members = [PhotonContent findAllUsersWithGroupId:self.conversation.chatWith];
    PhotonEmptyTableItem *emptyItem = [[PhotonEmptyTableItem alloc] init];
    emptyItem.itemHeight = 5;
    emptyItem.backgroudColor = [UIColor clearColor];
    [self.items addObject:emptyItem];
    
    PhotonGroupTitleTableItem *titleItem = [[PhotonGroupTitleTableItem alloc] init];
    titleItem.title = @"聊天组名称";
    titleItem.itemHeight = 70;
    titleItem.icon = @"right_arrow";;
    titleItem.detail = user.nickName?user.nickName:@"无";
    titleItem.userInfo = [PhotonContent friendDetailInfo:self.conversation.chatWith];
    [self.items addObject:titleItem];
    
    PhotonEmptyTableItem *secondEmptyItem = [[PhotonEmptyTableItem alloc] init];
    secondEmptyItem.itemHeight = 11;
    secondEmptyItem.backgroudColor = [UIColor clearColor];
    [self.items addObject:secondEmptyItem];
    
    PhotonGroupTitleTableItem *memberItem = [[PhotonGroupTitleTableItem alloc] init];
    memberItem.title = @"组成员";
    memberItem.itemHeight = 30;
    memberItem.icon = @"right_arrow";
    NSInteger count = [members count];
    memberItem.detail = [NSString stringWithFormat:@"%@人",@(count)];
    memberItem.userInfo = [PhotonContent friendDetailInfo:self.conversation.chatWith];
    [self.items addObject:memberItem];
    
    PhotonGroupMemberTableItem *memberItem1 = [[PhotonGroupMemberTableItem alloc] init];
    memberItem1.memebers = members;
    memberItem1.itemHeight = 75;
    [self.items addObject:memberItem1];
    
    [self.items addObject:secondEmptyItem];
    
    PhotonMessageSettingItem *searchItem = [[PhotonMessageSettingItem alloc] init];
    searchItem.settingName = @"查找聊天内容";
    searchItem.showSwitch = NO;
    searchItem.icon = @"right_arrow";
    searchItem.type = PhotonMessageSettingTypeSearch;
    [self.items addObject:searchItem];
    
    
    PhotonMessageSettingItem *settionItem = [[PhotonMessageSettingItem alloc] init];
    settionItem.settingName = @"消息免打扰";
    settionItem.open = _conversation.ignoreAlert;
    settionItem.type = PhotonMessageSettingTypeIgnoreAlert;
    [self.items addObject:settionItem];
    
    PhotonMessageSettingItem *stickyItem = [[PhotonMessageSettingItem alloc] init];
    stickyItem.settingName = @"置顶";
    stickyItem.open = _conversation.sticky;
    stickyItem.type = PhotonMessageSettingTypeIgnorSticky;
    [self.items addObject:stickyItem];
    
    [self.items addObject:emptyItem];
    PhotonMessageSettingItem *clearItem = [[PhotonMessageSettingItem alloc] init];
    clearItem.settingName = @"清空聊天记录";
    clearItem.showSwitch = NO;
    clearItem.type = PhotonMessageSettingTypeClearHistory;
    [self.items addObject:clearItem];
    
    PhotonGroupSettingDataSource *dataSource = [[PhotonGroupSettingDataSource alloc] initWithItems:self.items];
    self.dataSource = dataSource;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = self.items[indexPath.row];
    BOOL gotoMember = NO;
    if ([item isKindOfClass:[PhotonGroupTitleTableItem class]]) {
        if([[item title] isEqualToString:@"组成员"]){
            gotoMember = YES;
        }
    }else if([item isKindOfClass:[PhotonGroupMemberTableItem class]]){
        gotoMember = YES;
        
    }else if([item isKindOfClass:[PhotonMessageSettingItem class]]){
        if ([(PhotonMessageSettingItem *)item type] == PhotonMessageSettingTypeSearch) {
            PhotonChatSearchReultTableViewController *contr = [[PhotonChatSearchReultTableViewController alloc] initWithChatType:_conversation.chatType chatWith:_conversation.chatWith];
                      [self.navigationController pushViewController:contr animated:YES];
        }else if ([(PhotonMessageSettingItem *)item type] == PhotonMessageSettingTypeClearHistory) {
            UIAlertController *alertCv = [UIAlertController alertControllerWithTitle:@"删除聊天记录" message:@"清空后不可恢复，请谨慎操作"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
             __weak typeof(self)weakSelf = self;
            
             UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                  [PhotonUtil showLoading:@"删除中..."];
                 [[PhotonMessageCenter sharedCenter] clearMessagesWithChatType:weakSelf.conversation.chatType chatWith:weakSelf.conversation.chatWith syncServer:YES completion:^(BOOL finish) {
                        [PhotonUtil hiddenLoading];
                        if (finish) {
                            if (weakSelf.completion) {
                                weakSelf.completion(YES);
                            }
                            [PhotonUtil showSuccessHint:@"删除成功"];
                        }else{
                             [PhotonUtil showErrorHint:@"删除失败，请重试"];
                        }
                    }];
             }];
             UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
             }];
             [alertCv addAction:action1];
             [alertCv addAction:action2];
             [self presentViewController:alertCv animated:YES completion:nil];
        }
    }
    
    if(gotoMember){
        PhotonGroupMemberListViewController *memberCtl = [[PhotonGroupMemberListViewController alloc] initWithGid:self.conversation.chatWith];
        memberCtl.isRoom = self.conversation.chatType = PhotonIMChatTypeRoom;
        [self.navigationController pushViewController:memberCtl animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[PhotonMessageSettingCell class]]) {
        PhotonMessageSettingCell *tempCell = (PhotonMessageSettingCell *)cell;
        tempCell.delegate = self;
        
    }
}

- (void)cell:(id)cell switchItem:(PhotonMessageSettingItem *)item{
    switch (item.type) {
        case PhotonMessageSettingTypeIgnoreAlert:{
            _conversation.ignoreAlert = item.open;
            [self setIgnoreAlert:item.open];
        }
            break;
        case PhotonMessageSettingTypeIgnorSticky:{
            _conversation.sticky = item.open;
            [[PhotonIMClient sharedClient] updateConversationSticky:_conversation];
        }
            break;
            
        default:
            break;
    }
}

- (void)setIgnoreAlert:(BOOL)open{
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setValue:self.conversation.chatWith forKey:@"gid"];
    [paramter setValue:@(!open) forKey:@"switch"];
    PhotonWeakSelf(self);
    [self.netService commonRequestMethod:PhotonRequestMethodPost queryString:@"photonimdemo/setting/msg/setP2GRemind" paramter:paramter completion:^(NSDictionary * _Nonnull dict) {
         [[PhotonMessageCenter sharedCenter] updateConversationIgnoreAlert:weakself.conversation];
        [PhotonUtil showSuccessHint:@"设置成功!"];
    } failure:^(PhotonErrorDescription * _Nonnull error) {
        [PhotonUtil showErrorHint:@"设置失败!"];
    }];
}
- (PhotonNetworkService *)netService{
    if (!_netService) {
        _netService = [[PhotonNetworkService alloc] init];
        _netService.baseUrl = [PhotonContent baseUrlString];;
        
    }
    return _netService;
}
@end
