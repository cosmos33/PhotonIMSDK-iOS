//
//  PhotonBaseChatCell.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/21.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonChatBaseCell.h"
#import "PhotonMessageCenter.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "PhotonCircleProgressView.h"
#import "PhotonCircleLoadingView.h"
@interface PhotonChatBaseCell()
/**
 头像
 */
@property (nonatomic, strong, nullable)UIButton *avatarBtn;

/**
 发送状态显示，失败显示，成功不显示
 */
@property (nonatomic, strong, nullable)UIButton *sendStateBtn;

/**
 时间
 */
@property (nonatomic, strong, nullable)UILabel  *timeLabel;

/**
 系统提示
 */
@property (nonatomic, strong, nullable)UILabel  *tipLable;

/**
 已读显示
 */
@property (nonatomic, strong, nullable)UILabel  *msgStatusLable;

/**
 文字背景
 */
@property (nonatomic, strong, nullable)UIImageView *contentBackgroundView;

@property (nonatomic, strong, nullable)UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong, nullable)UIView *maskView;

@property (nonatomic, strong, nullable)PhotonCircleProgressView *progressView;

@property (nonatomic, strong, nullable)PhotonCircleLoadingView *loadingView;
@end

@implementation PhotonChatBaseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHex:0XF3F3F3];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.avatarBtn];
        [self.contentView addSubview:self.sendStateBtn];
        [self.contentView addSubview:self.contentBackgroundView];
        [self.contentView addSubview:self.tipLable];
        [self.contentView addSubview:self.msgStatusLable];
        [self.contentView addSubview:self.timeLabel];
        
        [self.contentBackgroundView addSubview:self.maskView];
        [self.maskView addSubview:self.progressView];
        
    }
    return self;
}


