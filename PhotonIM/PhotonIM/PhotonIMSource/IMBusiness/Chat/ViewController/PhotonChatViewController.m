//
//  PhotonChatViewController.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/19.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonChatViewController.h"
#import <MMFoundation/MMFoundation.h>
#import "PhotonBaseViewController+Refresh.h"
#import "PhotonMessageCenter.h"
#import "PhotonSingleSettingViewController.h"
#import "PhotonGroupSettingViewController.h"
#import <AVFoundation/AVFoundation.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
@interface PhotonChatViewController ()
@property(nonatomic,strong,nullable)PhotonChatPanelManager *panelManager;
@property(nonatomic,strong,nullable)PhotonCharBar *chatBar;
@property(nonatomic,strong,nullable)PhotonMenuView *menuView;

@property(nonatomic, strong, nullable)PhotonIMConversation *conversation;

@property (nonatomic, strong, nullable)MFDispatchSource  *dataDispatchSource;

@property (nonatomic, assign)BOOL isFirstPage;
@property (nonatomic, strong,nullable)UIView  *testUIView;
// 内容
@property (nonatomic, strong,nullable)UITextField  *contentFiled;
// 间隔放松的时间
@property (nonatomic, strong,nullable)UITextField  *intervalFiled;
// 间隔放松的时间
@property (nonatomic, strong,nullable)UITextField  *countFiled;
//发送按钮
@property (nonatomic, strong,nullable)UIButton  *autoSendMessage;
//发送按钮
@property (nonatomic, strong,nullable)UIButton  *stopSendMessage;
//发送按钮
@property (nonatomic, copy,nullable)NSString  *content;
// login内容
@property (nonatomic, strong,nullable)UILabel  *authFiled;
@property (nonatomic, assign)NSTimeInterval  interval;
@property (atomic, assign)BOOL  isStop;
@property (nonatomic, assign)NSInteger authSucceedCount;
@property (nonatomic, assign)NSInteger authFaileddCount;
@property (atomic, assign)BOOL scrollTop;
@property (nonatomic,assign)BOOL loadFtsRet;
@property (nonatomic, assign)BOOL isLoading;
@property (nonatomic, strong)AVAudioPlayer *player;
@end

@implementation PhotonChatViewController
- (instancetype)initWithConversation:(nullable PhotonIMConversation *)conversation{
    self = [self init];
    if (self) {
        _conversation = conversation;
        _panelManager = [[PhotonChatPanelManager alloc] initWithIdentifier:conversation.chatWith];
        _panelManager.draft = conversation.draft;
        _panelManager.delegate = self;
        
        _dataDispatchSource = [MFDispatchSource sourceWithDelegate:self type:refreshType_Data dataQueue:dispatch_queue_create("com.cosmos.PhotonIM.chatdata", DISPATCH_QUEUE_SERIAL)];
    }
    return self;
}
- (instancetype)initWithConversation:(nullable PhotonIMConversation *)conversation loadFtsResult:(BOOL)loadFtsRet{
    self = [self initWithConversation:conversation];
    if (self) {
        _loadFtsRet = loadFtsRet;
        if (_conversation.lastMsgId && _loadFtsRet) {
             [(PhotonChatModel *)self.model setAnchorMsgId:_conversation.lastMsgId];
        }
         [(PhotonChatModel *)self.model setLoadFtsData:_loadFtsRet];
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[PhotonMessageCenter sharedCenter] removeObserver:self];
    [self.tableView removeObserver:self forKeyPath:@"bounds"];
    [PhotonUtil resetLastShowTimestamp];
    [_dataDispatchSource clearDelegateAndCancel];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _isLoading = NO;
        self.model = [[PhotonChatModel alloc] init];
        self.items = [NSMutableArray array];
        [self.tableView addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _authSucceedCount = 0;
    _authFaileddCount = 0;
    [self addRightBarItem];
    self.title = _conversation.FName;
    self.isStop = YES;
    [self.view setBackgroundColor:[UIColor colorWithHex:0XF3F3F3]];
    [self.tableView setBackgroundColor:[UIColor colorWithHex:0XF3F3F3]];
    
    [self addRefreshHeader];
    if (_loadFtsRet) {
        [self addLoadMoreFooter];
    }
    [_panelManager addChatPanelWithSuperView:self.view];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(0);
        make.bottom.mas_equalTo(self.chatBar.mas_top).mas_equalTo(0);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.tableView addGestureRecognizer:tap];
    
    [self startLoadData];
    
    // 添加接收消息的监听
    [[PhotonMessageCenter sharedCenter] addObserver:self];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int i = 0;
        while (i < 1000) {
            [NSThread sleepForTimeInterval:2];
            i ++;
            NSLog(@"backGroup test %@",@(i));
        }
    });
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)addRightBarItem{
    UIImage *image = [[UIImage imageNamed:@"nav_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(more)];
    self.navigationItem.rightBarButtonItem = back;
}

- (void)more{
    PhotonWeakSelf(self)
    if (self.conversation.chatType == PhotonIMChatTypeSingle) {
        PhotonSingleSettingViewController *msgSetting = [[PhotonSingleSettingViewController alloc] initWithConversation:self.conversation compeltion:^(BOOL deleteMsg) {
            if (deleteMsg) {
                [weakself clearLoadData];
            }
            
        }];
        [self.navigationController pushViewController:msgSetting animated:YES];
    }else if (self.conversation.chatType == PhotonIMChatTypeGroup){
        PhotonGroupSettingViewController *msgSetting = [[PhotonGroupSettingViewController alloc] initWithGroupID:self.conversation compeltion:^(BOOL deleteMsg) {
            if (deleteMsg) {
                 [weakself clearLoadData];
            }
        }];
        [self.navigationController pushViewController:msgSetting animated:YES];
    }
   
}
- (void)tapGesture:(id)gesture{
     [_panelManager dismissKeyboard];
     [self.menuView dismiss];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.player play];
    [[PhotonIMClient sharedClient] keepConnectedOnBackground:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [_panelManager dismissKeyboard];
    self.isStop = YES;
   [self.player stop];
    [[PhotonIMClient sharedClient] keepConnectedOnBackground:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[PhotonAudioPlayer sharedAudioPlayer] stopPlayingAudio];
    
    //清空未读数
     [[PhotonMessageCenter sharedCenter] clearConversationUnReadCount:self.conversation];
}
// 加载数据
- (void)loadPreDataItems{
    [self p_loadDataItems:YES];
}

- (void)loadMoreDataItems{
    [self p_loadDataItems:NO];
}

- (void)p_loadDataItems:(BOOL)beforeAuthor{
    if (self.isLoading) {
        return;
    }
    PhotonWeakSelf(self);
    BOOL isEmpty = (self.model.items.count == 0);
    self.isLoading = YES;
    [(PhotonChatModel *)self.model loadMoreMeesages:self.conversation.chatType chatWith:self.conversation.chatWith beforeAuthor:beforeAuthor asc:YES finish:^(NSDictionary * _Nullable pa) {
        self.isLoading = NO;
        if (!isEmpty) {
            weakself.enableWithoutScrollToTop = YES;
        }else{
            weakself.enableWithoutScrollToTop = NO;
        }
        NSInteger result_count = [pa[@"result_count"] intValue];
        if (result_count == 0) {
            if (weakself.loadFtsRet) {
                [self endLoadMore];
                [self removeLoadMoreFooter];
            }
        }
        if(isEmpty){
            [weakself reloadData];
        }else{
             [weakself p_reloadData];
        }
       
    }];
}


- (void)p_reloadData{
    [self endRefreshing];
    if (_loadFtsRet) {
        [self endLoadMore];
    }
    PhotonChatDataSource *dataSource = [[PhotonChatDataSource alloc] initWithItems:self.model.items];
    dataSource.delegate = self;
    self.dataSource = dataSource;
}

- (void)clearLoadData{
    [self.model.items removeAllObjects];
    [self reloadData];
}
#pragma mark ----- getter --------
- (PhotonCharBar *)chatBar{
    return [_panelManager chatBar];
}

- (PhotonMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[PhotonMenuView alloc] init];
    }
    return _menuView;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self.tableView && [keyPath isEqualToString:@"bounds"]) {
        CGRect oldBounds, newBounds;
        [change[@"old"] getValue:&oldBounds];
        [change[@"new"] getValue:&newBounds];
        CGFloat t = oldBounds.size.height - newBounds.size.height;
        if (t > 0 && fabs(self.tableView.contentOffset.y + t + newBounds.size.height - self.tableView.contentSize.height) < 1.0) {
            [self scrollToBottomWithAnimation:NO];
        }
    }
}

