//
//  PhotonPhotoPreviewViewController.m
//  PhotonIM
//
//  Created by Bruce on 2020/2/11.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonPhotoPreviewViewController.h"
#import <Photos/Photos.h>
#import "UIImage+HXExtension.h"
#import "HXPhotoPreviewBottomView.h"
#import "UIButton+HXExtension.h"
#import "HXPhotoViewTransition.h"
#import "HXPhotoInteractiveTransition.h"
#import "HXPhotoViewPresentTransition.h"
#import "HXPhotoCustomNavigationBar.h"
#import "HXCircleProgressView.h"
#import "HXPhotoEditViewController.h"
#import "UIViewController+HXExtension.h"
#import "HXVideoEditViewController.h"
#import "HXPhotoPersentInteractiveTransition.h"

#import "UIImageView+HXExtension.h"
#import "Masonry/Masonry.h"
#import <PhotonIMSDK/PhotonIMSDK.h>
#import "PhotonUtil.h"
#import "PhotonMacros.h"
#import "UIButton+HXExtension.h"
@interface PhotonPhotoPreviewViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
HXPhotoPreviewBottomViewDelegate,
HXPhotoEditViewControllerDelegate,
HXVideoEditViewControllerDelegate
>
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) HXPhotoModel *currentModel;

@property (strong, nonatomic) HXPhotoPreviewViewCell *tempCell;

@property (assign, nonatomic) BOOL orientationDidChange;
@property (assign, nonatomic) BOOL firstChangeFrame;
@property (assign, nonatomic) NSInteger beforeOrientationIndex;
@property (strong, nonatomic) HXPhotoInteractiveTransition *interactiveTransition;
@property (strong, nonatomic) HXPhotoPersentInteractiveTransition *persentInteractiveTransition;


@property (assign, nonatomic) BOOL isAddInteractiveTransition;
@property (strong, nonatomic) UIView *dismissTempTopView;
@property (strong, nonatomic) UIPageControl *bottomPageControl;
@property (strong, nonatomic) UIButton *darkCancelBtn;
@property (strong, nonatomic) UIButton *sharedBtn;
@property (strong, nonatomic) UIButton *viewOrigindBtn;
@property (strong, nonatomic) UIView *topView;

@property (strong, nonatomic) UIButton *downloadBtn;
@property (strong, nonatomic) UIView *btnView;
@property (assign, nonatomic) BOOL statusBarShouldBeHidden;
@property (assign, nonatomic) BOOL layoutSubviewsCompletion;
@property (strong, nonatomic) HXHUD *loadingView;
@end

@implementation PhotonPhotoPreviewViewController
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
            [self changeStatusBarStyle];
            [self setNeedsStatusBarAppearanceUpdate];
            [self.collectionView reloadData];
        }
    }
