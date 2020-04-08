//
//  PhotonCircleProgressView.m
//  PhotonIM
//
//  Created by Bruce on 2020/3/19.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonCircleProgressView.h"
//@interface PhotonCircleProgressView ()
//{
//    CAShapeLayer *backGroundLayer;      //背景图层
//    CAShapeLayer *frontFillLayer;       //用来填充的图层
//    UIBezierPath *backGroundBezierPath; //背景贝赛尔曲线
//    UIBezierPath *frontFillBezierPath;  //用来填充的贝赛尔曲线
//}
//@end
//@implementation PhotonCircleProgressView
//
//@synthesize progressValue = _progressValue;
//- (instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super initWithCoder:aDecoder]) {
//        [self setUp];
//    }
//    return self;
//}
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame])
//    {
//        [self setUp];
//        
//    }
//    return self;
//    
//}
//
////初始化创建图层
//- (void)setUp
//{
//    //创建背景图层
//    backGroundLayer = [CAShapeLayer layer];
//    backGroundLayer.fillColor = nil;
//
//    //创建填充图层
//    frontFillLayer = [CAShapeLayer layer];
//    frontFillLayer.fillColor = nil;
//
//    
//    [self.layer addSublayer:backGroundLayer];
//    [self.layer addSublayer:frontFillLayer];
//    
//    //设置颜色
//    frontFillLayer.strokeColor = [UIColor colorWithRed:78/255.0 green:194/255.0 blue:0/255.0 alpha:1.0].CGColor;
//    backGroundLayer.strokeColor = [UIColor colorWithRed:190/255.0 green:255/255.0 blue:167/255.0 alpha:1.0].CGColor;
//  
//}
//
//#pragma mark -子控件约束
//-(void)layoutSubviews {
//
//    [super layoutSubviews];
//    
//    CGFloat width = self.bounds.size.width;
//    backGroundLayer.frame = self.bounds;
//
//
//    backGroundBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f) radius:(CGRectGetWidth(self.bounds)-2.0)/2.f startAngle:0 endAngle:M_PI*2
//                                                       clockwise:YES];
//    backGroundLayer.path = backGroundBezierPath.CGPath;
//    frontFillLayer.frame = self.bounds;
//    //设置线宽
//    frontFillLayer.lineWidth = width;
//    backGroundLayer.lineWidth = width;
//}
//
//- (void)setProgressValue:(CGFloat)progressValue
//{
//    
//     progressValue = MAX( MIN(progressValue, 1.0), 0.0);
//     _progressValue = progressValue;
//     if (progressValue == 1) {
//        
//        if ([self.delegate respondsToSelector:@selector(progressViewOver:)]) {
//            
//            [self.delegate progressViewOver:self];
//        }
//        return;
//    }
//    
//    CGFloat width = self.bounds.size.width;
//    
//    frontFillBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f) radius:(CGRectGetWidth(self.bounds)-2.0)/2.f startAngle:-0.25*2*M_PI endAngle:(2*M_PI)*progressValue - 0.25*2*M_PI clockwise:YES];
//    frontFillLayer.path = frontFillBezierPath.CGPath;
//}
//- (CGFloat)progressValue
//{
//    return _progressValue;
//}
//
//@end
//


@interface PhotonCircleProgressView ()
// 外界圆形
@property (nonatomic, strong) CAShapeLayer *circleLayer;
// 内部扇形
@property (nonatomic, strong) CAShapeLayer *fanshapedLayer;
// 错误
@property (nonatomic, strong) CAShapeLayer *errorLayer;
@end

@implementation PhotonCircleProgressView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = self.frame;
        rect.size = CGSizeMake(50, 50);
        self.frame = rect;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.strokeColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8].CGColor;
    circleLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    circleLayer.path = [self circlePath].CGPath;
    [self.layer addSublayer:circleLayer];
    self.circleLayer = circleLayer;
    
    CAShapeLayer *fanshapedLayer = [CAShapeLayer layer];
    fanshapedLayer.fillColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8].CGColor;
    [self.layer addSublayer:fanshapedLayer];
    self.fanshapedLayer = fanshapedLayer;
    
    CAShapeLayer *errorLayer = [CAShapeLayer layer];
    errorLayer.frame = self.bounds;
    errorLayer.hidden = YES;
    // 旋转 45 度
    errorLayer.affineTransform = CGAffineTransformMakeRotation(M_PI_4);
    errorLayer.fillColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8].CGColor;
    errorLayer.path = [self errorPath].CGPath;
    [self.layer addSublayer:errorLayer];
    self.errorLayer = errorLayer;
    
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self updateProgressLayer];
}

- (void)showError {
    self.errorLayer.hidden = false;
    self.fanshapedLayer.hidden = true;
}

- (void)updateProgressLayer {
    self.errorLayer.hidden = true;
    self.fanshapedLayer.hidden = false;
    
    self.fanshapedLayer.path = [self pathForProgress:self.progress].CGPath;
}

- (UIBezierPath *)errorPath {
    CGFloat width = 30;
    CGFloat height = 5;
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(self.frame.size.width * 0.5 - height * 0.5, (self.frame.size.width - width) * 0.5, height, width)];
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:CGRectMake((self.frame.size.width - width) * 0.5, self.frame.size.width * 0.5 - height * 0.5, width, height)];
    [path2 appendPath:path1];
    return path2;
}

- (UIBezierPath *)circlePath {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5) radius:25 startAngle:0 endAngle:M_PI * 2 clockwise:true];
    path.lineWidth = 0;
    return path;
}

- (UIBezierPath *)pathForProgress:(CGFloat)progress {
    CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    CGFloat radius = self.frame.size.height * 0.5;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: center];
    [path addLineToPoint:CGPointMake(self.frame.size.width * 0.5, center.y - radius)];
    [path addArcWithCenter:center radius: radius startAngle: -M_PI / 2 endAngle: -M_PI / 2 + M_PI * 2 * progress clockwise:true];
    [path closePath];
    path.lineWidth = 0;
    return path;
}
@end
