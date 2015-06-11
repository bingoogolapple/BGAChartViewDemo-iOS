//
//  UIColor+Extension.m
//  BGAChartViewDemo-iOS
//
//  Created by bingoogol on 15/6/12.
//  Copyright (c) 2015年 bingoogolapple. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return RandomColor;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6 && cString.length != 8)
        return RandomColor;
    
    unsigned int r, g, b, a;
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *rString;
    NSString *gString;
    NSString *bString;
    if (cString.length == 6) {
        rString = [cString substringWithRange:range];
        
        range.location = 2;
        gString = [cString substringWithRange:range];
        
        range.location = 4;
        bString = [cString substringWithRange:range];
        
        a = 255;
    } else {
        NSString *aString = [cString substringWithRange:range];
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
        
        range.location = 2;
        rString = [cString substringWithRange:range];
        
        range.location = 4;
        gString = [cString substringWithRange:range];
        
        range.location = 6;
        bString = [cString substringWithRange:range];
    }
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return RGBA(r, g, b, a);
}

@end