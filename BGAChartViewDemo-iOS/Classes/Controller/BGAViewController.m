//
//  BGAViewController.m
//  BGAChartViewDemo-iOS
//
//  Created by bingoogol on 15/6/11.
//  Copyright (c) 2015年 bingoogolapple. All rights reserved.
//

#import "BGAViewController.h"
#import "MBProgressHUD+MJ.h"
#import "BGABarChartView.h"
#import "UIColor+Extension.h"

@interface BGAViewController ()
@property (nonatomic, weak) BGABarChartView *barChartView;
@property (nonatomic, strong) NSArray *type1Arr;
@property (nonatomic, strong) NSArray *type2Arr;
@end

@implementation BGAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

- (void)setupView {
    UIButton *showAnimBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:showAnimBtn];
    [showAnimBtn setTitle:@"开始动画" forState:UIControlStateNormal];
    [showAnimBtn addTarget:self action:@selector(showAnim:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat animBtnW = 100;
    CGFloat animBtnH = 50;
    showAnimBtn.frame = CGRectMake((self.view.frame.size.width - animBtnW) / 2, 40, animBtnW, animBtnH);
    showAnimBtn.backgroundColor = RandomColor;
    
    
    
    BGABarChartView *barChartView = [[BGABarChartView alloc] init];
    [self.view addSubview:barChartView];
    _barChartView = barChartView;
    
    CGFloat barChartX = 15;
    CGFloat barChartW = self.view.bounds.size.width - barChartX * 2;
    
    barChartView.yScale = 30;
    CGFloat barChartH = barChartView.yScale * (BAR_CHART_COUNT_Y + 2);
    CGFloat barChartY = (self.view.bounds.size.height - barChartH) / 2;
    barChartView.frame = CGRectMake(barChartX, barChartY, barChartW, barChartH);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

/**
 *  模拟加载网络数据，睡两秒
 */
- (void)loadData {
    [MBProgressHUD showMessage:@"正在加载数据"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:2];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            _type1Arr = @[@23,@19,@19,@19,@17,@22,@16];
            _type2Arr = @[@18,@9,@27,@52,@28,@21,@44];
            [self fillData];
        });
    });
}

- (void)fillData {
    // 为柱状图设置数据，这里面已经包含了柱状y值动画
    [_barChartView setType1Arr:_type1Arr type2Arr:_type2Arr];
    // 先设置完全不透明，并且往下移40个像素
    _barChartView.alpha = 0.0f;
    _barChartView.transform = CGAffineTransformMakeTranslation(0, 40);
    // 再动画显示，并回到原来的位置
    [UIView animateWithDuration:1.0f animations:^{
        _barChartView.transform = CGAffineTransformIdentity;
        _barChartView.alpha = 1.0f;
    }];
}

- (void)showAnim:(UIButton *)btn {
    btn.backgroundColor = RandomColor;
    [self fillData];
}

@end
