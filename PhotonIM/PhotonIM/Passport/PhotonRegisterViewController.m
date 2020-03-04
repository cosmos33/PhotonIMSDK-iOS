//
//  PhotonRegisterViewController.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/27.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonRegisterViewController.h"
#import "PhotonAccountCell.h"
#import "PhotonAccountItem.h"
#import "PhotonAccountDataSource.h"
@interface PhotonRegisterViewController ()<PhotonAccountCellDelegate>
@property (nonatomic, strong, nullable)PhotonAccountCell *tempCell;
@end

@implementation PhotonRegisterViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self loadPreDataItems];
}
- (void)loadPreDataItems{
    PhotonAccountItem *item = [[PhotonAccountItem alloc] init];
    item.accountType = PhotonAccountTypeRegister;
    [self.items addObject:item];
    PhotonAccountDataSource *dataSource = [[PhotonAccountDataSource alloc] initWithItems:self.items];
    self.dataSource = dataSource;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[PhotonAccountCell class]]) {
        PhotonAccountCell *tempCell = (PhotonAccountCell *)cell;
        _tempCell = tempCell;
        tempCell.delegate = self;
    }
}

- (void)registerAction:(PhotonAccountItem *)item{
    NSString *userid = item.userID;
    NSString *password = item.password;
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setValue:userid forKey:@"username"];
    [paramter setValue:password forKey:@"password"];
    __weak typeof(self)weakSelf = self;
    [self.netService commonRequestMethod:PhotonRequestMethodPost queryString:@"photonimdemo/core/register/index" paramter:paramter completion:^(NSDictionary * _Nonnull dict) {
        [weakSelf wrapData:dict];
    } failure:^(PhotonErrorDescription * _Nonnull error) {
        PhotonLog(@"error = %@",error.errorMessage);
        [PhotonUtil showAlertWithTitle:@"注册失败" message:error.errorMessage];
    }];
}

- (void)wrapData:(NSDictionary *)dict{
    [super wrapData:dict];
}

- (void)setCompletionBlock:(void (^)(void))completionBlock{
    [super setCompletionBlock:completionBlock];
}

- (void)resignResponder{
    [self.tempCell resignFirst];
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
