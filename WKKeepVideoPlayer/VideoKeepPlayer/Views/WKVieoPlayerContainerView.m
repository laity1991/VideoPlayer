//
//  WKVieoPlayerContainerView.m
//  healthVideo
//
//  Created by liuwenkai on 2021/5/20.
//
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#import "WKVieoPlayerContainerView.h"
#import <AVKit/AVKit.h>
#import "NetworkSpeedMonitor.h"
#import "WKVideoBottomStripView.h"
#import "WKVideoModel.h"
#import "UIView+Toast.h"
#import "UIFont+Pingfang.h"
@interface WKVieoPlayerContainerView()<WKVideoBottomStripViewDelegate>
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) NetworkSpeedMonitor *speedMonitor;//网速监听
@property (nonatomic, strong) UILabel *speedTextLabel;//显示网速Label
@property (nonatomic, strong) WKVideoBottomStripView *toolsView;//工具条
@property (nonatomic, strong) id playbackObserver;//视频播放获取当前时间和视频整体时间监听器
@property (nonatomic, assign) BOOL buffered;//是否缓冲完毕
@property (nonatomic, strong) UIProgressView *bufferPV;//下载视频的缓冲条
@property (nonatomic, strong) UILabel *timeLabel;//视频播放时间展示

//@property (nonatomic, strong) LHCustomSlider *slider;//视频播放进度条
@property (nonatomic, assign) NSInteger currentVideoPage;//当前播放视频位置
@property (nonatomic, strong) UILabel *currentVideoLabel;// 当前视频数/总视频数
@property (nonatomic, strong) UILabel *videoDesLabel;//视频名称
@property (nonatomic, assign) BOOL isFinished;//是否完成视频播放
@end


@implementation WKVieoPlayerContainerView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        [self.layer addSublayer:self.playerLayer];
        [self addSubview:self.speedTextLabel];
        [self addSubview:self.toolsView];
        [self addSubview:self.bufferPV];
        [self addSubview:self.timeLabel];
        [self addSubview:self.currentVideoLabel];
        [self addSubview:self.videoDesLabel];
    }
    return self;
}



#pragma mark - 设置单个播放地址
- (void)setVideoUrl:(NSString *)videoUrl{
    [self.player seekToTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player play];//开始播放视频
    [self.speedMonitor startNetworkSpeedMonitor];//开始监听网速
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkSpeedChanged:) name:NetworkDownloadSpeedNotificationKey object:nil];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:[AVAsset assetWithURL:[NSURL URLWithString:videoUrl]]];
    [self vpc_addObserverToPlayerItem:item];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.player replaceCurrentItemWithPlayerItem:item];
        [self vpc_playerItemAddNotification];
    });
}

#pragma mark - 设置多个播放地址
- (void)setVideoModelArr:(NSArray *)videoModelArr{
    _videoModelArr = videoModelArr;
    self.currentVideoPage = 0;
    self.currentVideoLabel.text = [NSString stringWithFormat:@"1/%ld",self.videoModelArr.count];
    WKVideoModel *model = [videoModelArr firstObject];
    self.videoDesLabel.text = model.name;
    [self.player seekToTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player play];//开始播放视频
    [self.speedMonitor startNetworkSpeedMonitor];//开始监听网速
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkSpeedChanged:) name:NetworkDownloadSpeedNotificationKey object:nil];
  
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:[AVAsset assetWithURL:[NSURL fileURLWithPath:model.url]]];
    [self vpc_addObserverToPlayerItem:item];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.player replaceCurrentItemWithPlayerItem:item];
        [self vpc_playerItemAddNotification];
    });
}

#pragma mark - 网络速度监听
- (void)networkSpeedChanged:(NSNotification *)sender{
    NSString *downloadSpeed = [sender.userInfo objectForKey:NetworkSpeedNotificationKey];
    self.speedTextLabel.text = downloadSpeed;
}

