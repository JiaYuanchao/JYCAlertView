//
//  JYCAlertView.m
//  JYCAlertView
//
//  Created by 贾远潮 on 2017/4/10.
//  Copyright © 2017年 jiayuanchao. All rights reserved.
//

#import "JYCAlertView.h"

#define kAnimationDuration 0.5f

@interface JYCAlertView ()
{
    UIView *backGroundView;
    CGRect begainRect;
    CGRect targetRect;
}

@property (nonatomic, strong) UIView *maskView;

@end

@implementation JYCAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isShowMask = YES;
        self.isAnimation = YES;
        self.isBlur = NO;
        self.backgroundColor = [UIColor clearColor];
        [self addAllViews];
    }
    return self;
}

- (void)addAllViews
{
    [self addSubview:self.maskView];
}

- (void)showJYCAlertView
{
    switch (self.animationType) {
        case JYCAlertViewAnimationTypeFadeInAndFadeOut:
            [self viewFadeIn];
            break;
        case JYCAlertViewAnimationTypeScale:
            [self viewScaleIn];
            break;
        case JYCAlertViewAnimationTypeTop:
        case JYCAlertViewAnimationTypeLeft:
        case JYCAlertViewAnimationTypeBottom:
        case JYCAlertViewAnimationTypeRight:
            [self slipIntoWithPosition:self.animationType];
            break;
        default:
            break;
    }
}

- (void)dismissJYCAlertViewWithCompletion:(void (^)(BOOL))completion
{
    switch (self.animationType) {
        case JYCAlertViewAnimationTypeFadeInAndFadeOut:
            [self viewFadeOutWithComplete:completion];
            break;
        case JYCAlertViewAnimationTypeTop:
        case JYCAlertViewAnimationTypeLeft:
        case JYCAlertViewAnimationTypeBottom:
        case JYCAlertViewAnimationTypeRight:
            [self slipOutWithComplete:completion];
            break;
        case JYCAlertViewAnimationTypeScale:
            [self viewScaleOutWithComplete:completion];
            break;
        default:
            break;
    }
}

- (void)maskViewDidClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(JYCAlertView:MaskViewDidClick:)]) {
        [self.delegate JYCAlertView:self MaskViewDidClick:YES];
    }
}


#pragma mark -- 动画效果

#pragma mark 淡入淡出
- (void)viewFadeIn
{
    backGroundView.alpha = 0.0f;
    if (!backGroundView.superview) {
        [self addSubview:backGroundView];
    }
    [UIView animateWithDuration:self.showAnimationDuration animations:^{
        self.maskView.alpha = self.maskAlpha;
        backGroundView.alpha = self.contentViewAlpha;
    }];
}

- (void)viewFadeOutWithComplete:(void (^)(BOOL))complete
{
    [UIView animateWithDuration:self.showAnimationDuration animations:^{
        self.maskView.alpha = 0.0f;
        backGroundView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.maskView = nil;
        backGroundView = nil;
        if (complete) {
            complete(finished);
        }
    }];
}

#pragma mark 滑入
- (void)slipIntoWithPosition:(JYCAlertViewAnimationType)animationPosition
{
    if (!backGroundView) {
        return;
    }
    CGFloat viewX = targetRect.origin.x;
    CGFloat viewY = targetRect.origin.y;
    CGFloat viewWidth = targetRect.size.width;
    CGFloat viewHeight = targetRect.size.height;
    switch (animationPosition) {
        case JYCAlertViewAnimationTypeTop:
            begainRect = CGRectMake(viewX, -viewHeight, viewWidth, viewHeight);
            break;
        case JYCAlertViewAnimationTypeLeft:
            begainRect = CGRectMake(-viewWidth, viewY, viewWidth, viewHeight);
            break;
        case JYCAlertViewAnimationTypeBottom:
            begainRect = CGRectMake(viewX, self.bounds.size.height, viewWidth, viewHeight);
            break;
        case JYCAlertViewAnimationTypeRight:
            begainRect = CGRectMake(viewWidth, viewY, viewWidth, viewHeight);
            break;
        default:
            break;
    }
    backGroundView.alpha = self.contentViewAlpha;
    backGroundView.frame = begainRect;
    if (!backGroundView.superview) {
        [self addSubview:backGroundView];
    }
    [UIView animateWithDuration:self.showAnimationDuration animations:^{
        self.maskView.alpha = self.maskAlpha;
        backGroundView.frame = targetRect;
    }];
}

