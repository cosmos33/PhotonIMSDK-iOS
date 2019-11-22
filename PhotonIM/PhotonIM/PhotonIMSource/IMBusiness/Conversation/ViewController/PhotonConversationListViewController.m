//
//  PhotonConversationListViewController.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/19.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonConversationListViewController.h"
#import <MMFoundation/MMFoundation.h>
#import "PhotonBaseViewController+Refresh.h"
#import "PhotonConversationDataSource.h"
#import "PhotonConversationItem.h"
#import "PhotonConversationModel.h"
#import "PhotonMessageCenter.h"
#import "PhotonNetTableItem.h"

static NSString *message_title = @"消息";
static NSString *message_connecting = @"消息(连接中...)";
static NSString *message_no_connect = @"消息(未连接)";
static NSString *message_syncing = @"消息(收取中......)";

@interface PhotonConversationListViewController ()<PhotonMessageProtocol,MFDispatchSourceDelegate>
@property (nonatomic, strong, nullable)PhotonConversationModel *model;
@property (nonatomic, strong, nullable)MFDispatchSource  *uiDispatchSource;
@property (nonatomic, strong, nullable)MFDispatchSource  *dataDispatchSource;
@property (nonatomic, assign)BOOL   isAppeared;
@property (nonatomic, assign)BOOL   needRefreshData;
@property (nonatomic, strong)PhotonIMTimer *imTimer;
@property (nonatomic, assign)NSInteger  refreshCount;
@property (nonatomic, assign)BOOL  isExcute;
@property (nonatomic, assign)NSInteger lastOprationTimeStamp;

@property (atomic, assign)BOOL isRefreshing;
@end

@implementation PhotonConversationListViewController
- (void)dealloc
{
    [[PhotonMessageCenter sharedCenter] removeObserver:self];
    [_uiDispatchSource clearDelegateAndCancel];
    [_dataDispatchSource clearDelegateAndCancel];
}

- (void)setNavTitle:(NSString *)text{
    PhotonWeakSelf(self);
    [PhotonUtil runMainThread:^{
        NSInteger totalCount = [[PhotonMessageCenter sharedCenter] unreadMsgCount];
        if([text isEqualToString:message_title] && totalCount > 0){
            weakself.navigationItem.title = [NSString stringWithFormat:@"消息(%@)",@(totalCount)];
        }else{
            weakself.navigationItem.title = text;
        }
        
    }];
}


- (void)setTabBarBadgeValue{
     PhotonWeakSelf(self);
    [PhotonUtil runMainThread:^{
        NSInteger totalCount = [[PhotonMessageCenter sharedCenter] unreadMsgCount];
        if (totalCount > 0) {
            NSString *valueStr = [NSString stringWithFormat:@"%@",@(totalCount)];
//            if (totalCount > 99) {
//                totalCount = 99;
//                valueStr = [NSString stringWithFormat:@"%@+",@(totalCount)];
//            }
            weakself.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@",valueStr];
            weakself.tabBarItem.badgeColor = [UIColor redColor];
            weakself.navigationItem.title = [NSString stringWithFormat:@"消息(%@)",valueStr];
        }else{
            weakself.tabBarItem.badgeValue = nil;
            if (![weakself.navigationItem.title containsString:@"连接"]) {
                 weakself.navigationItem.title = message_title;
            }
           
        }
    }];
}
- (instancetype)init
{
    if (self = [super init]) {
         [[PhotonMessageCenter sharedCenter] addObserver:self];
        _refreshCount = 0;
        [self.tabBarItem setTitle:@"消息"];
        [self.tabBarItem setImage:[UIImage imageNamed:@"message"]];
        [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"message_onClick"]];
        _uiDispatchSource = [MFDispatchSource sourceWithDelegate:self type:refreshType_UI dataQueue:dispatch_get_main_queue()];

        _dataDispatchSource = [MFDispatchSource sourceWithDelegate:self type:refreshType_Data dataQueue:dispatch_queue_create("com.cosmos.PhotonIM.conversationdata", DISPATCH_QUEUE_SERIAL)];

    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.needRefreshData) {
        [self.dataDispatchSource addSemaphore];
        self.needRefreshData = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isAppeared = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isAppeared = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"消息"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.dataDispatchSource addSemaphore];
}
- (void)addNetStatusItem{
    PhotonNetTableItem *item = [[PhotonNetTableItem alloc] init];
    item.message = @"网络断开，请检查网络配置";
    [self.model.items insertObject:item atIndex:0];
    [self.uiDispatchSource addSemaphore];
}
- (void)removeNetStatusItem{
    id item = [self.model.items firstObject];
    if ([item isKindOfClass:[PhotonNetTableItem class]]) {
        [self.model.items removeObject:item];
    }
    [self.uiDispatchSource addSemaphore];;
}
- (void)loadDataItems{
    __weak typeof(self)weakSlef = self;
    [self.model loadItems:nil finish:^(NSDictionary * _Nullable dict) {
        [weakSlef removeNoDataView];
        [weakSlef.uiDispatchSource addSemaphore];
        [weakSlef endRefreshing];
        weakSlef.isRefreshing = NO;
    } failure:^(PhotonErrorDescription * _Nullable error) {
        [PhotonUtil showAlertWithTitle:@"加载会话列表失败" message:error.errorMessage];
        [weakSlef.uiDispatchSource addSemaphore];
        [weakSlef loadNoDataView];
        [weakSlef endRefreshing];
        weakSlef.isRefreshing = NO;
    }];
}
- (void)reloadData{
    PhotonConversationDataSource *dataSource = [[PhotonConversationDataSource alloc] initWithItems:self.model.items];
    self.dataSource = dataSource;
}