#pragma mark - 工具条
- (WKVideoBottomStripView *)toolsView
{
    if (_toolsView == nil) {
        _toolsView = [[WKVideoBottomStripView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 80, CGRectGetWidth(self.frame), 80)];
        _toolsView.delegate = self;
        [_toolsView.progressSlider addTarget:self action:@selector(vpc_sliderTouchBegin:) forControlEvents:UIControlEventTouchDown];
        [_toolsView.progressSlider addTarget:self action:@selector(vpc_sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_toolsView.progressSlider addTarget:self action:@selector(vpc_sliderTouchEnd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toolsView;
}

//进度条点击
- (void)vpc_sliderTouchBegin:(UISlider *)sender {
    [self.player pause];
}

//进度条进度改变
- (void)vpc_sliderValueChanged:(UISlider *)sender {
    
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * _toolsView.progressSlider.value;
    NSInteger currentMin = currentTime / 60;
    NSInteger currentSec = (NSInteger)currentTime % 60;
    _toolsView.lTime.text = [NSString stringWithFormat:@"%02ld:%02ld",currentMin,currentSec];
}

//进度条点击完成 快进到选择的时间点
- (void)vpc_sliderTouchEnd:(UISlider *)sender {
    
    NSTimeInterval slideTime = CMTimeGetSeconds(self.player.currentItem.duration) * _toolsView.progressSlider.value;
    if (slideTime == CMTimeGetSeconds(self.player.currentItem.duration)) {
        //        slideTime -= 0.5;
    }
    [self.player seekToTime:CMTimeMakeWithSeconds(slideTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player play];
    
}

#pragma mark - WKVideoBottomStripViewDelegate 开启关闭视频
- (void)playButtonWithStates:(BOOL)state{
    if (state) {
        [self.player pause];
    }else{
        [self.player play];
    }
}

#pragma mark - WKVideoBottomStripViewDelegate 上个视频
- (void)previousVideo{
    self.isFinished = NO;
    if (self.currentVideoPage == 0) {
        [self makeToast:@"已经是第一条视频" duration:0.5 position:CSToastPositionCenter];
    }else{
        self.currentVideoPage--;
        WKVideoModel *model = [self.videoModelArr objectAtIndex:self.currentVideoPage];
         [self changeVidoSource:model.url];
        self.currentVideoLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.currentVideoPage+1,self.videoModelArr.count];
        self.videoDesLabel.text = model.name;
    }
    NSLog(@"self.currentVideoPage:%ld",self.currentVideoPage);
}

#pragma mark - WKVideoBottomStripViewDelegate 下个视频
- (void)nextVideo{
    
    if (self.currentVideoPage < self.videoModelArr.count - 1) {
        self.currentVideoPage++;
        WKVideoModel *model = [self.videoModelArr objectAtIndex:self.currentVideoPage];
        [self changeVidoSource:model.url];
        self.currentVideoLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.currentVideoPage+1,self.videoModelArr.count];
        self.videoDesLabel.text = model.name;
    }else{
        if (self.isFinished) {
            [self makeToast:@"锻炼完成" duration:0.5 position:CSToastPositionCenter];
        }else{
            [self makeToast:@"已经是最后一条视频" duration:0.5 position:CSToastPositionCenter];
        }
        
    }
    NSLog(@"self.currentVideoPage:%ld",self.currentVideoPage);
}

#pragma mark - 切换视频播放源
- (void)changeVidoSource:(NSString *)urlStr{
    /*** 移除通知 、观察者***/
    [self.speedMonitor stopNetworkSpeedMonitor];//停止网速监听
//    [self.bufferPV setProgress:0];//视频缓存条变成0
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NetworkDownloadSpeedNotificationKey object:nil];//移除下载监听
    [self.player removeTimeObserver:self.playbackObserver];//移除视频播放获取当前时间和视频整体时间监听器
    [self vpc_playerItemRemoveObserver]; //移除播放状态、缓冲进度监听器
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除播放完成通知
    /*** 重置播放器 ***/
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:[AVAsset assetWithURL:[NSURL fileURLWithPath:urlStr]]];
    [self.playerLayer removeFromSuperlayer];
    [self.bufferPV removeFromSuperview];
    [self.speedTextLabel removeFromSuperview];
    [self.timeLabel removeFromSuperview];
    [self.toolsView removeFromSuperview];
    [self.currentVideoLabel removeFromSuperview];
    [self.videoDesLabel removeFromSuperview];
    self.videoDesLabel = nil;
    self.currentVideoLabel = nil;
    self.playerLayer = nil;
    self.player = nil;
    self.speedTextLabel = nil;
    self.toolsView = nil;
    self.bufferPV = nil;
    self.timeLabel = nil;
    [self.layer addSublayer:self.playerLayer];
    [self addSubview:self.speedTextLabel];
    [self addSubview:self.toolsView];
    [self addSubview:self.bufferPV];
    [self addSubview:self.timeLabel];
    [self addSubview:self.currentVideoLabel];
    [self addSubview:self.videoDesLabel];
    [self.player seekToTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player play];//开始播放视频
    [self.speedMonitor startNetworkSpeedMonitor];//开始监听网速
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkSpeedChanged:) name:NetworkDownloadSpeedNotificationKey object:nil];
    [self vpc_addObserverToPlayerItem:item];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.player replaceCurrentItemWithPlayerItem:item];
        [self vpc_playerItemAddNotification];
    });
}