#pragma mark ----- PhotonChatPanelDelegate -------
- (void)scrollToBottomWithAnimation:(BOOL)animation{
    PhotonWeakSelf(self);
    [PhotonUtil runMainThread:^{
        if (weakself.loadFtsRet && self.model.items.count <= self.model.pageSize) {
            NSIndexPath *indexPath = [(PhotonChatModel *)self.model getFtsSearchContentIndexpath];
            [weakself.tableView scrollToMiddleScroll:indexPath];
        }else{
            [weakself.tableView scrollToBottomWithAnimation:animation];
        }
        
    }];
    
}
#pragma mark --- 刷新数据 ------
- (void)refreshTableView{
    [UIView animateWithDuration:0 animations:^{
        [self p_reloadData];
    } completion:^(BOOL finished) {
        [self scrollToBottomWithAnimation:self.isFirstPage];
        self.isFirstPage = YES;
    }];
}


- (void)imClientLogin:(nonnull id)client loginStatus:(PhotonIMLoginStatus)loginstatus {
    BOOL change = NO;
    switch (loginstatus) {
        case PhotonIMLoginStatusLoginSucceed:
            self.authSucceedCount ++;
            change = YES;
            break;
        case PhotonIMLoginStatusLoginFailed:
            self.authFaileddCount ++;
            change = YES;
            break;
        case PhotonIMLoginStatusUnknow:
            self.authFaileddCount ++;
            change = YES;
            break;
                      
        default:
            break;
    }
    __weak typeof(self)weakself = self;
    [PhotonUtil runMainThread:^{
        if (change) {
            weakself.authFiled.text = [NSString stringWithFormat:@"authSucceedCount = %@ authFaileddCount =%@",@(weakself.authSucceedCount),@(weakself.authFaileddCount)];
        }
    }];
   
}


- (void)uigesture{
    [self.countFiled resignFirstResponder];
    [self.contentFiled resignFirstResponder];
    [self.intervalFiled resignFirstResponder];
}

- (void)keyboardWillShow{
    if (_loadFtsRet) {
        [self removeLoadMoreFooter];
        _loadFtsRet = NO;
        [(PhotonChatModel *)self.model resetFtsSearch];
        [self startLoadData];
    }
}


- (AVAudioPlayer *)player {
    if (!_player) {
        //后台播放音频设置
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"025b_525d_040c_51958d1f13e76f9787173fe94bdca8fc" withExtension:@"mp3"];
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        audioPlayer.numberOfLoops = -1;
        _player = audioPlayer;
    }
    return _player;
}

@end
#pragma clang diagnostic pop
