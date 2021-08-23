//
//  UIFont+Pingfang.m
//  WKKeepVideoPlayer
//
//  Created by liuwenkai on 2021/8/20.
//

#import "UIFont+Pingfang.h"

@implementation UIFont (LHEx)

+ (UIFont *)pingFangSCWithWeight:(FontWeightStyle)fontWeight size:(CGFloat)fontSize {
    if (fontWeight < FontWeightStyleMedium || fontWeight > FontWeightStyleThin) {
        fontWeight = FontWeightStyleRegular;
    }
    NSString *fontName = @"PingFangSC-Regular";
    switch (fontWeight) {
        case FontWeightStyleMedium:
            fontName = @"PingFangSC-Medium";
            break;
        case FontWeightStyleSemibold:
            fontName = @"PingFangSC-Semibold";
            break;
        case FontWeightStyleLight:
            fontName = @"PingFangSC-Light";
            break;
        case FontWeightStyleUltralight:
            fontName = @"PingFangSC-Ultralight";
            break;
        case FontWeightStyleRegular:
            fontName = @"PingFangSC-Regular";
            break;
        case FontWeightStyleThin:
            fontName = @"PingFangSC-Thin";
            break;
            
            
    }
    
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    
    return font ?: [UIFont systemFontOfSize:fontSize];
}
@end