#pragma mark - 网络监听器
- (NetworkSpeedMonitor *)speedMonitor
{
    if (_speedMonitor == nil) {
        _speedMonitor = [[NetworkSpeedMonitor alloc]init];
    }
    return _speedMonitor;
}

#pragma mark - 显示网速label
- (UILabel *)speedTextLabel
{
    if (_speedTextLabel == nil) {
        _speedTextLabel = [UILabel new];
        _speedTextLabel.frame = CGRectMake(0, 30, 0, 20);
        _speedTextLabel.textColor = [UIColor whiteColor];
        _speedTextLabel.font = [UIFont systemFontOfSize:12.0];
        _speedTextLabel.textAlignment = NSTextAlignmentCenter;
        _speedTextLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _speedTextLabel;
}

#pragma mark -AVPlayer
- (AVPlayer *)player
{
    if (_player == nil) {
        _player = [[AVPlayer alloc]init];
        __weak typeof(self) weakSelf = self;
        //        CMTime CMTimeMake (
        //           int64_t value,    //表示 当前视频播放到的第几桢数
        //           int32_t timescale //每秒的帧数
        //        );
        //        //视频播放获取当前时间和视频整体时间 每1/20秒回调一次 直至视频播放完成
        self.playbackObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 25) queue:NULL usingBlock:^(CMTime time) {
            [weakSelf vpc_setTimeLabel];
            NSTimeInterval totalTime = CMTimeGetSeconds(weakSelf.player.currentItem.duration);//总时长
            NSTimeInterval currentTime = time.value / time.timescale;//当前时间进度
            weakSelf.toolsView.progressSlider.value = currentTime / totalTime;
            
            }];
    }
    return _player;
}

#pragma mark - AVPlayerLayer
-(AVPlayerLayer *)playerLayer{
    
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//播放器layer占满整个屏幕
    }
    return _playerLayer;
    
}

#pragma mark - 缓冲条 下载视频进度条
-(UIProgressView *)bufferPV{
    
    if (!_bufferPV) {
        _bufferPV = [UIProgressView new];
        _bufferPV.frame = CGRectMake(0, 30,0, 4);
        _bufferPV.trackTintColor = [UIColor grayColor];
        _bufferPV.progressTintColor = [UIColor cyanColor];
    }
    return _bufferPV;
    
}

