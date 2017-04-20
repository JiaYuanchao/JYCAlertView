//
//  JYCViewController.m
//  JYCAlertView
//
//  Created by jiayuanchao on 04/10/2017.
//  Copyright (c) 2017 jiayuanchao. All rights reserved.
//

#import "JYCViewController.h"

#import "JYCAlertView.h"

@interface JYCViewController ()<JYCAlertViewDatasource,JYCAlertViewDelegate>

@property (nonatomic, strong) JYCAlertView *alertView;

@end

@implementation JYCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, 200, 50)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}

- (void)show
{
    [self.view addSubview:self.alertView];
    
    [self.alertView showJYCAlertView];
    
}

- (JYCAlertView *)alertView
{
    if (!_alertView) {
        _alertView = [[JYCAlertView alloc] initWithFrame:self.view.bounds];
        _alertView.datasource = self;
        _alertView.delegate = self;
        _alertView.showAnimationDuration = 0.25;
        _alertView.BGColor = [UIColor blackColor];
        _alertView.maskAlpha = 0.5;
        _alertView.animationType = JYCAlertViewAnimationTypeRight;
    }
    return _alertView;
}

- (UIView *)JYCAlertView:(JYCAlertView *)alertView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 300, [UIScreen mainScreen].bounds.size.width, 300)];
    view.backgroundColor = [UIColor redColor];
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [view addGestureRecognizer:tapGR];
    return view;
}

- (void)JYCAlertView:(JYCAlertView *)alertView MaskViewDidClick:(BOOL)isClick
{
    if (isClick) {
        [self dismiss];
    }
}

- (void)dismiss
{
    [self.alertView dismissJYCAlertViewWithCompletion:^(BOOL finish) {
        self.alertView = nil;
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
