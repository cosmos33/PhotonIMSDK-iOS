//
//  PhotonAccountViewController.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/27.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonAccountViewController.h"
@interface PhotonAccountViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong, nullable)PhotonNetworkService *netService;
@property (nonatomic, strong, nullable)PhotonNetworkService *netService2;
@property (nonatomic, strong, nullable)UIImageView *iconView;
@end

@implementation PhotonAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture addTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tapGesture];
    
    [self.view addSubview:self.iconView];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 90));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(NavAndStatusHight);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(0);
        make.bottom.left.right.mas_equalTo(self.view).mas_equalTo(0);
    }];
}

-(void)setCompletionBlock:(void (^)(void))completionBlock{
    _completion = [completionBlock copy];
}
- (void)wrapData:(NSDictionary *)dict{
    PhotonLog(@"dict = %@",dict);
    if (dict.count == 0) {
        return;
    }
    __weak typeof(self)weakSelf = self;
    NSInteger code = [[dict objectForKey:@"ec"] integerValue];
    NSString *em = [dict objectForKey:@"em"];
    if (code == 0) {
        NSDictionary *data = [dict objectForKey:@"data"];
        if (data.count > 0) {
            NSString *name = [data objectForKey:@"username"];
            NSString *sessionid = [data objectForKey:@"sessionId"];
            NSString *userid = [data objectForKey:@"userId"];
            [PhotonContent currentUser].sessionID = [sessionid isNil];
            [PhotonContent currentUser].userID = [userid isNil];
            [PhotonContent currentUser].userName = [name isNil];
            if ([self isKindOfClass:NSClassFromString(@"PhotonRegisterViewController")]) {
                 [PhotonContent addFriendToDB:[PhotonContent currentUser]];
            }
            [[PhotonContent currentUser]loadFriendProfile];
            if (weakSelf.completion) {
                weakSelf.completion();
            }
        }
    }else{
        [PhotonUtil showAlertWithTitle:@"请求失败" message:em];
    }
}

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.backgroundColor = [UIColor clearColor];
        _iconView.userInteractionEnabled = NO;
        _iconView.image = [UIImage imageNamed:@"photon_icon"];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconView;
}

- (PhotonNetworkService *)netService{
    if (!_netService) {
        _netService = [[PhotonNetworkService alloc] init];
        _netService.baseUrl = PHOTON_BASE_URL;
        
    }
    return _netService;
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self resignResponder];
}

- (void)tapAction:(id)sender{
    [self resignResponder];
}

- (void)resignResponder{
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
