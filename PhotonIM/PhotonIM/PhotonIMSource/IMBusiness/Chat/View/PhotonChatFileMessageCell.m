//
//  PhotonChatFileMessageCell.m
//  PhotonIM
//
//  Created by Bruce on 2020/2/17.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonChatFileMessageCell.h"
#import "PhotonChatFileMessageItem.h"
@interface PhotonChatFileMessageCell()
@property(nonatomic,strong)UILabel *fileNameLabel;
@property(nonatomic,strong)UILabel *fileSizeLabel;
@property(nonatomic,strong)UIImageView *fileIcon;
@end
@implementation PhotonChatFileMessageCell
- (void)dealloc
{
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self.contentBackgroundView addSubview:self.fileNameLabel];
        [self.contentBackgroundView addSubview:self.fileSizeLabel];
        [self.contentBackgroundView addSubview:self.fileIcon];
    }
    return self;
}

- (void)setObject:(id)object{
    [super setObject:object];
    if (!self.item) {
        return;
    }
    
    PhotonChatFileMessageItem *item = (PhotonChatFileMessageItem *)object;
    if (item.fromType == PhotonChatMessageFromSelf) {
        self.contentBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    self.fileNameLabel.text = item.fileName;
    self.fileSizeLabel.text = item.fileSize;
    self.fileIcon.image = item.fileICon;
}

- (void)p_layoutViews{
    PhotonChatBaseItem *item = (PhotonChatBaseItem *)self.item;
    CGRect contentBackgroundViewFrame = self.contentBackgroundView.frame;
    contentBackgroundViewFrame.size = CGSizeMake(item.contentSize.width, item.contentSize.height);
    CGFloat contentBackgroundViewLeft = 0;
    if (item.fromType == PhotonChatMessageFromSelf) {
        contentBackgroundViewLeft = contentBackgroundViewFrame.origin.x-contentBackgroundViewFrame.size.width;
    }else{
        contentBackgroundViewLeft = contentBackgroundViewFrame.origin.x;
    }
    contentBackgroundViewFrame.origin.x = contentBackgroundViewLeft;
    self.contentBackgroundView.frame = contentBackgroundViewFrame;
    
    CGRect nameFrame = self.fileNameLabel.frame;
    nameFrame.size = CGSizeMake(135, 25);
    
    CGRect sizeFrame = self.fileSizeLabel.frame;
    sizeFrame.size = CGSizeMake(135, 20);
    
    CGRect iconFrame = self.fileIcon.frame;
    if (item.fromType == PhotonChatMessageFromSelf) {
        nameFrame.origin = CGPointMake(10, 8);
        sizeFrame.origin = CGPointMake(10, nameFrame.size.height + nameFrame.origin.y);
        self.fileNameLabel.frame = nameFrame;
        self.fileSizeLabel.frame = sizeFrame;
        
        iconFrame.origin = CGPointMake(self.contentBackgroundView.width - self.fileIcon.width - 5, (self.contentBackgroundView.height - self.fileIcon.height)/2.0);
        self.fileIcon.frame = iconFrame;
    }else{
        iconFrame.origin = CGPointMake(10, (self.contentBackgroundView.height - self.fileIcon.height)/2.0);
        self.fileIcon.frame = iconFrame;
        nameFrame.origin = CGPointMake(self.fileIcon.width + self.fileIcon.x + 5, 8);
        sizeFrame.origin = CGPointMake(nameFrame.origin.x, nameFrame.size.height + nameFrame.origin.y);
        self.fileNameLabel.frame = nameFrame;
        self.fileSizeLabel.frame = sizeFrame;
        
        
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self p_layoutViews];
    [self subview_layout];
}

- (void)prepareForReuse{
    [super prepareForReuse];
}

- (UILabel *)fileNameLabel{
    if (!_fileNameLabel) {
        _fileNameLabel = [[UILabel alloc] init];
        _fileNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _fileNameLabel.font = [UIFont systemFontOfSize:16.0 weight:0.8];
        _fileNameLabel.textColor = [UIColor colorWithHex:0x000000];
    }
    return _fileNameLabel;
}

- (UILabel *)fileSizeLabel{
    if (!_fileSizeLabel) {
        _fileSizeLabel = [[UILabel alloc] init];
        _fileSizeLabel.font = [UIFont systemFontOfSize:12.0];
        _fileSizeLabel.textColor = [UIColor colorWithHex:0x9B9B9B];
    }
    return _fileSizeLabel;
}

- (UIImageView *)fileIcon{
    if (!_fileIcon) {
        _fileIcon = [[UIImageView alloc] init];
        _fileIcon.backgroundColor = [UIColor clearColor];
        _fileIcon.size = CGSizeMake(41, 41);
    }
    return _fileIcon;
}

#pragma mark ----- Getter ---------
- (void)longPressBGView:(UIGestureRecognizer *)gestureRecognizer{
    [super longPressBGView:gestureRecognizer];
}

- (void)tapBackgroundView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatCell:chatMessageCellTap:)]) {
        [self.delegate chatCell:self chatMessageCellTap:self.item];
    }
}

+(CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object{
    PhotonChatFileMessageItem *item = (PhotonChatFileMessageItem *)object;
    return item.itemHeight;
}

+ (NSString *)cellIdentifier{
    return @"PhotonChatFileMessageCell";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