#pragma mark - lTime
- (void)vpc_setTimeLabel {
    
    NSTimeInterval totalTime = CMTimeGetSeconds(self.player.currentItem.duration);//总时长
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);//当前时间进度
    double scale = currentTime / totalTime;//当前时间比总时长
    // 切换视频源时totalTime/currentTime的值会出现nan导致时间错乱  nan  not a number 出现了不是数字的情况
    if (isnan(scale)) {
        scale = 0;
    }
//    NSLog(@"视频currentTime / totalTime：%f ----%f----%f",scale,totalTime,currentTime);
    


    [self.toolsView.slider setLeftViewFrame:scale];
//    NSInteger totalMin = totalTime / 60;
//    NSInteger totalSec = (NSInteger)totalTime % 60;
//    NSString *totalTimeStr = [NSString stringWithFormat:@"%02ld:%02ld",totalMin,totalSec];

    NSInteger currentMin = currentTime / 60;
    NSInteger currentSec = (NSInteger)currentTime % 60;
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02ld:%02ld",currentMin,currentSec];

//    _toolsView.lTime.text = [NSString stringWithFormat:@"%@/%@",currentTimeStr,totalTimeStr];
    self.timeLabel.text = currentTimeStr;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text = @"00:00";
        _timeLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleSemibold size:30];
        _timeLabel.frame = CGRectMake(10, 50, 100, 50);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = UIColorFromRGB(0x999999, 1);
    }
    return _timeLabel;
}

#pragma mark - 当前视频所在视频数组位置
- (UILabel *)currentVideoLabel
{
    if (_currentVideoLabel == nil) {
        _currentVideoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, ScreenHeight-220, 200, 80)];
        _currentVideoLabel.textAlignment = NSTextAlignmentLeft;
        _currentVideoLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleSemibold size:70];
    }
    return _currentVideoLabel;
}

- (UILabel *)videoDesLabel
{
    if (_videoDesLabel == nil) {
        _videoDesLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(self.currentVideoLabel.frame), 100, 40)];
        _videoDesLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:15];
        _videoDesLabel.textColor = UIColorFromRGB(0x333333, 1);
    }
    return _videoDesLabel;
}

#pragma mark - 播放完成通知通知
- (void)vpc_playerItemAddNotification{
    // 播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vpc_playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

-(void)vpc_playbackFinished:(NSNotification *)noti{
    [self.player pause];
    NSLog(@"播放完成");
    //下个视频
    [self nextVideo];
    if (self.currentVideoPage == self.videoModelArr.count - 1) {
        self.isFinished = YES;
    }
}

#pragma mark - 监听播放状态 监听缓冲进度
- (void)vpc_addObserverToPlayerItem:(AVPlayerItem *)playerItem {
    // 监听播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 监听缓冲进度
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - 移除各种监听通知
- (void)vpc_playerItemRemoveNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)vpc_playerItemRemoveObserver {
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            [self vpc_setTimeLabel];
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *array = self.player.currentItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);//本次缓冲起始时间
        NSTimeInterval durationSeconds = CMTimeGetSeconds(timeRange.duration);//缓冲时间
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        float totalTime = CMTimeGetSeconds(self.player.currentItem.duration);//视频总长度
        float progress = totalBuffer/totalTime;//缓冲进度
        NSLog(@"progress = %lf---totalBuffer:%lf----totalTime:%lf",progress,totalBuffer,totalTime);
//        if (isnan(progress)) {
//            [self.bufferPV removeFromSuperview];
//            [self.speedTextLabel removeFromSuperview];
//        }
        //如果缓冲完了，拖动进度条不需要重新显示缓冲条
//            if (progress == 1.000000) {
               
//            }
        [self.bufferPV setProgress:progress];
        [self.bufferPV removeFromSuperview];
        [self.speedTextLabel removeFromSuperview];
        
    }
}

- (void)dealloc {
    
    [self.speedMonitor stopNetworkSpeedMonitor];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NetworkDownloadSpeedNotificationKey object:nil];
    
    [self.player removeTimeObserver:self.playbackObserver];
    [self vpc_playerItemRemoveObserver];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