- (void)setObject:(id)object{
    [super setObject:object];
    PhotonChatBaseItem *item = (PhotonChatBaseItem *)object;
    
    self.lineLayer.hidden = YES;
    if (item.fromType == PhotonChatMessageFromSelf) {
        [self.contentBackgroundView setBackgroundColor:[UIColor colorWithHex:0x3D82FF]];
    }
    else if (item.fromType== PhotonChatMessageFromFriend){
         [self.contentBackgroundView setBackgroundColor:[UIColor colorWithHex:0xFFFFFF]];
    }
    
    [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:item.avatalarImgaeURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"tabbar_meHL"]];
    
    if (item.showTime) {
        [self.timeLabel setText:item.timeText];
    }else{
        [self.timeLabel setText:nil];
    }
    
    PhotonIMMessage *message = [item userInfo];
    if (item.fromType == PhotonChatMessageFromSelf)
    {
        // 发送中转小菊花
        if (message.messageStatus == PhotonIMMessageStatusSending){
            [self.contentView addSubview:self.indicatorView];
            self.indicatorView.hidden = NO;
            [self.indicatorView startAnimating];
        }else{
            self.indicatorView.hidden = YES;
        }
        
        // 发送失败显示小红叹号
        if (message.messageStatus == PhotonIMMessageStatusFailed ) {
            self.sendStateBtn.hidden = NO;
            [self.sendStateBtn setImage:[UIImage imageNamed:@"send_error"] forState:UIControlStateNormal];
        }else{
             self.sendStateBtn.hidden = YES;
        }
        
        
        NSString *readStateText = @"";
        if(message.messageStatus == PhotonIMMessageStatusSucceed && message.chatType == PhotonIMChatTypeSingle){
            readStateText = @"已发送";
        }
        if(message.messageStatus == PhotonIMMessageStatusSentRead && message.chatType == PhotonIMChatTypeSingle){
            readStateText = @"已读";
        }
        self.msgStatusLable.text = readStateText;

        if ([item.tipText isNotEmpty]) {
            self.tipLable.text = item.tipText;
        }
    }else if(item.fromType == PhotonChatMessageFromFriend){
        self.indicatorView.hidden = YES;
        self.sendStateBtn.hidden = YES;

        
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];

    PhotonChatBaseItem *item = (PhotonChatBaseItem *)self.item;
    CGFloat contentViewWidth = self.contentView.width;

    
    CGFloat timeLabelHeight = item.showTime ? TIMELABEL_HEIGHT : 0;
    CGFloat timeLabelWidth = item.showTime ? 200 : 0;
    CGFloat timeLabelTop = item.showTime ? TIMELABEL_SPACE_Y : 0;
    CGFloat timeLabelLeft = (contentViewWidth - timeLabelWidth)/2.0;
    CGRect timeLabelFrame = CGRectMake(timeLabelLeft, timeLabelTop, timeLabelWidth, timeLabelHeight);
    self.timeLabel.frame = timeLabelFrame;
    

    
    CGFloat avatarBtnHeight = AVATAR_WIDTH;
    CGFloat avatarBtnWidth = AVATAR_WIDTH;
    CGFloat avatarBtnTop = timeLabelTop + timeLabelHeight + AVATAR_SPACE_Y;
    CGFloat avatarBtnLeft = (item.fromType == PhotonChatMessageFromSelf)?(contentViewWidth-avatarBtnWidth-AVATAR_SPACE_X):AVATAR_SPACE_X;
    CGRect avatarBtnFrame = CGRectMake(avatarBtnLeft, avatarBtnTop, avatarBtnWidth, avatarBtnHeight);
    self.avatarBtn.frame = avatarBtnFrame;
    
    
    CGFloat contentBackgroundViewHeight = 0;
    CGFloat contentBackgroundViewWidth = 0;
    CGFloat contentBackgroundViewTop = avatarBtnTop;
    CGFloat contentBackgroundViewLeft = (item.fromType == PhotonChatMessageFromSelf)?(contentViewWidth-contentBackgroundViewWidth - avatarBtnWidth -MSGBG_SPACE_X):MSGBG_SPACE_X + avatarBtnWidth;
    if (item.fromType == PhotonChatMessageFromSelf) {
        contentBackgroundViewLeft = contentViewWidth-contentBackgroundViewWidth - avatarBtnWidth -MSGBG_SPACE_X - AVATAR_SPACE_X;
    }else{
        contentBackgroundViewLeft = MSGBG_SPACE_X + avatarBtnLeft + avatarBtnWidth;
    }
    CGRect contentBackgroundViewFrame = CGRectMake(contentBackgroundViewLeft, contentBackgroundViewTop, contentBackgroundViewWidth, contentBackgroundViewHeight);
    self.contentBackgroundView.frame = contentBackgroundViewFrame;
    
  
}

