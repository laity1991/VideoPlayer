//
//  WKVieoPlayerContainerView.h
//  WKKeepVideoPlayer
//
//  Created by liuwenkai on 2021/8/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKVieoPlayerContainerView : UIView
@property (nonatomic, strong) NSString *videoUrl;//单个视频源
@property (nonatomic, strong) NSArray *videoModelArr;//多个视频源

- (void)dealloc;
@end

NS_ASSUME_NONNULL_END
