//
//  PhotonCircleLoadingView.m
//  PhotonIM
//
//  Created by Bruce on 2020/3/24.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonCircleLoadingView.h"
#import "PhotonMacros.h"
@interface PhotonCircleLoadingView()
@property (nonatomic, strong)CALayer  *circlelayer;
@end

@implementation PhotonCircleLoadingView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawCircle];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self drawCircle];
    }
    return self;
}

- (CALayer *)circlelayer{
    if (!_circlelayer) {
        _circlelayer = [CALayer layer];
        _circlelayer.frame = CGRectMake(0, 0, 60, 60);
        _circlelayer.backgroundColor = [UIColor grayColor].CGColor;
    }
    return _circlelayer;
}

- (void)drawCircle{
    [self.layer addSublayer:self.circlelayer];
    
    //创建圆环
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(30, 30) radius:25 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    //圆环遮罩
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 1;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineDashPhase = 0.8;
    shapeLayer.path = bezierPath.CGPath;
    [self.circlelayer setMask:shapeLayer];
    
    //颜色渐变
    NSMutableArray *colors = [NSMutableArray arrayWithObjects:(id)[UIColor grayColor].CGColor,(id)[RGBAColor(255, 255, 255, 0.5) CGColor], nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.shadowPath = bezierPath.CGPath;
    gradientLayer.frame = CGRectMake(0, 0, 60, 30);
    gradientLayer.startPoint = CGPointMake(1, 0);
    gradientLayer.endPoint = CGPointMake(0, 0);
    [gradientLayer setColors:[NSArray arrayWithArray:colors]];
    
    NSMutableArray *colors1 = [NSMutableArray arrayWithObjects:(id)[RGBAColor(255, 255, 255, 0.5) CGColor],(id)[[UIColor whiteColor] CGColor], nil];
    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.shadowPath = bezierPath.CGPath;
    gradientLayer1.frame = CGRectMake(0, 30, 60, 30);
    gradientLayer1.startPoint = CGPointMake(0, 1);
    gradientLayer1.endPoint = CGPointMake(1, 1);
    [gradientLayer1 setColors:[NSArray arrayWithArray:colors1]];
    [self.circlelayer addSublayer:gradientLayer]; //设置颜色渐变
    [self.circlelayer addSublayer:gradientLayer1];
    
    
}

 - (void)animation {
    //动画
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotationAnimation.toValue = [NSNumber numberWithFloat:2.0*M_PI];
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.duration = 1;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.circlelayer addAnimation:rotationAnimation forKey:@"rotationAnnimation"];
}

@end
