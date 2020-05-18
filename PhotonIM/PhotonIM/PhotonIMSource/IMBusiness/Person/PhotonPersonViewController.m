//
//  PhonePersonViewController.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/19.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonPersonViewController.h"
#import "PhotonPersonCell.h"
#import "PhotonEmptyTableItem.h"
#import "PhotonMessageSettingItem.h"
#import "PhotonMessageSettingCell.h"
#import "PhotonMessageCenter.h"
#import "PhotonSettingView.h"
#import "PAirSandbox.h"
@interface PhotonPersonDataSource ()
@end

@implementation PhotonPersonDataSource
- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object{
    if ([object isKindOfClass:[PhotonPersonItem class]]) {
        return [PhotonPersonCell class];
    }else if ([object isKindOfClass:[PhotonMessageSettingItem class]]) {
        return [PhotonMessageSettingCell class];
    }
    return [super tableView:tableView cellClassForObject:object];
}
@end
@interface PhotonPersonViewController()<PhotonPersonCellDelegate,PhotonMessageSettingCellDelegate,UIAlertViewDelegate>

@end
@implementation PhotonPersonViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.tabBarItem setTitle:@"我"];
        [self.tabBarItem setImage:[UIImage imageNamed:@"me"]];
        [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"me_onclick@"]];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    self.tabBarItem.tag = 3;
    [self.view setBackgroundColor:[UIColor colorWithHex:0xF3F3F3]];
    self.tableView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    self.tableView.scrollEnabled = NO;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self loadItems];
}

- (void)loadItems{
    [self.items removeAllObjects];
    PhotonUser *user = [PhotonContent userDetailInfo];
       PhotonPersonItem *personItem = [[PhotonPersonItem alloc] init];
       personItem.key = @"头像";
       personItem.value = user.avatarURL;
       personItem.shorArrow = YES;
       personItem.type = PhotonPersonItemTypeAvatar;
       
       PhotonPersonItem *personItem1 = [[PhotonPersonItem alloc] init];
       personItem1.key = @"账号";
       personItem1.value = user.userID;
       personItem1.type = PhotonPersonItemTypeAccount;
       
       PhotonPersonItem *personItem2 = [[PhotonPersonItem alloc] init];
       personItem2.key = @"昵称";
       personItem2.shorArrow = YES;
       personItem2.value = [user.nickName isNotEmpty]?user.nickName:@"未设置";
       personItem2.type = PhotonPersonItemTypeNick;
       personItem2.valueColor = [UIColor colorWithHex:0x5D5C6F];
    
       
        PhotonPersonItem *settingItem = [[PhotonPersonItem alloc] init];
        settingItem.key = @"拉取历史设置";
        settingItem.shorArrow = YES;
        settingItem.value = @"";
        settingItem.type = PhotonPersonItemTypeLoadHistorySetting;
        settingItem .valueColor = [UIColor colorWithHex:0x5D5C6F];
    
    
        PhotonPersonItem *documentItem = [[PhotonPersonItem alloc] init];
        documentItem.key = @"查看沙盒文件";
        documentItem.shorArrow = YES;
        documentItem.value = @"";
        documentItem.type = PhotonPersonItemTypeDocument;
        documentItem .valueColor = [UIColor colorWithHex:0x5D5C6F];
       
       
       
       PhotonPersonItem *personItem4 = [[PhotonPersonItem alloc] init];
       personItem4.type = PhotonPersonItemTypeBTN;
       
       
       PhotonEmptyTableItem *emptyitem = [[PhotonEmptyTableItem alloc] init];
       emptyitem.itemHeight = 11.5;
       [self.items addObject:emptyitem];
       
       [self.items addObject:personItem];
       [self.items addObject:personItem1];
       [self.items addObject:personItem2];
       [self.items addObject:settingItem];
       [self.items addObject:documentItem];
       
       [self.items addObject:emptyitem];
       
    
   

    NSString *name = @"国内服务";
    BOOL open = false;
    if([PhotonContent getServerSwitch] == PhotonIMServerTypeOverseas){
        name = @"海外服务";
        open = true;
    }
    
    PhotonMessageSettingItem *settionItem = [[PhotonMessageSettingItem alloc] init];
    settionItem.settingName = name;
     settionItem.open = open;
    settionItem.type = PhotonMessageSettingTypeDefault;
    [self.items addObject:emptyitem];
    [self.items addObject:settionItem];
    
    [self.items addObject:emptyitem];
    [self.items addObject:personItem4];
    
    PhotonPersonDataSource *dataSource = [[PhotonPersonDataSource alloc] initWithItems:self.items];
    self.dataSource = dataSource;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[PhotonPersonCell class]]) {
        PhotonPersonCell *tempCell = (PhotonPersonCell *)cell;
        tempCell.delegate = self;
    }else if ([cell isKindOfClass:[PhotonMessageSettingCell class]]) {
        PhotonMessageSettingCell *tempCell = (PhotonMessageSettingCell *)cell;
        tempCell.delegate = self;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = self.items[indexPath.row];
    if ([item isKindOfClass:[PhotonPersonItem class]]) {
        PhotonPersonItem *tempItem = (PhotonPersonItem *)item;
        switch (tempItem.type) {
            case PhotonPersonItemTypeNick:
                [self modifiedNickName];
                break;
            case PhotonPersonItemTypeLoadHistorySetting:{
                
                PhotonSettingView *view = [[PhotonSettingView alloc] initWithFrame:CGRectMake(50, 150, 300, 300)];
                [view showViewInSuperView:self.view];
            }
                break;

            case PhotonPersonItemTypeDocument:{
                [[PAirSandbox sharedInstance] showSandboxBrowser];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)modifiedNickName{
    UIAlertController *alertCv = [UIAlertController alertControllerWithTitle:@"设置昵称" message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
     PhotonUser *user = [PhotonContent userDetailInfo];
    [alertCv addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = user.nickName;
    }];
    __weak typeof(self)weakSelf = self;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *text = alertCv.textFields.firstObject.text;
        if (text && text.length > 0) {
            user.nickName = text;
            [[PhotonContent currentUser] modifiedName:text completion:^(BOOL success, BOOL open) {
                if(success){
                     [PhotonContent addFriendToDB:user];
                     [weakSelf loadItems];
                }
            }];
           
        }
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           
    }];
    [alertCv addAction:action1];
    [alertCv addAction:action2];
    [self presentViewController:alertCv animated:YES completion:nil];
}
- (void)logout:(id)cell{
    [[PhotonMessageCenter sharedCenter]  logout];
}

- (void)cell:(id)cell switchItem:(PhotonMessageSettingItem *)item{
    NSString *name = @"";
    if (item.type == PhotonMessageSettingTypeDefault) {
        PhotonMessageSettingCell *tempCell = (PhotonMessageSettingCell *)cell;
        if (item.open) {
            name = @"海外服务";
            
            [PhotonContent setServerSwitch:PhotonIMServerTypeOverseas];
        }else{
            name = @"国内服务";
            [PhotonContent setServerSwitch:PhotonIMServerTypeInland];
        }
        [PhotonContent autoLogout];
        tempCell.titleLabel.text = name;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"切换到" message:name delegate:self cancelButtonTitle:@"退出程序" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         exit(0);
    });
   
}

@end