#endif
}
#pragma mark - < transition delegate >
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        if (![toVC isKindOfClass:[self class]]) {
            return nil;
        }
        return [HXPhotoViewTransition transitionWithType:HXPhotoViewTransitionTypePush];
    }else {
        if (![fromVC isKindOfClass:[self class]]) {
            return nil;
        }
        return [HXPhotoViewTransition transitionWithType:HXPhotoViewTransitionTypePop];
    }
}
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    return self.interactiveTransition.interation ? self.interactiveTransition : nil;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [HXPhotoViewPresentTransition transitionWithTransitionType:HXPhotoViewPresentTransitionTypePresent photoView:self.photoView];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [HXPhotoViewPresentTransition transitionWithTransitionType:HXPhotoViewPresentTransitionTypeDismiss photoView:self.photoView];
}
-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.persentInteractiveTransition.interation ? self.persentInteractiveTransition : nil;
}
#pragma mark - < life cycle >
- (instancetype)init {
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}
- (void)dealloc {
    if (self.photoViewController && HX_IOS9Earlier) {
        // 处理ios8 导航栏转场动画崩溃问题
        self.photoViewController.navigationController.delegate = nil;
    }
    if (_collectionView) {
        HXPhotoPreviewViewCell *cell = (HXPhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
        [cell cancelRequest];
    }
    if ([UIApplication sharedApplication].statusBarHidden) {
        [self changeStatusBarWithHidden:NO];
        [self.navigationController setNavigationBarHidden:NO animated:NO];

        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    if (HXShowLog) NSSLog(@"dealloc");
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    if ([HXPhotoCommon photoCommon].isDark) {
        return UIStatusBarStyleLightContent;
    }
    return self.manager.configuration.statusBarStyle;
}
- (BOOL)prefersStatusBarHidden {
    if (!self) {
        return [super prefersStatusBarHidden];
    }
    return self.statusBarShouldBeHidden;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!CGRectEqualToRect(self.view.frame, [UIScreen mainScreen].bounds)) {
        self.view.frame = [UIScreen mainScreen].bounds;
    }
    if (self.orientationDidChange || self.firstChangeFrame) {
        [self changeSubviewFrame];
        self.orientationDidChange = NO;
        self.firstChangeFrame = NO;
    }
    self.layoutSubviewsCompletion = YES;
}
- (void)changeStatusBarStyle {
    if ([HXPhotoCommon photoCommon].isDark) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        return;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:self.manager.configuration.statusBarStyle];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeStatusBarStyle];
    [self changeStatusBarWithHidden:YES];
    if (![UIApplication sharedApplication].statusBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    HXPhotoModel *model = self.modelArray[self.currentModelIndex];
    self.currentModel = model;
    HXPhotoPreviewViewCell *cell = (HXPhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
    if (!cell) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            HXPhotoPreviewViewCell *tempCell = (HXPhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
            self.tempCell = tempCell;
            [tempCell requestHDImage];
        });
    }else {
        self.tempCell = cell;
        [cell requestHDImage];
    }
    if (!self.isAddInteractiveTransition) {
        if (!self.outside) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //初始化手势过渡的代理
                self.interactiveTransition = [[HXPhotoInteractiveTransition alloc] init];
                //给当前控制器的视图添加手势
                [self.interactiveTransition addPanGestureForViewController:self];
            });
        }else if (!self.disableaPersentInteractiveTransition) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //初始化手势过渡的代理
                self.persentInteractiveTransition = [[HXPhotoPersentInteractiveTransition alloc] init];
                //给当前控制器的视图添加手势
                [self.persentInteractiveTransition addPanGestureForViewController:self photoView:self.photoView];
            });
        }
        self.isAddInteractiveTransition = YES;
    }
    [self showViewOriginBtn:model];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([UIApplication sharedApplication].statusBarHidden) {
               [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
           }
    [self changeStatusBarWithHidden:NO];
    HXPhotoPreviewViewCell *cell = (HXPhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
    cell.stopCancel = self.stopCancel;
    [cell cancelRequest];
    self.stopCancel = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationWillChanged:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    HXPhotoModel *model = self.modelArray[self.currentModelIndex];
    if (model.subType == HXPhotoModelMediaSubTypeVideo) {// 视频
           [self showBtnView:NO];
       }else {// 图片
           [self showBtnView:YES];
       }
    [self addGesture];
}
#pragma mark - < private >
- (void)setExteriorPreviewStyle:(HXPhotoViewPreViewShowStyle)exteriorPreviewStyle {
    _exteriorPreviewStyle = exteriorPreviewStyle;
    if (exteriorPreviewStyle == HXPhotoViewPreViewShowStyleDark) {
        self.statusBarShouldBeHidden = YES;
    }
}
- (void)addGesture {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToLongPress:)];
    [self.view addGestureRecognizer:longPress];
}
- (void)respondsToLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
       // 长按时间
    }
}
- (void)deviceOrientationChanged:(NSNotification *)notify {
    self.orientationDidChange = YES;
}
- (void)deviceOrientationWillChanged:(NSNotification *)notify {
    self.beforeOrientationIndex = self.currentModelIndex;
}
- (void)changeSubviewFrame {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationPortrait == UIInterfaceOrientationPortraitUpsideDown) {
        [self changeStatusBarWithHidden:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }else if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft){
        [self changeStatusBarWithHidden:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
    CGFloat bottomMargin = hxBottomMargin;
    CGFloat width = self.view.hx_w;
    CGFloat itemMargin = 20;
    if (HX_IS_IPhoneX_All && (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)) {
        bottomMargin = 21;
    }
    
    self.flowLayout.itemSize = CGSizeMake(width, self.view.hx_h);
    self.flowLayout.minimumLineSpacing = itemMargin;
    [self.collectionView setCollectionViewLayout:self.flowLayout];
    
    self.collectionView.frame = CGRectMake(-(itemMargin / 2), 0,self.view.hx_w + itemMargin, self.view.hx_h);
    self.collectionView.contentSize = CGSizeMake(self.modelArray.count * (self.view.hx_w + itemMargin), 0);
    
    
    [self.collectionView setContentOffset:CGPointMake(self.beforeOrientationIndex * (self.view.hx_w + itemMargin), 0)];
    if (self.orientationDidChange) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            HXPhotoPreviewViewCell *cell = [self currentPreviewCellWithIndex:self.currentModelIndex];
            [UIView animateWithDuration:0.25 animations:^{
                [cell refreshImageSize];
            }];
        });
    }

    self.bottomPageControl.frame = CGRectMake(0, self.view.hx_h - 30, self.view.hx_w, 10);
    
    self.navigationController.navigationBar.translucent = self.manager.configuration.navBarTranslucent;
    if (!self.outside) {
        if (self.manager.configuration.navigationBar) {
            self.manager.configuration.navigationBar(self.navigationController.navigationBar, self);
        }
    }
}
- (void)setupUI {
    [self.view addSubview:self.collectionView];
    self.beforeOrientationIndex = self.currentModelIndex;
    HXPhotoModel *model = self.modelArray[self.currentModelIndex];
    self.currentModel = model;
    
    [self.topView addSubview:self.darkCancelBtn];
    [self.topView addSubview:self.sharedBtn];
    [self.view addSubview:self.topView];
   
   
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(64);
        make.left.right.mas_equalTo(0);
    }];
    
    [self.darkCancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(10);
    }];
    
    [self.sharedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-10);
    }];
    
    [self.btnView addSubview:self.downloadBtn];
    [self.btnView addSubview:self.viewOrigindBtn];
    [self.view addSubview:self.btnView];
    
    [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-SAFEAREA_INSETS_BOTTOM);
        make.height.mas_equalTo(44);
        make.left.right.mas_equalTo(0);
    }];
    
    [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.mas_equalTo(2);
        make.right.mas_equalTo(-10);
    }];
    
    
    [self.viewOrigindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.size.mas_equalTo(CGSizeMake(150, 30));
           make.top.mas_equalTo(2);
           make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
   if ([self.manager.afterSelectedArray containsObject:model]) {
        self.bottomPageControl.currentPage = [[self.manager afterSelectedArray] indexOfObject:model];
    }
    if (self.manager.afterSelectedCount <= 15) {
        [self.view addSubview:self.bottomPageControl];
    }
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor blackColor];
    self.firstChangeFrame = YES;
}

