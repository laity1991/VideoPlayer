//
//  WKCustomSlider.h
//  healthVideo
//
//  Created by liuwenkai on 2021/6/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKCustomSlider : UIView
@property (nonatomic, strong) UIImageView *leftView;
@property (nonatomic, strong) UIImageView  *rightView;
@property (nonatomic, strong) UILabel *valueLabel;

- (void)setLeftViewFrame:(float)tempValue;
@end

NS_ASSUME_NONNULL_END
