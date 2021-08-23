//
//  WKVideoModel.h
//  WKKeepVideoPlayer
//
//  Created by liuwenkai on 2021/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKVideoModel : NSObject
@property (nonatomic, copy) NSString *duration;//视频时长(秒)
@property (nonatomic, copy) NSString *name;//视频名称
@property (nonatomic, copy) NSString *num;//视频序号
@property (nonatomic, copy) NSString *size;//视频大小(b)
@property (nonatomic, copy) NSString *thumbnail;//视频封面图地址
@property (nonatomic, copy) NSString *url;//视频下载地址
@end

NS_ASSUME_NONNULL_END
