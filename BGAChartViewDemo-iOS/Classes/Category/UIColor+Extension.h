//
//  UIColor+Extension.h
//  BGAChartViewDemo-iOS
//
//  Created by bingoogol on 15/6/12.
//  Copyright (c) 2015年 bingoogolapple. All rights reserved.
//

#import <UIKit/UIKit.h>

// RGBA颜色
#define RGBA(r,g,b,a) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0])
// RGB颜色
#define RGB(r,g,b) (RGBA((r),(g),(b),255))
// 随机色
#define RandomColor (RGB(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256)))

@interface UIColor (Extension)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

@end