- (void)subview_layout{
    PhotonChatBaseItem *item = (PhotonChatBaseItem *)self.item;
    CGRect contentViewfFrame = self.contentBackgroundView.frame;
    if (item.fromType == PhotonChatMessageFromSelf)
    {
        // 发送中转小菊花
        if (!self.indicatorView.hidden){
            CGFloat messageStatusHeight  = 20;
            CGFloat messageStatusWidth = 20;
            CGFloat messageStatusTop = self.contentBackgroundView.center.y - (10.0);
            CGFloat messageStatusLeft = contentViewfFrame.origin.x - 5 - 20;
            CGRect messageStatusFrame = CGRectMake(messageStatusLeft, messageStatusTop, messageStatusWidth, messageStatusHeight);
            self.indicatorView.frame = messageStatusFrame;
           
        }else{
             self.indicatorView.frame = CGRectZero;
        }
        
        // 发送失败显示小红叹号
        if (!self.sendStateBtn.hidden) {
            CGFloat sendStateBtnHeight  = 21;
            CGFloat sendStateBtnWidth = 21;
            CGFloat sendStateBtnTop = self.contentBackgroundView.center.y - (10.5);
            CGFloat sendStateBtnLeft = contentViewfFrame.origin.x - 6 - 21;
            CGRect sendStateBtnFrame = CGRectMake(sendStateBtnLeft, sendStateBtnTop, sendStateBtnWidth, sendStateBtnHeight);
            self.sendStateBtn.frame = sendStateBtnFrame;
        }else{
            self.sendStateBtn.frame = CGRectZero;
        }
        
        
        // 已发送显示已发送文案
        NSInteger msgStatusLableCount = self.msgStatusLable.text.length;
        if (msgStatusLableCount) {
            // 背景
            CGFloat msgStatusLableHeight  = 20;
            CGFloat msgStatusLableWidth = 12*msgStatusLableCount + 5;
            CGFloat msgStatusLableTop = contentViewfFrame.origin.y + contentViewfFrame.size.height - msgStatusLableHeight;
            CGFloat msgStatusLableLeft = contentViewfFrame.origin.x - 5.5 - msgStatusLableWidth;
            CGRect msgStatusLableFrame = CGRectMake(msgStatusLableLeft, msgStatusLableTop, msgStatusLableWidth, msgStatusLableHeight);
            self.msgStatusLable.frame = msgStatusLableFrame;
            
        }else{
             self.msgStatusLable.frame = CGRectZero;
        }
        
        
        if ([ self.tipLable.text isNotEmpty]) {
            CGSize size = [self.tipLable sizeThatFits:CGSizeMake(40, 20)];
            CGFloat tip_width = size.width + 22;
            if (tip_width + AVATAR_WIDTH + AVATAR_SPACE_X + MSGBG_SPACE_X > PhotoScreenWidth) {
                tip_width = PhotoScreenWidth - (AVATAR_WIDTH + AVATAR_SPACE_X + MSGBG_SPACE_X + 10);
            }
            CGFloat tipLableHeight  = TIPLABEL_HEIGHT;
            CGFloat tipLableWidth = tip_width;
            CGFloat tipLableTop = contentViewfFrame.origin.y + contentViewfFrame.size.height + TIPLABEL_SPACE_Y;
            CGFloat tipLableLeft = contentViewfFrame.origin.x + contentViewfFrame.size.width - tip_width;
            CGRect tipLableFrame = CGRectMake(tipLableLeft, tipLableTop, tipLableWidth, tipLableHeight);
            self.tipLable.frame = tipLableFrame;
        }else{
             self.tipLable.frame = CGRectZero;
        }
    }else if(item.fromType == PhotonChatMessageFromFriend){
        self.msgStatusLable.frame = CGRectZero;
        self.tipLable.frame = CGRectZero;
        
    }
    
    self.maskView.frame = CGRectMake(0, 0, self.contentBackgroundView.width, self.contentBackgroundView.height);
    
//    CGRect progressViewFrame = self.progressView.frame;
//    CGFloat progressHeight = self.maskView.height/2.0;
//    CGFloat progressWidth = progressHeight;
//    progressViewFrame.size =CGSizeMake(progressWidth, progressHeight);
//    CGFloat y = (self.maskView.height - progressHeight)/2.0;
//    CGFloat x= (self.maskView.width - progressWidth)/2.0;
//    progressViewFrame.origin = CGPointMake(x, y);
//    self.progressView.frame = progressViewFrame;
    self.progressView.center = CGPointMake(self.maskView.width / 2, self.maskView.height / 2);
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.tipLable.text = nil;
    self.msgStatusLable.text = nil;
    self.timeLabel.text = nil;
    self.maskView.hidden = YES;
    self.progressView.hidden = YES;
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object{
    PhotonChatBaseItem *item = (PhotonChatBaseItem *)object;
    return item.itemHeight;
}


#pragma mark --------- Action ----------
- (void)avatarBtnAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatCell:didSelectAvatar:)]) {
        [self.delegate chatCell:self didSelectAvatar:self.item];
    }
}

- (void)sendStateBtnAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatCell:resendChatMessage:)]) {
        [self.delegate chatCell:self resendChatMessage:self.item];
    }
}