- (void)conversationChange:(PhotonIMConversationEvent)envent chatType:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith{
   
    switch (envent) {
        case PhotonIMConversationEventCreate:{
            [self getIgnoreAlerm:chatType chatWith:chatWith];
        }
            break;
        case PhotonIMConversationEventDelete:
            break;
        case PhotonIMConversationEventUpdate:
            break;
        default:
            break;
    }
   
    if (!self.isAppeared) {
        [self setTabBarBadgeValue];
        self.needRefreshData  = YES;
        return;
    }
    [self.dataDispatchSource addSemaphore];
   
}

- (void)imClient:(id)client didReceiveMesage:(PhotonIMMessage *)message{
    [[PhotonIMClient sharedClient] consumePacket:message.lt lv:message.lv];
}

- (void)readyRefreshConversations{
    if (_isRefreshing) {
        return;
    }
    _isRefreshing = YES;
    [self startRefreshConversations];
}

- (void)startRefreshConversations{
    [self loadDataItems];
}

- (void)getIgnoreAlerm:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith{
    [[PhotonContent currentUser] getIgnoreAlert:chatType chatWith:chatWith completion:^(BOOL success, BOOL open) {
         PhotonIMConversation *conversation = [[PhotonIMConversation alloc] initWithChatType:chatType chatWith:chatWith];
        conversation.ignoreAlert = !open;
        [[PhotonMessageCenter sharedCenter] updateConversationIgnoreAlert:conversation];
    }];
}

- (void)networkChange:(PhotonIMNetworkStatus)networkStatus{
    if (networkStatus == PhotonIMNetworkStatusNone) {
        [self setNavTitle:message_no_connect];
    }
}

- (void)imClientLogin:(id)client loginStatus:(PhotonIMLoginStatus)loginstatus{
    switch (loginstatus) {
        case PhotonIMLoginStatusConnecting:// 连接中
            [self setNavTitle:message_connecting];
            break;
        case PhotonIMLoginStatusConnected:// 连接成功
            break;
        case PhotonIMLoginStatusLoginSucceed:// 登录成功
             [self setNavTitle:message_title];
            break;
        case PhotonIMLoginStatusConnectFailed:// 连接失败
             [self setNavTitle:message_no_connect];
            break;
        default:
            break;
    }
}

- (BOOL)imClientSync:(id)client syncStatus:(PhotonIMSyncStatus)status{
    switch (status) {
        case PhotonIMSyncStatusSyncStart:{
            [self setNavTitle:message_syncing];
        }
            break;
        case PhotonIMSyncStatusSyncEnd:
           [self setTabBarBadgeValue];
           [self setNavTitle:message_title];
            break;
        case PhotonIMSyncStatusSyncTimeout:
            break;
        default:
            break;
    }
    PhotonLog(@"imClientSync:(nonnull id)client syncStatus:(PhotonIMSyncStatus)status 1");
    return YES;
}

- (PhotonConversationModel *)model{
    if (!_model) {
        _model = [[PhotonConversationModel alloc] init];
    }
    return _model;
}

#pragma mark --- 刷新数据 ------
- (void)refreshUI{
    [self reloadData];
}

- (void)refreshData{
    [self readyRefreshConversations];
}
@end