- (void)dismissClick {
    self.manager.selectPhotoing = NO;
    if ([self.delegate respondsToSelector:@selector(photoPreviewControllerDidCancel:model:)]) {
        HXPhotoModel *model;
        if (self.modelArray.count) {
            model = self.modelArray[self.currentModelIndex];
        }
        [self.delegate photoPreviewControllerDidCancel:self model:model];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)downloadClick:(UIButton *)sender{
    if (self.modelArray.count <= 0) {
        return;
    }
    HXPhotoModel *model = self.modelArray[self.currentModelIndex];
    if (!model) {
        return;
    }
     [self.view hx_immediatelyShowLoadingHudWithText:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadImage:completion:)]) {
        __weak typeof(self)weakSelf = self;
        [self.delegate downloadImage:model completion:^(UIImage * _Nonnull image) {
            [PhotonUtil runMainThread:^{
                [weakSelf.view hx_handleLoading:NO];
                [weakSelf saveMessage:image];
                
            }];
           
        }];
    }
}
- (void)saveMessage:(UIImage *)image{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
     //写入图片到相册
     [PHAssetChangeRequest creationRequestForAssetFromImage:image];
     } completionHandler:^(BOOL success, NSError * _Nullable error) {
         if(success){
             [PhotonUtil showSuccessHint:@"图片已存储到相册"];
         }else{
             [PhotonUtil showSuccessHint:@"图片存储到相册失败"];
         }
    }];
}
- (void)viewOriginClick:(UIButton *)sender{
    if (self.modelArray.count <= 0) {
        return;
    }
    HXPhotoModel *model = self.modelArray[self.currentModelIndex];
    if (!model) {
        return;
    }
    __weak typeof(self)weakSelf = self;
    HXPhotoPreviewViewCell *cell = (HXPhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
   [self.view hx_immediatelyShowLoadingHudWithText:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewOriginImage:completion:)]) {
        [self.delegate viewOriginImage:model completion:^(UIImage * _Nonnull image) {
            [PhotonUtil runMainThread:^{
                if (cell){
                    if (image) {
                        [weakSelf.view hx_handleLoading:NO];
                        model.cameraPhotoType = HXPhotoModelMediaTypeCameraPhotoTypeLocal;
                        [weakSelf showViewOriginBtn:model];
                        [cell setImage:image];
                    }else{
                        [weakSelf.view hx_handleLoading:NO];
                    }
                   
                }
            }];

        }];
    }
}

