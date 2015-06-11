//
//  NSString+Extension.m
//  BGAChartViewDemo-iOS
//
//  Created by bingoogol on 15/6/11.
//  Copyright (c) 2015年 bingoogolapple. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

//- (CGSize)sizeWithText:(NSString *)text font:(UIFont*)font {
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSFontAttributeName] = font;
//    return [text sizeWithAttributes:attrs];
//}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont*)font {
    return [self sizeWithText:text font:font maxWidth:MAXFLOAT];
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont*)font maxWidth:(CGFloat)maxWidth {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
