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
    UIView *maskView;
    UIView *backGroundView;
    CGRect begainRect;
    CGRect targetRect;
}
@end

@implementation JYCAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isShowMask = YES;
        self.isAnimation = YES;
        [self addAllViews];
    }
    return self;
}

- (void)addAllViews
{
    self.backgroundColor = [UIColor clearColor];
    
    maskView = [[UIView alloc] initWithFrame:self.bounds];
    maskView.alpha = 0.0f;
    maskView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewDidClick)];
    [maskView addGestureRecognizer:tapGR];
    [self addSubview:maskView];
    
}

- (void)showJYCAlertView
{
    switch (self.animationType) {
        case JYCAlertViewAnimationTypeFadeInAndFadeOut:
            [self viewFadeIn];
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
        maskView.alpha = self.maskAlpha;
        backGroundView.alpha = 1.f;
    }];
}

- (void)viewFadeOutWithComplete:(void (^)(BOOL))complete
{
    [UIView animateWithDuration:self.showAnimationDuration animations:^{
        maskView.alpha = 0.0f;
        backGroundView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        maskView = nil;
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
    backGroundView.alpha = 1.0f;
    backGroundView.frame = begainRect;
    if (!backGroundView.superview) {
        [self addSubview:backGroundView];
    }
    [UIView animateWithDuration:self.showAnimationDuration animations:^{
        maskView.alpha = self.maskAlpha;
        backGroundView.frame = targetRect;
    }];
}

- (void)slipOutWithComplete:(void (^)(BOOL))complete
{
    if (!backGroundView) {
        return;
    }
    [UIView animateWithDuration:self.showAnimationDuration animations:^{
        maskView.alpha = 0.0f;
        backGroundView.frame = begainRect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        maskView = nil;
        backGroundView = nil;
        if (complete) {
            complete(finished);
        }
    }];
}


#pragma mark --重写set和get
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

- (void)setBGColor:(UIColor *)BGColor
{
    _BGColor = BGColor;
    if (![maskView.backgroundColor isEqual:BGColor]) {
        maskView.backgroundColor = BGColor;
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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