- (void)didSharedClick:(UIButton *)button {
    if (self.modelArray.count <= 0) {
        return;
    }
    HXPhotoModel *model = self.modelArray[self.currentModelIndex];
    if (!model) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(share:)]) {
        [self dismissClick];
        [self.delegate share:model];
    }
    
}
#pragma mark - < public >
- (HXPhotoPreviewViewCell *)currentPreviewCellWithIndex:(NSInteger)index {
    if (index < 0) {
        index = 0;
    }
    if (index > self.modelArray.count - 1) {
        index = self.modelArray.count - 1;
    }
    return (HXPhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}
- (HXPhotoPreviewViewCell *)currentPreviewCell:(HXPhotoModel *)model {
    if (!model) {
        return nil;
    }
    return (HXPhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
}
- (void)changeStatusBarWithHidden:(BOOL)hidden {
    self.statusBarShouldBeHidden = hidden;
    [self preferredStatusBarUpdateAnimation];
}
- (void)setSubviewAlphaAnimate:(BOOL)animete {
    [self setSubviewAlphaAnimate:animete duration:0.15];
}
- (void)setupDarkBtnAlpha:(CGFloat)alpha {
    self.bottomPageControl.alpha = alpha;
}

#pragma mark - < UICollectionViewDataSource >
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.modelArray count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HXPhotoModel *model = self.modelArray[indexPath.item];
    HXPhotoPreviewViewCell *cell;
    if (model.subType == HXPhotoModelMediaSubTypePhoto) {
        if (model.type == HXPhotoModelMediaTypeLivePhoto) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HXPhotoPreviewLivePhotoCell" forIndexPath:indexPath];
        }else {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HXPhotoPreviewImageViewCell" forIndexPath:indexPath];
        }
    }else if (model.subType == HXPhotoModelMediaSubTypeVideo) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HXPhotoPreviewVideoViewCell" forIndexPath:indexPath];
    }
    HXWeakSelf
    cell.scrollViewDidScroll = ^(CGFloat offsetY) {
        if (weakSelf.currentCellScrollViewDidScroll) {
            weakSelf.currentCellScrollViewDidScroll(offsetY);
        }
    };
    [cell setCellDidPlayVideoBtn:^(BOOL play) {
        if (weakSelf.exteriorPreviewStyle == HXPhotoViewPreViewShowStyleDark) {
            return;
        }
    }];
    [cell setCellDownloadICloudAssetComplete:^(HXPhotoPreviewViewCell *myCell) {
        if ([weakSelf.delegate respondsToSelector:@selector(photoPreviewDownLoadICloudAssetComplete:model:)]) {
            [weakSelf.delegate photoPreviewDownLoadICloudAssetComplete:weakSelf model:myCell.model];
        }
    }];
    cell.cellDownloadImageComplete = ^(HXPhotoPreviewViewCell *myCell) {
        if ([weakSelf.delegate respondsToSelector:@selector(photoPreviewCellDownloadImageComplete:model:)]) {
            [weakSelf.delegate photoPreviewCellDownloadImageComplete:weakSelf model:myCell.model];
        }
    };
    [cell setCellTapClick:^(HXPhotoModel *model, HXPhotoPreviewViewCell *myCell) {
        if (model.subType == HXPhotoModelMediaSubTypeVideo) {
                       HXPhotoPreviewVideoViewCell *videoCell = (HXPhotoPreviewVideoViewCell *)myCell;
                       BOOL hidden = YES;
                       if (videoCell.bottomSliderView.hidden || videoCell.bottomSliderView.alpha == 0) {
                           hidden = NO;
                       }
                       [weakSelf setCurrentCellBottomSliderViewHidden:hidden animation:YES];
                   }else {
                       [weakSelf dismissClick];
                   }
    }];
    cell.model = model;
    return cell;
}