- (void)longPressBGView:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(chatCell: chatMessageCellLongPress:rect:)]) {
        CGRect rect = self.contentBackgroundView.frame;
        rect.size.height -= 10;
        rect.origin.y += 10;
        [_delegate chatCell:self chatMessageCellLongPress:self.item rect:rect];
    }
}

- (void)tapBackgroundView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatCell:chatMessageCellTap:)]) {
        [self.delegate chatCell:self chatMessageCellTap:self.item];
    }
}

#pragma mark ------- getter ---------
- (UIButton *)avatarBtn{
    if (!_avatarBtn) {
        _avatarBtn = [[UIButton alloc] init];
        [_avatarBtn.layer setMasksToBounds:YES];
        _avatarBtn.layer.cornerRadius = 5;
        _avatarBtn.clipsToBounds = YES;
        [_avatarBtn.layer setBorderColor:[UIColor colorWithWhite:0.7 alpha:1.0].CGColor];
        [_avatarBtn addTarget:self action:@selector(avatarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarBtn;
}

- (UIButton *)sendStateBtn{
    if (!_sendStateBtn) {
        _sendStateBtn = [[UIButton alloc] init];
        _sendStateBtn.hidden = YES;
        [_sendStateBtn addTarget:self action:@selector(sendStateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendStateBtn;
}

- (UIImageView *)contentBackgroundView{
    if (!_contentBackgroundView) {
        _contentBackgroundView = [[UIImageView alloc] init];
        [_contentBackgroundView setUserInteractionEnabled:YES];
        _contentBackgroundView.layer.cornerRadius = 5;
        self.contentBackgroundView.clipsToBounds = YES;
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressBGView:)];
        [_contentBackgroundView addGestureRecognizer:longPressGR];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundView)];
        [_contentBackgroundView addGestureRecognizer:tap];
    }
    return _contentBackgroundView;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [_timeLabel setTextColor:[UIColor colorWithHex:0x9D9D9D]];
        [_timeLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _timeLabel;
}

- (UILabel *)tipLable{
    if (!_tipLable) {
        _tipLable = [[UILabel alloc] init];
        [_tipLable setFont:[UIFont systemFontOfSize:11.0f]];
        [_tipLable setTextColor:[UIColor colorWithHex:0x777777]];
        [_tipLable setBackgroundColor:[UIColor colorWithHex:0xDADADA]];
        [_tipLable setTextAlignment:NSTextAlignmentCenter];
        [_tipLable.layer setMasksToBounds:YES];
        [_tipLable.layer setCornerRadius:5.0f];
    }
    return _tipLable;
}

- (UILabel *)msgStatusLable{
    if (!_msgStatusLable) {
        _msgStatusLable = [[UILabel alloc] init];
        [_msgStatusLable setFont:[UIFont systemFontOfSize:11.0f]];
        [_msgStatusLable setTextColor:[UIColor colorWithHex:0x9D9D9D]];
        [_msgStatusLable setTextAlignment:NSTextAlignmentCenter];
    }
    return _msgStatusLable;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.hidden = YES;
        _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    }
    return _maskView;
}

- (UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _indicatorView;
}

- (PhotonCircleProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[PhotonCircleProgressView alloc] init];
        _progressView.hidden = YES;
    }
    return _progressView;
}
- (void)changeProgressValue:(CGFloat)value
{
    if(value >= 1.0){
        self.maskView.hidden = YES;
        self.progressView.hidden = YES;
    }else{
        self.maskView.hidden = NO;
        self.progressView.hidden = NO;
    }
   
    self.progressView.progress = value;
    if (value >= 1) {
      self.maskView.hidden = YES;
             self.progressView.hidden = YES;
    }

}


- (PhotonCircleLoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[PhotonCircleLoadingView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _loadingView.backgroundColor = [UIColor clearColor];
    }
    return _loadingView;
}
#pragma mark -------- Identifier ---------
+ (NSString *) cellIdentifier{
    return @"PhotonBaseChatCell";
}
@end
