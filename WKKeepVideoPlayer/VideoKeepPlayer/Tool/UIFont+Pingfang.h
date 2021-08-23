//
//  UIFont+Pingfang.h
//  WKKeepVideoPlayer
//
//  Created by liuwenkai on 2021/8/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, FontWeightStyle) {
    FontWeightStyleMedium, // 中黑体
    FontWeightStyleSemibold, // 中粗体
    FontWeightStyleLight, // 细体
    FontWeightStyleUltralight, // 极细体
    FontWeightStyleRegular, // 常规体
    FontWeightStyleThin, // 纤细体
};

@interface UIFont (LHEx)
/**
 苹方字体
 
 @param fontWeight 字体粗细（字重)
 @param fontSize 字体大小
 @return 返回指定字重大小的苹方字体
 */
+ (UIFont *)pingFangSCWithWeight:(FontWeightStyle)fontWeight size:(CGFloat)fontSize;

@end

NS_ASSUME_NONNULL_END
