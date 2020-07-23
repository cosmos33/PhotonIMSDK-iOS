//
//  PhotonSettingView.m
//  PhotonIM
//
//  Created by Bruce on 2020/1/16.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonSettingView.h"
#import "PhotonMacros.h"
typedef NS_ENUM(NSInteger,SelectDateType) {
    SelectDateTypeNO,
    SelectDateTypeStart,
    SelectDateTypeEnd,
};
@interface PhotonSettingView()
@property(nonatomic, strong,nullable)UIDatePicker *datePicker;
@property(nonatomic, strong,nullable)UITextField *sizeFiled;
@property(nonatomic, strong,nullable)UITextField *beginTimeLable;
@property(nonatomic, strong,nullable)UITextField *endTimeLable;
@property(nonatomic, strong,nullable)UILabel *openSwith;
@property(nonatomic, strong,nullable)UISwitch *onlyServiceSwitch;

@property(nonatomic, strong, nullable)UIButton *selectBtn;

@end
@implementation PhotonSettingView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self  initContent];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self  initContent];
    }
    return self;
}

- (void)initContent{
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.openSwith];
    [self addSubview:self.onlyServiceSwitch];
    [self addSubview:self.sizeFiled];
    [self addSubview:self.beginTimeLable];
    [self addSubview:self.endTimeLable];
    [self addSubview:self.selectBtn];
    
    [self.onlyServiceSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(60);
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(self.mas_centerX).offset(-60);
    }];
    
    [self.openSwith mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(200);
        make.centerY.mas_equalTo(self.onlyServiceSwitch.mas_centerY).offset(-4);
        make.left.mas_equalTo(self.onlyServiceSwitch.mas_right).offset(5);
    }];
    
    [self.sizeFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self);
        make.top.mas_equalTo(self.onlyServiceSwitch.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(0);
    }];
    
    [self.beginTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self);
        make.top.mas_equalTo(self.sizeFiled.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(0);
    }];
    
    
    [self.endTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self);
        make.top.mas_equalTo(self.beginTimeLable.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(0);
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.height.mas_equalTo(40);
           make.width.mas_equalTo(self);
           make.top.mas_equalTo(self.endTimeLable.mas_bottom).mas_offset(10);
           make.left.mas_equalTo(0);
       }];
}
- (UILabel *)openSwith{
    if (!_openSwith) {
        _openSwith = [[UILabel alloc] init];
        if ([PhotonContent currentSettingModel].onlyLoadService) {
            _openSwith.text = @"加载服务端数据开启";
        }else{
            _openSwith.text = @"加载服务端数据关闭";
        }
        _openSwith.font = [UIFont systemFontOfSize:16];
        _openSwith.backgroundColor = [UIColor clearColor];
        _openSwith.textColor = [UIColor whiteColor];
    }
    return _openSwith;
}
- (UISwitch *)onlyServiceSwitch{
    if (!_onlyServiceSwitch) {
        _onlyServiceSwitch = [[UISwitch alloc] init];
        _onlyServiceSwitch.on = [PhotonContent currentSettingModel].onlyLoadService;
        [_onlyServiceSwitch addTarget:self action:@selector(swithAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _onlyServiceSwitch;
}
- (UITextField *)sizeFiled{
    if (!_sizeFiled) {
        _sizeFiled = [[UITextField alloc] init];
        _sizeFiled.keyboardType = UIKeyboardTypeNumberPad;
        _sizeFiled.placeholder = @"每页拉取消息的条数";
        if ([PhotonContent currentSettingModel].onlyLoadService && [PhotonContent currentSettingModel].size >0) {
            _sizeFiled.text = [NSString stringWithFormat:@"%@",@([PhotonContent currentSettingModel].size)];
        }
        _sizeFiled.backgroundColor = [UIColor whiteColor];
    }
    return _sizeFiled;
}

- (UITextField *)beginTimeLable{
    if (!_beginTimeLable) {
        _beginTimeLable = [[UITextField alloc] init];
        _beginTimeLable.keyboardType = UIKeyboardTypeNumberPad;
        _beginTimeLable.placeholder = @"开始时间（毫秒时间戳）";
        if ([PhotonContent currentSettingModel].onlyLoadService && [PhotonContent currentSettingModel].beginTime >0) {
            _beginTimeLable.text = [NSString stringWithFormat:@"%@",@([PhotonContent currentSettingModel].beginTime)];
        }
        
        _beginTimeLable.backgroundColor = [UIColor whiteColor];
    }
    return _beginTimeLable;
}

- (UITextField *)endTimeLable{
   if (!_endTimeLable) {
        _endTimeLable = [[UITextField alloc] init];
        _endTimeLable.keyboardType = UIKeyboardTypeNumberPad;
        _endTimeLable.placeholder = @"结束时间时间（毫秒时间戳）";
       if ([PhotonContent currentSettingModel].onlyLoadService && [PhotonContent currentSettingModel].endTime > 0) {
           _endTimeLable.text = [NSString stringWithFormat:@"%@",@([PhotonContent currentSettingModel].endTime)];
       }
        _endTimeLable.backgroundColor = [UIColor whiteColor];
    }
    return _endTimeLable;
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_selectBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}
- (void)showViewInSuperView:(UIView *)superView{
    self.alpha = 0;
    [superView addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
}


- (void)okAction:(id)sender{
    if ([PhotonContent currentSettingModel].onlyLoadService) {
        NSString *content = self.sizeFiled.text;
        if ([self deptNumInputShouldNumber:content]) {
            [PhotonContent currentSettingModel].size = [content integerValue];
        }else{
            [PhotonUtil showErrorHint:@"数字输入格式错误"];
        }
        
        if ([self deptNumInputShouldNumber:self.beginTimeLable.text]) {
            [PhotonContent currentSettingModel].beginTime = [self.beginTimeLable.text longLongValue];
        }else{
            [PhotonUtil showErrorHint:@"开始时间输入格式错误"];
        }
        
        if ([self deptNumInputShouldNumber:self.endTimeLable.text]) {
            [PhotonContent currentSettingModel].endTime = [self.endTimeLable.text longLongValue];
        }else{
            [PhotonUtil showErrorHint:@"结束时间输入格式错误"];
        }
    }
    
    
   [UIView animateWithDuration:0.3 animations:^{
       self.alpha = 0;
   } completion:^(BOOL finished) {
       [self removeFromSuperview];
   }];
}

- (void)swithAction:(UISwitch *)sender{
    [PhotonContent currentSettingModel].onlyLoadService = sender.on;
    if (sender.on) {
        self.openSwith.text = @"加载服务端数据开启";
    }else{
        self.openSwith.text = @"加载服务端数据关闭";
    }
}

- (BOOL) deptNumInputShouldNumber:(NSString *)str
{
   if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}
@end
