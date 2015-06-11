//
//  BGABarChartView.m
//  BGAChartViewDemo-iOS
//
//  Created by bingoogol on 15/6/11.
//  Copyright (c) 2015年 bingoogolapple. All rights reserved.
//

#import "BGABarChartView.h"
#import "NSString+Extension.h"
#import "UIColor+Extension.h"

#define BAR_CHART_COUNT_X 14
#define BAR_CHART_MAX_VALUE 500
#define BAR_CHART_XAXIS_TEXTSIZE [UIFont systemFontOfSize:12]
#define BAR_CHART_TIP_TEXTSIZE [UIFont systemFontOfSize:10]

@interface BGABarChartView()

@property (nonatomic, strong) NSArray *type1Arr;
@property (nonatomic, strong) NSArray *type2Arr;

@property (nonatomic, assign) CGFloat maxScaleValue;
@property (nonatomic, assign) CGFloat yaxisLenght;
/** 原点坐标 */
@property (nonatomic, assign) CGPoint zeroP;
/** 每一个柱形的宽度 */
@property (nonatomic, assign) CGFloat xScale;
/** 当前的值与实际值的比例 */
@property (nonatomic, assign) CGFloat currentValueRatio;
/** x轴刻度文本的宽度 */
@property (nonatomic, assign) CGFloat axisTextW;


@property (nonatomic, strong) NSDictionary *xAxisScakeTextAttr;
@property (nonatomic, strong) NSDictionary *type1TipTextAttr;
@property (nonatomic, strong) NSDictionary *type2TipTextAttr;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BGABarChartView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.0f;
        _xEdge = 2;
        _xWhiteWidth = 10;
        _yScale = 22;
        
        _currentValueRatio = 0.0f;
        
        _type1BarColor = [UIColor colorWithHexString:@"#9938D369"];
        _type2BarColor = [UIColor colorWithHexString:@"99B6EFFE"];
        
        self.type1TipTextColor = [UIColor colorWithHexString:@"#1CBE53"];
        self.type2TipTextColor = [UIColor colorWithHexString:@"60BAFB"];
        
        self.axisScaleTextColor = [UIColor colorWithHexString:@"99054D61"];
        
        _axisColor = [UIColor colorWithHexString:@"054D61"];
    }
    return self;
}

- (void)setAxisScaleTextColor:(UIColor *)axisScaleTextColor {
    _axisScaleTextColor = axisScaleTextColor;
    _xAxisScakeTextAttr = @{NSFontAttributeName:BAR_CHART_XAXIS_TEXTSIZE,NSForegroundColorAttributeName:_axisScaleTextColor};
}

-(void)setType1TipTextColor:(UIColor *)type1TipTextColor {
    _type1TipTextColor = type1TipTextColor;
    _type1TipTextAttr = @{NSFontAttributeName:BAR_CHART_TIP_TEXTSIZE,NSForegroundColorAttributeName:_type1TipTextColor};
}

- (void)setType2TipTextColor:(UIColor *)type2TipTextColor {
    _type2TipTextColor = type2TipTextColor;
    _type2TipTextAttr = @{NSFontAttributeName:BAR_CHART_TIP_TEXTSIZE,NSForegroundColorAttributeName:_type2TipTextColor};
}

- (void)drawRect:(CGRect)rect {
    _xScale = (rect.size.width - _xWhiteWidth * 6 - _xEdge * 2) / BAR_CHART_COUNT_X;
    _zeroP = CGPointMake(_xEdge, rect.size.height - _yScale) ;
    _yaxisLenght = _zeroP.y - _yScale;
    _axisTextW = [NSString sizeWithText:@"12-12" font:BAR_CHART_XAXIS_TEXTSIZE].width;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self drawHorizontalLine:rect context:ctx];
    [self drawXAxisText:rect context:ctx];
    [self drawBar:rect context:ctx];
}

- (void)drawHorizontalLine:(CGRect)rect context:(CGContextRef)ctx {
    [_axisColor setStroke];
    CGContextSetLineWidth(ctx, 0.3);
    
    // 画x轴
    CGContextMoveToPoint(ctx, 0, _zeroP.y);
    CGContextAddLineToPoint(ctx, rect.size.width, _zeroP.y);
    CGContextStrokePath(ctx);
    
    // 画虚线
    CGFloat lengths[] = {1,1};
    CGContextSetLineDash(ctx, 0, lengths, 2);
    for (int i = 1; i <= BAR_CHART_COUNT_Y; i++) {
        CGContextMoveToPoint(ctx, 0, _zeroP.y - i * _yScale);
        CGContextAddLineToPoint(ctx, rect.size.width, _zeroP.y - i * _yScale);
        CGContextStrokePath(ctx);
    }
}

