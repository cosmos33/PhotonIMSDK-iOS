//
//  PhotonImageMessageChatCellTableViewCell.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/24.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonChatImageMessageCell.h"
#import "PhotonChatImageMessageItem.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PhotonMacros.h"
@interface PhotonChatImageMessageCell()
@end

@implementation PhotonChatImageMessageCell
- (void)dealloc
{
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
    }
    return self;
}

- (void)setObject:(id)object{
    [super setObject:object];
    if (!self.item) {
        return;
    }
//    self.contentBackgroundView.contentMode =  UIViewContentModeScaleAspectFit;
//    self.contentBackgroundView.backgroundColor = [UIColor clearColor];
    PhotonChatImageMessageItem *imageItem = (PhotonChatImageMessageItem *)object;
    NSURL *fileURL = nil;
    if (imageItem.localPath && imageItem.localPath.length > 0) {
        [self.contentBackgroundView setImage:[UIImage imageWithContentsOfFile:imageItem.localPath?:@""]];
    }else{
        if (imageItem.thumURL) {
               if ([imageItem.thumURL hasPrefix:@"http"]) {
                   fileURL = [NSURL URLWithString:imageItem.thumURL?:@""];
               }else{
                   fileURL = [NSURL fileURLWithPath:imageItem.thumURL?:@""];
               }
           }
           if (fileURL) {
               [self.contentBackgroundView sd_setImageWithURL:fileURL placeholderImage:nil];
           }else{
               if (imageItem.localPath) {
                   [self.contentBackgroundView setImage:[UIImage imageWithContentsOfFile:imageItem.localPath?:@""]];
               }else{
                  
               }
           }
    }
}

- (void)p_layoutViews{
    PhotonChatBaseItem *item = (PhotonChatBaseItem *)self.item;
    CGRect contentBackgroundViewFrame = self.contentBackgroundView.frame;
    contentBackgroundViewFrame.size = CGSizeMake(item.contentSize.width , item.contentSize.height);
    CGFloat contentBackgroundViewLeft = 0;
    if (item.fromType == PhotonChatMessageFromSelf) {
        contentBackgroundViewLeft = contentBackgroundViewFrame.origin.x-contentBackgroundViewFrame.size.width;
    }else{
        contentBackgroundViewLeft = contentBackgroundViewFrame.origin.x;
    }
    contentBackgroundViewFrame.origin.x = contentBackgroundViewLeft;
    self.contentBackgroundView.frame = contentBackgroundViewFrame;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self p_layoutViews];
    [self subview_layout];
}

- (void)prepareForReuse{
    [super prepareForReuse];
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
    PhotonChatImageMessageItem *item = (PhotonChatImageMessageItem *)object;
    return item.itemHeight;
}

+ (NSString *)cellIdentifier{
    return @"PhotonImageMessageChatCell";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
