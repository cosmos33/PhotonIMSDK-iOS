//
//  PhotonChatSearchReultTableViewController.m
//  PhotonIM
//
//  Created by Bruce on 2020/1/10.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonChatSearchReultTableViewController.h"
#import "PhotonBaseViewController+Refresh.h"
#import "NSString+PhotonExtensions.h"
#import "PhotonConversationItem.h"
#import "PhotonConversationBaseCell.h"
#import "PhotonChatViewController.h"
@implementation PhotonChatSearchReultDataSource
- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object{
    if ([object isKindOfClass:[PhotonConversationItem class]]) {
        return [PhotonConversationBaseCell class];
    }
    return [super tableView:tableView cellClassForObject:object];
}
@end
@interface PhotonChatSearchReultTableViewController ()<UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSString *searchKeyword;
@property (nonatomic, assign) PhotonIMChatType chatType;
@property (nonatomic, copy) NSString *chatWith;
@property (nonatomic,copy, nullable) NSString *anchor;
@property (nonatomic,assign) int pageSize;
@property (nonatomic,assign) BOOL hasNext;
@end

@implementation PhotonChatSearchReultTableViewController
- (instancetype)initWithChatType:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith{
    self = [super init];
    if (self) {
        _chatType = chatType;
        _chatWith = chatWith;
        _anchor = @"";
        _pageSize = 20;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
   
    [self _initSubviews];
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}


- (void)_initSubviews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(25);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@50);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)searchContentWithQuery:(NSString *)query{
    if ([_searchKeyword isEqualToString:query]) {
        return;
    }
    _searchKeyword = query;
    _hasNext = YES;
    [self.items removeAllObjects];
    [self loadFirst];
}

- (void)loadFirst{
       NSArray<PhotonIMMessage *> *msgList = [[PhotonIMClient sharedClient] searchMessagesWithChatType:_chatType chatWith:_chatWith startIdentifier:@"<a>" andIdentifier:@"</a>" maxCharacterLenth:10 matchQuery:[NSString stringWithFormat:@"%@*",_searchKeyword] anchor:@"" pageSize:_pageSize];
      [self _reloadData:msgList];
}
- (void)loadMoreDataItems{
    if (!self.hasNext) {
        return;
    }
    NSArray<PhotonIMMessage *> *msgList = [[PhotonIMClient sharedClient] searchMessagesWithChatType:_chatType chatWith:_chatWith startIdentifier:@"<a>" andIdentifier:@"</a>" maxCharacterLenth:2 matchQuery:[NSString stringWithFormat:@"%@*",_searchKeyword] anchor:_anchor pageSize:_pageSize];
    [self _reloadData:msgList];
}

- (void)_reloadData:(NSArray<PhotonIMMessage *> *)msgList{
    PhotonIMMessage *lastMsg = msgList.lastObject;
    self.hasNext = msgList.count >= self.pageSize;
     _anchor = lastMsg.messageID?lastMsg.messageID:@"";
    if (self.hasNext) {
        [self addLoadMoreFooter];
    }else{
       [self removeLoadMoreFooter];
    }
    
    for (PhotonIMMessage *msg in msgList) {
        NSAttributedString *attrString = [msg.snippetContent toAttributedString];
        if (!attrString) {
            continue;
        }
        PhotonUser *user =  [PhotonContent friendDetailInfo:msg.fr];
        PhotonConversationItem *item = [[PhotonConversationItem alloc] init];
        PhotonIMConversation *conver = [[PhotonIMConversation alloc] initWithChatType:msg.chatType chatWith:msg.chatWith];
        conver.FAvatarPath = user.avatarURL;
        conver.lastTimeStamp = msg.timeStamp;
        conver.lastMsgId = [msg messageID];
        conver.FName = user.nickName?user.nickName:user.userName;
        item.snnipetContent = attrString;
        item.userInfo = conver;
        [self.items addObject:item];
    }
    PhotonChatSearchReultDataSource *dataSource = [[PhotonChatSearchReultDataSource alloc] initWithItems:self.items];
    self.dataSource = dataSource;
    [self endLoadMore];
}

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.showsCancelButton = YES;
        _searchBar.placeholder = @"搜索";
        [_searchBar becomeFirstResponder];
        _searchBar.backgroundColor = [UIColor whiteColor];
        _searchBar.returnKeyType = UIReturnKeyDone;
    }
    
    return _searchBar;
}

#pragma mark - KeyBoard

- (void)keyBoardWillShow:(NSNotification *)note
{
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘高度
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    void (^animation)(void) = ^void(void) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-keyBoardHeight);
        }];
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
}

- (void)keyBoardWillHide:(NSNotification *)note
{
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    void (^animation)(void) = ^void(void) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
         [self searchContentWithQuery:searchBar.text];
        [searchBar resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    [self searchContentWithQuery:searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self cancelSearch];

}

#pragma mark - public

- (void)cancelSearch
{
    self.navigationController.navigationBar.hidden = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton = NO;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.items.count <= indexPath.row) {
        return;
    }
    PhotonConversationItem *converItem = self.items[indexPath.row];
    if (!converItem.userInfo) {
        return;
    }
    PhotonChatViewController *chatVc = [[PhotonChatViewController alloc] initWithConversation:converItem.userInfo loadFtsResult:YES];
    [self.navigationController pushViewController:chatVc animated:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}
@end
