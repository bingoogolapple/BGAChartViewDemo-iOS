//
//  BGABarChartView.h
//  BGAChartViewDemo-iOS
//
//  Created by bingoogol on 15/6/11.
//  Copyright (c) 2015年 bingoogolapple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BAR_CHART_COUNT_Y 5

@interface BGABarChartView : UIView

@property (nonatomic, strong) UIColor *type1BarColor;
@property (nonatomic, strong) UIColor *type2BarColor;

@property (nonatomic, strong) UIColor *type1TipTextColor;
@property (nonatomic, strong) UIColor *type2TipTextColor;

@property (nonatomic, strong) UIColor *axisColor;
@property (nonatomic, strong) UIColor *axisScaleTextColor;

@property (nonatomic, assign) CGFloat xEdge;
@property (nonatomic, assign) CGFloat yScale;
@property (nonatomic, assign) CGFloat xWhiteWidth;

- (void)setType1Arr:(NSArray *)type1Arr type2Arr:(NSArray *)type2Arr;

@end