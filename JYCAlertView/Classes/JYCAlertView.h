//
//  JYCAlertView.h
//  JYCAlertView
//
//  Created by 贾远潮 on 2017/4/10.
//  Copyright © 2017年 jiayuanchao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JYCAlertViewAnimationType) {
    JYCAlertViewAnimationTypeFadeInAndFadeOut,  // 淡入淡出 默认
    
    JYCAlertViewAnimationTypeTop, // 顶部划出
    JYCAlertViewAnimationTypeBottom,  // 底部划出
    JYCAlertViewAnimationTypeLeft, // 左部划出
    JYCAlertViewAnimationTypeRight, // 右部划出
    
    JYCAlertViewAnimationTypeScale, // 缩放
};

@class JYCAlertView;

@protocol JYCAlertViewDatasource <NSObject>

- (UIView *)JYCAlertView:(JYCAlertView *)alertView;

@end

@protocol JYCAlertViewDelegate <NSObject>

- (void)JYCAlertView:(JYCAlertView *)alertView MaskViewDidClick:(BOOL)isClick;

@end

@interface JYCAlertView : UIView

/**
 是否使用模糊背景  默认不使用
 */
@property (nonatomic, assign) BOOL isBlur;

/**
 是否使用动画 默认使用
 */
@property (nonatomic, assign) BOOL isAnimation;
/**
 弹框展示的动画的时间 默认时间 0.5
 */
@property (nonatomic, assign) CGFloat showAnimationDuration;

/**
 是否展示背景遮罩 默认展示
 */
@property (nonatomic, assign) BOOL isShowMask;

/**
 背景遮罩的颜色
 */
@property (nonatomic, strong) UIColor *BGColor;

/**
 底部遮罩的透明度
 */
@property (nonatomic, assign) CGFloat maskAlpha;

/**
 弹框的透明度  默认是1
 */
@property (nonatomic, assign) CGFloat contentViewAlpha;

/**
 弹框动画效果
 */
@property (nonatomic, assign) JYCAlertViewAnimationType animationType;


/**
 数据源
 */
@property (nonatomic, assign) id<JYCAlertViewDatasource> datasource;


/**
 代理
 */
@property (nonatomic, weak) id<JYCAlertViewDelegate> delegate;


/**
 重新加载数据
 */
- (void)reloadData;

/**
 展示弹框
 */
- (void)showJYCAlertView;

/**
 弹框消失

 @param completion 弹框消失后用户需要做的事情
 */
- (void)dismissJYCAlertViewWithCompletion:(void(^)(BOOL finish))completion;


@end
