//
//  WKVideoBottomStripView.h
//  healthVideo
//
//  Created by liuwenkai on 2021/5/20.
//
/*
 颜色 十六进制
 */
#define UIColorFromRGB(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
#import <UIKit/UIKit.h>
#import "WKCustomSlider.h"
NS_ASSUME_NONNULL_BEGIN

@protocol WKVideoBottomStripViewDelegate <NSObject>

/**
 开始暂停按钮点击回调
 */
- (void)playButtonWithStates:(BOOL)state;
/**
 上一个视频按钮回调
 */
- (void)previousVideo;
/**
 下一个视频按钮回调
 */
- (void)nextVideo;
@end

@interface WKVideoBottomStripView : UIView
@property (nonatomic, strong) UIButton *bCheck;//播放暂停按钮
@property (nonatomic, strong) UISlider *progressSlider;//播放视频的进度条
@property (nonatomic, strong) UILabel *lTime;//时间进度和总时长
@property (nonatomic, strong) WKCustomSlider *slider;//视频播放进度条
@property (nonatomic, weak) id<WKVideoBottomStripViewDelegate> delegate;
@property (nonatomic, strong) UIButton *preBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@end

NS_ASSUME_NONNULL_END
