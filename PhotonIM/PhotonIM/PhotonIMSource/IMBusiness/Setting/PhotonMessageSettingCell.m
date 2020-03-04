//
//  PhotonMessageSettingCell.m
//  PhotonIM
//
//  Created by Bruce on 2019/7/31.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonMessageSettingCell.h"
#import "PhotonMessageSettingItem.h"
@interface PhotonMessageSettingCell()
@property (nonatomic,strong,nullable)UILabel *titleLabel;
@property (nonatomic, strong,nullable)UISwitch *settingSwitch;
@property(nonatomic, copy, nullable)UIImageView *icon;
@property (nonatomic,strong,nullable)UIButton *btn;
@end
@implementation PhotonMessageSettingCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.settingSwitch];
        [self.contentView addSubview:self.icon];
        
    }
    return self;
}

- (void)setObject:(id)object{
    [super setObject:object];
    PhotonMessageSettingItem *item = (PhotonMessageSettingItem *)object;
    self.titleLabel.text = item.settingName;

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    if (item.showSwitch) {
         self.icon.hidden = YES;
        self.settingSwitch.on = item.open;
        [self.settingSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-10);
            make.centerY.mas_equalTo(self.contentView);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(28);
        }];
    }else{
        self.settingSwitch.hidden = YES;
        [self.icon setImage:[UIImage imageNamed:item.icon]];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).mas_offset(-10);
            make.centerY.mas_equalTo(self.contentView);
            make.width.mas_equalTo(22);
        }];
    }
    
    
  
    
}

#pragma mark ----- Getter ---------
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = self.contentView.backgroundColor;
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
        _titleLabel.textColor = [UIColor colorWithHex:0x000000];
    }
    return _titleLabel;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        _icon.backgroundColor = [UIColor clearColor];
        _icon.userInteractionEnabled = NO;
    }
    return _icon;
}

- (UISwitch *)settingSwitch{
    if (!_settingSwitch) {
        _settingSwitch = [[UISwitch alloc] init];
        [_settingSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingSwitch;
}

- (void)switchAction:(UISwitch *)sender{
    PhotonMessageSettingItem *item = (PhotonMessageSettingItem *)self.item;
    item.open = sender.on;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:switchItem:)]) {
        [self.delegate cell:self switchItem:item];
    }
}
+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object{
    PhotonMessageSettingItem *item = (PhotonMessageSettingItem *)object;
    return item.itemHeight;
}
+ (NSString *)cellIdentifier{
    return @"PhotonMessageSettingCell";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
