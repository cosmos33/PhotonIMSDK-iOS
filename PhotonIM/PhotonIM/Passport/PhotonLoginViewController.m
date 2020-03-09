//
//  PhotonLoginViewController.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/27.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonLoginViewController.h"
#import "PhotonAccountCell.h"
#import "PhotonAccountItem.h"
#import "PhotonAccountDataSource.h"
#import "PhotonRegisterViewController.h"
@interface PhotonLoginViewController ()<PhotonAccountCellDelegate,UIAlertViewDelegate>
@property (nonatomic, copy, nullable)void (^completion)(void);
@property (nonatomic, strong, nullable)PhotonAccountCell *tempCell;
@end

@implementation PhotonLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PhotonIMServerType serverType = [PhotonContent getServerSwitch];
    if (serverType == PhotonIMServerTypeInland) {
         self.title = @"登录国内环境";
    }else if(serverType == PhotonIMServerTypeOverseas){
        self.title = @"登录海外环境";
    }
    [self loadPreDataItems];
}

- (void)loadPreDataItems{
    PhotonAccountItem *item = [[PhotonAccountItem alloc] init];
    item.accountType = PhotonAccountTypeLogin;
    [self.items addObject:item];
    PhotonAccountDataSource *dataSource = [[PhotonAccountDataSource alloc] initWithItems:self.items];
    self.dataSource = dataSource;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[PhotonAccountCell class]]) {
        PhotonAccountCell *tempCell = (PhotonAccountCell *)cell;
        self.tempCell = tempCell;
        tempCell.delegate = self;
    }
}

- (void)loginAction:(PhotonAccountItem *)item{
    NSString *userid = item.userID;
    NSString *password = item.password;
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setValue:userid forKey:@"username"];
    [paramter setValue:password forKey:@"password"];
    __weak typeof(self)weakSelf = self;
    [PhotonUtil showLoading:@"正在登录中......"];
    self.tempCell.accountBtn.userInteractionEnabled = NO;
    [self.netService commonRequestMethod:PhotonRequestMethodPost queryString:@"photonimdemo/core/login/index" paramter:paramter completion:^(NSDictionary * _Nonnull dict) {
        [weakSelf wrapData:dict];
        weakSelf.tempCell.accountBtn.userInteractionEnabled = YES;
        [PhotonUtil hiddenLoading];
    } failure:^(PhotonErrorDescription * _Nonnull error) {
        PhotonLog(@"error = %@",error.errorMessage);
        weakSelf.tempCell.accountBtn.userInteractionEnabled = YES;
        [PhotonUtil showAlertWithTitle:@"登录失败" message:error.errorMessage];
        [PhotonUtil hiddenLoading];
    }];
}

- (void)setCompletionBlock:(void (^)(void))completionBlock{
    [super setCompletionBlock:completionBlock];
}

- (void)wrapData:(NSDictionary *)dict{
    [super wrapData:dict];
}
- (void)tipToRegister{
    PhotonRegisterViewController *regesterVCL = [[PhotonRegisterViewController alloc] init];
    [regesterVCL setCompletionBlock:self.completion];
    [self.navigationController pushViewController:regesterVCL animated:YES];
}

- (void)resignResponder{
    [self.tempCell resignFirst];
}

- (void)forbidUpload:(id)gesture{
    PhotonIMServerType serverType = [PhotonContent getServerSwitch];
    serverType = (serverType == PhotonIMServerTypeInland)?PhotonIMServerTypeOverseas:PhotonIMServerTypeInland;
    [PhotonContent setServerSwitch:serverType];
    NSString *title = (serverType == PhotonIMServerTypeInland)?@"国内服务":@"海外服务";
    self.title = [NSString stringWithFormat:@"登录%@",title];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"切换到" message:title delegate:self cancelButtonTitle:@"退出程序" otherButtonTitles:nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    exit(0);
}
    
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
