//
//  PhotonConversationBaseCell.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/26.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonChatTestBaseCell.h"
#import "PhotonMessageCenter.h"
#import "PhotonChatTestItem.h"
#import "PhoneBadgeView.h"
#import "NSString+PhotonExtensions.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface PhotonChatTestBaseCell()
@property (nonatomic, strong, nullable) UIImageView *iconView;
@property (nonatomic, strong, nullable) UILabel *nickLabel;
@property (nonatomic, strong, nullable) UILabel *contextLabel;


@property (nonatomic, strong, nullable)UIButton *startChatBtn;
@property (nonatomic, strong, nullable)UIButton *clearBtn;
@end

@implementation PhotonChatTestBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.nickLabel];
        [self.contentView addSubview:self.contextLabel];
        [self.contentView addSubview:self.startChatBtn];
        [self.contentView addSubview:self.clearBtn];
    }
    return self;
}

- (void)setObject:(id)object{
    [super setObject:object];
    if (!self.item) {
        return;
    }
    PhotonChatTestItem *item = (PhotonChatTestItem *)object;
    PhotonIMConversation *conversation = (PhotonIMConversation *)item.userInfo;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:conversation.FAvatarPath] placeholderImage:[UIImage imageWithColor:RGBAColor(0, 0, 0, 0.6)]];
    
    NSString *nickName = @"";
    if ([conversation.FName isNotEmpty]) {
        nickName = conversation.FName;
        if (nickName.length > 15) {
            nickName = [NSString stringWithFormat:@"%@...",[nickName substringWithRange:NSMakeRange(0, 14)]];
        }
    }else{
        nickName = conversation.chatWith;
    }
     self.nickLabel.text = nickName;
    
    if (item.isStartChat) {
         [_startChatBtn setTitle:@"停止" forState:UIControlStateNormal];
    }else{
         [_startChatBtn setTitle:@"开始" forState:UIControlStateNormal];
    }
    
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *atTypeString = [[NSMutableAttributedString alloc] init];
    if (conversation.atType == PhotonIMConversationAtTypeAtMe) {
        atTypeString = [[NSMutableAttributedString alloc] initWithString:@"有人@了我" attributes:@{NSForegroundColorAttributeName:(id)[UIColor redColor]}];
    }else if (conversation.atType == PhotonIMConversationTypeAtAll){
         atTypeString = [[NSMutableAttributedString alloc] initWithString:@"@所有人" attributes:@{NSForegroundColorAttributeName:(id)[UIColor redColor]}];
    }
    if (atTypeString) {
        [content appendAttributedString:atTypeString];
    }
    NSMutableAttributedString *chatContent;
    if(conversation.chatType == PhotonIMChatTypeGroup && conversation.lastMsgContent && conversation.lastMsgContent.length > 0){
         PhotonUser *user =  [PhotonContent findUserWithGroupId:conversation.lastMsgTo uid:conversation.lastMsgFr];
         chatContent = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",user.nickName,[conversation.lastMsgContent trim]] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x9B9B9B]}];
    }else{
        if(conversation.lastMsgContent){
             chatContent = [[NSMutableAttributedString alloc] initWithString:[conversation.lastMsgContent trim] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x9B9B9B]}];
        }
       
    }
    if (chatContent) {
        [content appendAttributedString:chatContent];
    }
    self.contextLabel.attributedText = content;
    BOOL isSending = [conversation.lastMsgContent isNotEmpty] && (conversation.lastMsgStatus == PhotonIMMessageStatusSending);
    BOOL isSentFailed = [conversation.lastMsgContent isNotEmpty] && (conversation.lastMsgStatus == PhotonIMMessageStatusFailed);
    if (!conversation.lastMsgIsReceived) {
        isSending = NO;
        isSentFailed = NO;
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self p_layoutViews];
}