- (void)setCurrentCellBottomSliderViewHidden:(BOOL)hidden animation:(BOOL)animation {
    HXPhotoPreviewVideoViewCell *cell = (HXPhotoPreviewVideoViewCell *)[self currentPreviewCell:self.currentModel];
    if (cell.bottomSliderView.hidden == hidden && cell.bottomSliderView.alpha == !hidden) {
        return;
    }
    if (animation) {
        if (!hidden) {
            if (cell.previewContentView.videoView.playBtnDidPlay) {
                cell.bottomSliderView.hidden = hidden;
            }
        }
        [UIView animateWithDuration:0.25 animations:^{
            if (cell.previewContentView.videoView.playBtnDidPlay) {
                cell.bottomSliderView.alpha = !hidden;
            }
        } completion:^(BOOL finished) {
            if (cell.previewContentView.videoView.playBtnDidPlay) {
                cell.bottomSliderView.hidden = hidden;
            }
        }];
    }else {
        if (cell.previewContentView.videoView.playBtnDidPlay) {
            cell.bottomSliderView.hidden = hidden;
            cell.bottomSliderView.alpha = !hidden;
        }
    }
}

#pragma mark - < UICollectionViewDelegate >
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    self.persentInteractiveTransition.atFirstPan = NO;
    self.interactiveTransition.atFirstPan = NO;
    [(HXPhotoPreviewViewCell *)cell resetScale:NO];
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    HXPhotoPreviewViewCell *myCell = (HXPhotoPreviewViewCell *)cell;
    [myCell cancelRequest];
}
- (void)scrollDidScrollHiddenBottomSliderViewWithOffsetX:(CGFloat)offsetx nextModel:(HXPhotoModel *)nextModel {
    if (self.currentModel.subType == HXPhotoModelMediaSubTypeVideo) {
            HXPhotoPreviewVideoViewCell *cell = (HXPhotoPreviewVideoViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[self.modelArray indexOfObject:self.currentModel] inSection:0]];
        float difference = fabs(offsetx - self.currentModel.previewContentOffsetX);
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        if (difference > width) {
            difference = width;
        }
        cell.bottomSliderView.alpha = self.darkCancelBtn.alpha;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.collectionView) {
        return;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat offsetx = self.collectionView.contentOffset.x;
    NSInteger currentIndex = (offsetx + (width + 20) * 0.5) / (width + 20);
    if (currentIndex > self.modelArray.count - 1) {
        currentIndex = self.modelArray.count - 1;
    }
    if (currentIndex < 0) {
        currentIndex = 0;
    }
    if (self.modelArray.count > 0) {
        self.bottomPageControl.currentPage = currentIndex;
        HXPhotoModel *model = self.modelArray[currentIndex];
        if (model.subType == HXPhotoModelMediaSubTypeVideo) {// 视频
            [self showBtnView:NO];
        }else {// 图片
            [self showBtnView:YES];
        }
    }
    self.currentModelIndex = currentIndex;
    if (currentIndex > 0 && currentIndex < self.modelArray.count) {
        HXPhotoModel *nextModel;
        if (self.currentModel.previewContentOffsetX > offsetx) {
            NSInteger index = [self.modelArray indexOfObject:self.currentModel] - 1;
            if (index > 0 && index < self.modelArray.count) {
                nextModel = self.modelArray[index];
            }
        }else {
            NSInteger index = [self.modelArray indexOfObject:self.currentModel] + 1;
            if (index > 0 && index < self.modelArray.count) {
                nextModel = self.modelArray[index];
            }
        }
        if (nextModel && !self.orientationDidChange) {
            [self scrollDidScrollHiddenBottomSliderViewWithOffsetX:offsetx nextModel:nextModel];
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.modelArray.count > 0) {
        HXPhotoPreviewViewCell *cell = (HXPhotoPreviewViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentModelIndex inSection:0]];
        HXPhotoModel *model = self.modelArray[self.currentModelIndex];
        model.previewContentOffsetX = scrollView.contentOffset.x;
        self.currentModel = model;
        [self showViewOriginBtn:model];
        [cell requestHDImage];
    }
}
#pragma mark - < 懒加载 >
- (UIPageControl *)bottomPageControl {
    if (!_bottomPageControl) {
        _bottomPageControl = [[UIPageControl alloc] init];
        _bottomPageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _bottomPageControl.pageIndicatorTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        _bottomPageControl.numberOfPages = self.modelArray.count;
    }
    return _bottomPageControl;
}
- (void)setPreviewShowPageControl:(BOOL)previewShowPageControl{
    self.bottomPageControl.hidden = !previewShowPageControl;
}
- (UIView *)dismissTempTopView {
    if (!_dismissTempTopView) {
        _dismissTempTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.hx_w, hxNavigationBarHeight)];
        _dismissTempTopView.backgroundColor = [UIColor blackColor];
    }
    return _dismissTempTopView;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    }
    return _topView;
}

