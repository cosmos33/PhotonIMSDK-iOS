//
//  PhotonMessageSettingViewController.m
//  PhotonIM
//
//  Created by Bruce on 2019/7/31.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonSingleSettingViewController.h"
#import "PhotonMessageSettingItem.h"
#import "PhotonMessageSettingCell.h"
#import "PhotonNetworkService.h"
#import "PhotonBaseContactItem.h"
#import "PhotonBaseContactCell.h"
#import "PhotonEmptyTableItem.h"
#import "PhotonChatSearchReultTableViewController.h"
typedef void(^Compention)(BOOL deleteMsg);
@interface PhotonSingleSettingDataSource ()
@end

@implementation PhotonSingleSettingDataSource
- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object{
    if ([object isKindOfClass:[PhotonMessageSettingItem class]]) {
        return [PhotonMessageSettingCell class];
    }else if ([object isKindOfClass:[PhotonBaseContactItem class]]){
        return [PhotonBaseContactCell class];
    }
    return [super tableView:tableView cellClassForObject:object];
}
@end
@interface PhotonSingleSettingViewController ()<UITableViewDelegate,PhotonMessageSettingCellDelegate>
@property (nonatomic, weak, nullable)PhotonIMConversation *conversation;
@property (nonatomic, strong, nullable)PhotonNetworkService *netService;
@property (nonatomic, copy ,nullable)Compention completion;
@end

@implementation PhotonSingleSettingViewController

- (instancetype)initWithConversation:(PhotonIMConversation *)conversation compeltion:(void(^)(BOOL deleteMsg))completion{
    self = [super init];
    if (self) {
        _conversation = conversation;
        _completion = completion;
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
    PhotonEmptyTableItem *emptyItem = [[PhotonEmptyTableItem alloc] init];
    emptyItem.itemHeight = 11;
    emptyItem.backgroudColor = [UIColor clearColor];
    [self.items addObject:emptyItem];
    
    PhotonBaseContactItem *contactItem = [[PhotonBaseContactItem alloc] init];
    contactItem.contactName = self.conversation.FName?self.conversation.FName:self.conversation.chatWith;
    contactItem.contactAvatar = self.conversation.FAvatarPath;
    contactItem.itemHeight = 63;
    contactItem.userInfo = [PhotonContent friendDetailInfo:self.conversation.chatWith];
    [self.items addObject:contactItem];
    
    [self.items addObject:emptyItem];
    
    PhotonMessageSettingItem *searchItem = [[PhotonMessageSettingItem alloc] init];
    searchItem.settingName = @"查找聊天内容";
    searchItem.showSwitch = NO;
    searchItem.icon = @"right_arrow";
    searchItem.type = PhotonMessageSettingTypeSearch;
    [self.items addObject:searchItem];
    
     [self.items addObject:emptyItem];
    
    PhotonMessageSettingItem *settionItem = [[PhotonMessageSettingItem alloc] init];
    settionItem.settingName = @"消息免打扰";
     settionItem.showSwitch = YES;
    settionItem.open = _conversation.ignoreAlert;
    settionItem.type = PhotonMessageSettingTypeIgnoreAlert;
    [self.items addObject:settionItem];
    
    PhotonMessageSettingItem *stickyItem = [[PhotonMessageSettingItem alloc] init];
    stickyItem.settingName = @"置顶";
     stickyItem.showSwitch = YES;
    stickyItem.open = _conversation.sticky;
    stickyItem.type = PhotonMessageSettingTypeIgnorSticky;
    [self.items addObject:stickyItem];
    
    [self.items addObject:emptyItem];
    PhotonMessageSettingItem *clearItem = [[PhotonMessageSettingItem alloc] init];
    clearItem.settingName = @"清空聊天记录";
    clearItem.showSwitch = NO;
    clearItem.type = PhotonMessageSettingTypeClearHistory;
    [self.items addObject:clearItem];
    
    PhotonSingleSettingDataSource *dataSource = [[PhotonSingleSettingDataSource alloc] initWithItems:self.items];
    self.dataSource = dataSource;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = self.items[indexPath.row];
    if ([item isKindOfClass:[PhotonMessageSettingItem class]]) {
        PhotonMessageSettingItem *tempItem = (PhotonMessageSettingItem *)item;
        if (tempItem.type == PhotonMessageSettingTypeSearch) {
            PhotonChatSearchReultTableViewController *contr = [[PhotonChatSearchReultTableViewController alloc] initWithChatType:_conversation.chatType chatWith:_conversation.chatWith];
            [self.navigationController pushViewController:contr animated:YES];
        }else if (tempItem.type == PhotonMessageSettingTypeClearHistory){
            UIAlertController *alertCv = [UIAlertController alertControllerWithTitle:@"删除聊天记录" message:@"清空后不可恢复，请谨慎操作"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
            __weak typeof(self)weakSelf = self;
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [PhotonUtil showLoading:@"删除中...,请等待"];
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
            [[PhotonMessageCenter sharedCenter] updateConversationIgnoreAlert:_conversation];
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
    [paramter setValue:self.conversation.chatWith forKey:@"remoteid"];
    [paramter setValue:@(!open) forKey:@"switch"];
    [self.netService commonRequestMethod:PhotonRequestMethodPost queryString:@"photonimdemo/setting/msg/setP2pRemind" paramter:paramter completion:^(NSDictionary * _Nonnull dict) {
    } failure:^(PhotonErrorDescription * _Nonnull error) {
        [PhotonUtil showErrorHint:@"勿扰模式保存失败!"];
    }];
}
- (PhotonNetworkService *)netService{
    if (!_netService) {
        _netService = [[PhotonNetworkService alloc] init];
        _netService.baseUrl = [PhotonContent baseUrlString];
        
    }
    return _netService;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