- (void)p_layoutViews{
    CGRect contentFrame = self.contentView.frame;
    // 头像
    CGRect iconFrame = self.iconView.frame;
    iconFrame.size = CGSizeMake(56.0, 56.0);
    CGFloat iconY = (contentFrame.size.height - 56.0)/2.0;
    iconFrame.origin = CGPointMake(17.5, iconY);
    self.iconView.frame = iconFrame;
    
    // 昵称
    CGSize size = [self.nickLabel sizeThatFits:CGSizeMake(PhotoScreenWidth, MAXFLOAT)];
    CGRect nickFrame = self.nickLabel.frame;
    nickFrame.size = size;
    CGFloat nickX = iconFrame.size.width + iconFrame.origin.x + 15.5;
    nickFrame.origin = CGPointMake(nickX, 21.0);
    self.nickLabel.frame = nickFrame;
    
    CGRect startChatFrame = self.startChatBtn.frame;
    startChatFrame.size = CGSizeMake(55.0, 30.0);
    CGFloat startChatY = 5.0;
    CGFloat startChatX = contentFrame.size.width - startChatFrame.size.width - 5;
    startChatFrame.origin = CGPointMake(startChatX, startChatY);
    self.startChatBtn.frame = startChatFrame;
    
    CGRect clearFrame = self.startChatBtn.frame;
    clearFrame.size = CGSizeMake(55.0, 30.0);
    CGFloat clearY = contentFrame.size.height - startChatFrame.size.height - 5;;
    CGFloat clearX = contentFrame.size.width - startChatFrame.size.width - 5;
    clearFrame.origin = CGPointMake(clearX, clearY);
    self.clearBtn.frame = clearFrame;
    
    
    CGRect contextFrame = self.startChatBtn.frame;
    contextFrame.size = CGSizeMake(55.0, 30.0);
    CGFloat contextHeight = 18.5;
    CGFloat contextWith = contentFrame.size.width - (iconFrame.size.width + clearFrame.size.width + iconFrame.origin.x + 5);
    CGFloat contextY = nickFrame.size.height + nickFrame.origin.y + 1.5;
    CGFloat contextX = nickFrame.origin.x;
    contextFrame = CGRectMake(contextX, contextY, contextWith, contextHeight);
    self.contextLabel.frame = contextFrame;
           
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)didSelectIcon:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(conCell:didSelectAvatar:)]) {
         PhotonChatTestItem *item = (PhotonChatTestItem *)self.item;
        [self.delegate conCell:self didSelectAvatar:item];
    }
}

#pragma mark ---- Getter ------
- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.clipsToBounds = YES;
        _iconView.layer.cornerRadius = 16.0;
        _iconView.userInteractionEnabled = NO;
        _iconView.backgroundColor = [UIColor clearColor];
    }
    return _iconView;
}


- (UILabel *)nickLabel{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.textColor = [UIColor colorWithHex:0x000000];
        _nickLabel.textAlignment = NSTextAlignmentLeft;
        _nickLabel.font = [UIFont systemFontOfSize:15.0];
        [_nickLabel setNumberOfLines:1];
    }
    return _nickLabel;
}


- (UILabel *)contextLabel{
    if (!_contextLabel) {
        _contextLabel = [[UILabel alloc] init];
        _contextLabel.textColor = [UIColor colorWithHex:0x9B9B9B];
        _contextLabel.textAlignment = NSTextAlignmentLeft;
        _contextLabel.font = [UIFont systemFontOfSize:13.0];
        [_contextLabel setNumberOfLines:1];
    }
    return _contextLabel;
}




+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object{
    PhotonChatTestItem *item = (PhotonChatTestItem *)object;
    return [item itemHeight];
}

+ (NSString *)cellIdentifier{
    return @"PhotonChatTestBaseCell";
}

- (UIButton *)startChatBtn{
    if (!_startChatBtn) {
        _startChatBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_startChatBtn setTitle:@"开始" forState:UIControlStateNormal];
        [_startChatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startChatBtn setBackgroundColor:[UIColor colorWithHex:0x41b6e6] forState:UIControlStateNormal];
        [_startChatBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        _startChatBtn.layer.cornerRadius = 5;
        [_startChatBtn addTarget:self action:@selector(startChat:) forControlEvents:UIControlEventTouchUpInside];
    }
      return _startChatBtn;
}
-(UIButton *)clearBtn{
    if (!_clearBtn) {
           _clearBtn= [UIButton buttonWithType:UIButtonTypeCustom];
           [_clearBtn setTitle:@"清空" forState:UIControlStateNormal];
           [_clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
           [_clearBtn setBackgroundColor:[UIColor colorWithHex:0x41b6e6] forState:UIControlStateNormal];
           [_clearBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
           _clearBtn.layer.cornerRadius = 5;
           [_clearBtn addTarget:self action:@selector(clearData:) forControlEvents:UIControlEventTouchUpInside];
       }
         return _clearBtn;
}

- (void)startChat:(id)sender{
    PhotonChatTestItem *item = (PhotonChatTestItem *)self.item;
    item.isStartChat = !item.isStartChat;
    if (item.isStartChat) {
           [_startChatBtn setTitle:@"停止" forState:UIControlStateNormal];
      }else{
           [_startChatBtn setTitle:@"开始" forState:UIControlStateNormal];
      }
    if(self.delegate && [self.delegate respondsToSelector:@selector(startChatCell:startChat:)]){
        [self.delegate startChatCell:self startChat:item];
    }
}

- (void)clearData:(id)sender{
    PhotonChatTestItem *item = (PhotonChatTestItem *)self.item;
    if(self.delegate && [self.delegate respondsToSelector:@selector(clearChatCell:clearData:)]){
        [self.delegate clearChatCell:self clearData:item];
    }
}

@end
