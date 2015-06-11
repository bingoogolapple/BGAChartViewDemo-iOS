//
//  NSString+Extension.h
//  BGAChartViewDemo-iOS
//
//  Created by bingoogol on 15/6/11.
//  Copyright (c) 2015年 bingoogolapple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont*)font;

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont*)font maxWidth:(CGFloat)maxWidth;

@end