- (UIView *)btnView{
    if (!_btnView) {
           _btnView = [[UIView alloc] init];
           _btnView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
       }
       return _btnView;
}
- (UIButton *)sharedBtn {
    if (!_sharedBtn) {
        _sharedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sharedBtn setBackgroundImage:[UIImage hx_imageNamed:@"share"] forState:UIControlStateNormal];
        [_sharedBtn addTarget:self action:@selector(didSharedClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sharedBtn;
}
- (UIButton *)darkCancelBtn {
    if (!_darkCancelBtn) {
        _darkCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_darkCancelBtn setBackgroundImage:[UIImage hx_imageNamed:@"hx_faceu_cancel"] forState:UIControlStateNormal];
        [_darkCancelBtn addTarget:self action:@selector(dismissClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _darkCancelBtn;
}
- (UIButton *)downloadBtn{
    if (!_downloadBtn) {
        _downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downloadBtn setBackgroundImage:[UIImage hx_imageNamed:@"download"] forState:UIControlStateNormal];
        [_downloadBtn addTarget:self action:@selector(downloadClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadBtn;
}
- (UIButton *)viewOrigindBtn{
    if (!_viewOrigindBtn) {
        _viewOrigindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _viewOrigindBtn.hidden = YES;
        _viewOrigindBtn.clipsToBounds = YES;
        _viewOrigindBtn.backgroundColor = [UIColor clearColor];
        _viewOrigindBtn.layer.cornerRadius = 5;
        [_viewOrigindBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        _viewOrigindBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
        _viewOrigindBtn.layer.borderWidth = 1.0/[UIScreen mainScreen].scale;
        [_viewOrigindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_viewOrigindBtn addTarget:self action:@selector(viewOriginClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewOrigindBtn;
}

- (void)showViewOriginBtn:(HXPhotoModel *)model{
    if(model){
        if(model.cameraPhotoType == HXPhotoModelMediaTypeCameraPhotoTypeLocal){
            self.viewOrigindBtn.hidden = YES;
        }else{
            self.viewOrigindBtn.hidden = NO;
        }
        PhotonIMMessage *message = model.userInfo;
        if (message && [message isKindOfClass:[PhotonIMMessage class]]) {
            NSInteger fileSize = (NSInteger)[message messageBody].fileSize;
            float size = fileSize/1024.0;
            if(size > 0){
                [self.viewOrigindBtn setTitle:[NSString stringWithFormat:@"查看原图(%.2lf k)",size] forState:UIControlStateNormal];
            }else{
                [self.viewOrigindBtn setTitle:[NSString stringWithFormat:@"查看原图"] forState:UIControlStateNormal];
            }
        }
    }
}
- (void)showBtnView:(BOOL)show{
    [UIView animateWithDuration:0.3 animations:^{
        self.btnView.alpha = show;
    }];
}
- (HXPhotoPreviewBottomView *)bottomView{
    if (_bottomView) {
        _bottomView = [[HXPhotoPreviewBottomView alloc] init];
    }
    return _bottomView;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0,self.view.hx_w + 20, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:self.flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[HXPhotoPreviewImageViewCell class] forCellWithReuseIdentifier:@"HXPhotoPreviewImageViewCell"];
        [_collectionView registerClass:[HXPhotoPreviewLivePhotoCell class] forCellWithReuseIdentifier:@"HXPhotoPreviewLivePhotoCell"];
        [_collectionView registerClass:[HXPhotoPreviewVideoViewCell class] forCellWithReuseIdentifier:@"HXPhotoPreviewVideoViewCell"];
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#else
            if ((NO)) {
#endif
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.minimumInteritemSpacing = 0;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    if (self.outside) {
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }else {
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
#else
            if ((NO)) {
#endif
                _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
            }else {
                _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
            }
        }
    }
    return _flowLayout;
}
- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (HXHUD *)loadingView {
    if (!_loadingView) {
        _loadingView = [[HXHUD alloc] initWithFrame:CGRectMake(0, 0, 95, 95) imageName:nil text:nil];
        [_loadingView showloading];
    }
    return _loadingView;
}

-(void)showLoadingView{
    [self.view addSubview:self.loadingView];
    self.loadingView.center = self.view.center;
}
- (void)hiddenLoadingView{
    [self.loadingView removeFromSuperview];
}

@end