- (void)slipOutWithComplete:(void (^)(BOOL))complete
{
    if (!backGroundView) {
        return;
    }
    [UIView animateWithDuration:self.showAnimationDuration animations:^{
        self.maskView.alpha = 0.0f;
        backGroundView.frame = begainRect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.maskView = nil;
        backGroundView = nil;
        if (complete) {
            complete(finished);
        }
    }];
}

#pragma mark -- 缩放动画
- (void)viewScaleIn
{
    backGroundView.alpha = 0.5f;
    backGroundView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    if (!backGroundView.superview) {
        [self addSubview:backGroundView];
    }
    [UIView animateWithDuration:self.showAnimationDuration animations:^{
        self.maskView.alpha = self.maskAlpha;
        backGroundView.transform = CGAffineTransformMakeScale(1, 1);
        backGroundView.alpha = self.contentViewAlpha;
    }];
}

- (void)viewScaleOutWithComplete:(void (^)(BOOL))complete
{
    [UIView animateWithDuration:self.showAnimationDuration animations:^{
        self.maskView.alpha = 0.0f;
        backGroundView.alpha = 0.0f;
        backGroundView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.maskView = nil;
        backGroundView = nil;
        if (complete) {
            complete(finished);
        }
    }];
}

#pragma mark -重新加载数据
/**
 重新加载数据
 */
- (void)reloadData
{
    [backGroundView removeFromSuperview];
    backGroundView = nil;
    self.datasource = _datasource;
}

#pragma mark --重写set和get

- (void)setIsBlur:(BOOL)isBlur
{
    _isBlur = isBlur;
    if (isBlur && _maskView && _maskView.subviews.count < 1) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = self.maskView.bounds;
        [self.maskView addSubview:effectView];
    } else if (_maskView.subviews.count > 0){
        [self.maskView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

- (CGFloat)showAnimationDuration
{
    if (!self.isAnimation) {
        return 0;
    }
    if (_showAnimationDuration <= 0) {
        _showAnimationDuration = kAnimationDuration;
    }
    return _showAnimationDuration;
}

- (CGFloat)maskAlpha
{
    if (!self.isShowMask) {
        return 0;
    }
    if (_maskAlpha <= 0 || _maskAlpha > 1) {
        _maskAlpha = 0.5;
    }
    return _maskAlpha;
}

- (CGFloat)contentViewAlpha
{
    if (_contentViewAlpha <= 0 || _contentViewAlpha > 1) {
        _contentViewAlpha = 1;
    }
    return _contentViewAlpha;
}

- (void)setBGColor:(UIColor *)BGColor
{
    _BGColor = BGColor;
    if (![self.maskView.backgroundColor isEqual:BGColor]) {
        self.maskView.backgroundColor = BGColor;
    }
}

- (void)setAnimationType:(JYCAlertViewAnimationType)animationType
{
    _animationType = animationType;
}


- (void)setDatasource:(id<JYCAlertViewDatasource>)datasource
{
    _datasource = datasource;
    if (self.datasource && [self.datasource respondsToSelector:@selector(JYCAlertView:)]) {
        if (!backGroundView) {
            backGroundView = [self.datasource JYCAlertView:self];
            targetRect = backGroundView.frame;
        }
    }
}

#pragma mark--lazy

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.alpha = 0.0f;
        _maskView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewDidClick)];
        [_maskView addGestureRecognizer:tapGR];
    }
    return _maskView;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