- (void)drawXAxisText:(CGRect)rect context:(CGContextRef)ctx {
    CGFloat textY = _zeroP.y + 7;
    for (int i = 0; i < 7; i++) {
        NSString *text = [self getXAxisLabelWithPreDay:7-i];
        CGFloat textX =  _xEdge + (2 * _xScale + _xWhiteWidth) * i + (2 * _xScale - _axisTextW) / 2;
        [text drawAtPoint:CGPointMake(textX, textY) withAttributes:_xAxisScakeTextAttr];
    }
}

- (NSString *) getXAxisLabelWithPreDay:(int)preDay {
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(preDay*24*60*60)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    return [dateFormatter stringFromDate:yesterday];
}

- (void)drawBar:(CGRect)rect context:(CGContextRef)ctx {
    if (_type1Arr && _type2Arr) {
        NSString *valueStr;
        CGFloat y;
        CGFloat h;
        CGFloat x = _xEdge;
        for (int i = 0; i < 7; i++) {
            // 绘制类型1
            [_type1TipTextColor setFill];
            id yValue = _type1Arr[i];
            h = (_yaxisLenght * [yValue floatValue] * _currentValueRatio) / _maxScaleValue;
            y = _zeroP.y - h;
            CGContextAddRect(ctx, CGRectMake(x, y, _xScale, h));
            CGContextFillPath(ctx);
            
            valueStr = [NSString stringWithFormat:@"%d", [[NSNumber numberWithFloat:[yValue floatValue] * _currentValueRatio] intValue]];
            [valueStr drawAtPoint:CGPointMake(x + (_xScale - [NSString sizeWithText:valueStr font:BAR_CHART_TIP_TEXTSIZE].width) / 2, y - 12) withAttributes:_type1TipTextAttr];
            // 绘制类型2
            [_type2TipTextColor setFill];
            yValue = _type2Arr[i];
            h = (_yaxisLenght * [yValue floatValue] * _currentValueRatio) / _maxScaleValue;
            y = _zeroP.y - h;
            CGContextAddRect(ctx, CGRectMake(x + _xScale, y, _xScale, h));
            CGContextFillPath(ctx);
            
            valueStr = [NSString stringWithFormat:@"%d", [[NSNumber numberWithFloat:[yValue floatValue] * _currentValueRatio] intValue]];
            [valueStr drawAtPoint:CGPointMake(x + _xScale + (_xScale - [NSString sizeWithText:valueStr font:BAR_CHART_TIP_TEXTSIZE].width) / 2, y - 12) withAttributes:_type2TipTextAttr];
            
            x = _xEdge + (_xScale * 2 + _xWhiteWidth) * (i + 1);
        }
    }
}

- (void)setType1Arr:(NSArray *)type1Arr type2Arr:(NSArray *)type2Arr {
    CGFloat maxValue = 0;
    for (id v in type1Arr) {
        float value=[v floatValue];
        maxValue = MAX(maxValue, value);
    }
    for (id v in type2Arr) {
        float value = [v floatValue];
        maxValue = MAX(maxValue, value);
    }
    
    _type1Arr = type1Arr;
    _type2Arr = type2Arr;
    [self setMaxScaleValue:maxValue];
    
    [self startAnim];
}

- (void)startAnim {
    _currentValueRatio = 0.0f;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGFloat currentStep = 0;
        // 线程睡眠50次
        CGFloat stepCount = 50;
        // 每一次currentValueRatio增加的值
        CGFloat stepScale = 1.0/stepCount;
        // 动画时间为1秒
        // 每次睡眠的时间
        CGFloat timeInterval = 1.0f/ stepCount;
        while (currentStep < stepCount) {
            _currentValueRatio += stepScale;
            [self postInvalidate];
            [NSThread sleepForTimeInterval:timeInterval];
            currentStep++;
        }
    });
}

/**
 *  在主线程调用setNeedsDisplay重绘
 */
- (void)postInvalidate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

- (void)setMaxScaleValue:(CGFloat)maxValue {
    if (maxValue <= 5) {
        _maxScaleValue = 5;
    } else if(maxValue <= 10) {
        _maxScaleValue = 10;
    } else if(maxValue <= 50) {
        _maxScaleValue = 50;
    } else if(maxValue <= 100) {
        _maxScaleValue = 100;
    } else {
        _maxScaleValue = BAR_CHART_MAX_VALUE;
    }
}

@end