//
//  WKVideoBottomStripView.m
//  healthVideo
//
//  Created by liuwenkai on 2021/5/20.
//


#import "WKVideoBottomStripView.h"
#import "WKCustomSlider.h"

@implementation WKVideoBottomStripView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.greenColor;
        [self prepareForUI];
    }
    return self;
}

- (void)prepareForUI{
    self.slider = [[WKCustomSlider alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width , self.frame.size.height)];
    [self addSubview:self.slider];
    [self addSubview:self.bCheck];//开始暂停按钮
    [self addSubview:self.preBtn];//上一个视频按钮
    [self addSubview:self.nextBtn];//下一个视频按钮
//    [self addSubview:self.progressSlider];//创建进度条
//    [self addSubview:self.lTime];//视频时间
}

#pragma mark - 视频时间
-(UILabel *)lTime{
    
    if (!_lTime) {
        _lTime = [UILabel new];
        _lTime.frame = CGRectMake(CGRectGetMaxX(_progressSlider.frame)-5 , 0, 50, self.frame.size.height);
        _lTime.text = @"00:00/00:00";
        _lTime.textColor = [UIColor blackColor];
        _lTime.textAlignment = NSTextAlignmentCenter;
        _lTime.font = [UIFont systemFontOfSize:12];
        _lTime.adjustsFontSizeToFitWidth = YES;
    }
    return _lTime;
    
}

#pragma mark - 创建进度条
-(UISlider *)progressSlider{
    
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc]init];
        _progressSlider.frame = CGRectMake(220, CGRectGetMidY(_bCheck.frame), 120, 20);
        _progressSlider.maximumTrackTintColor = [UIColor redColor];
        _progressSlider.minimumTrackTintColor = [UIColor brownColor];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"point"] forState:0];
    }
    return _progressSlider;
    
}



#pragma mark - 开始暂停按钮
-(UIButton *)bCheck{
    
    if (!_bCheck) {
        _bCheck = [[UIButton alloc]init];
        _bCheck.frame = CGRectMake(self.frame.size.width/2 - self.frame.size.height/2,0, self.frame.size.height, self.frame.size.height);
        [_bCheck setImage:[UIImage imageNamed:@"play"] forState:0];
        [_bCheck addTarget:self action:@selector(btnCheckSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bCheck;
    
}

#pragma mark - 上一个视频按钮
- (UIButton *)preBtn
{
    if (_preBtn == nil) {
        _preBtn = [[UIButton alloc]init];
        _preBtn.frame = CGRectMake(0,0, self.frame.size.height, self.frame.size.height);
        [_preBtn setImage:[UIImage imageNamed:@"previousVideo"] forState:0];
        [_preBtn addTarget:self action:@selector(previousVideoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _preBtn;
}

#pragma mark - 下一个视频按钮
- (UIButton *)nextBtn
{
    if (_nextBtn == nil) {
        _nextBtn = [[UIButton alloc]init];
        _nextBtn.frame = CGRectMake(self.frame.size.width - self.frame.size.height,0, self.frame.size.height, self.frame.size.height);
        [_nextBtn setImage:[UIImage imageNamed:@"nextVideo"] forState:0];
        [_nextBtn addTarget:self action:@selector(nextVideoVideoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (void)previousVideoAction:(UIButton *)btn{
    NSLog(@"上一个视频按钮");
    [self.slider setLeftViewFrame:0];
    if ([self.delegate respondsToSelector:@selector(previousVideo)]) {
        [self.delegate previousVideo];
    }
}

- (void)nextVideoVideoAction:(UIButton *)btn{
    NSLog(@"下一个视频按钮");
    [self.slider setLeftViewFrame:0];
    if ([self.delegate respondsToSelector:@selector(nextVideo)]) {
        [self.delegate nextVideo];
    }
}

-(void)btnCheckSelect:(UIButton *)sender{
    
    sender.selected = !sender.isSelected;
    
    if (sender.selected) {
        [_bCheck setImage:[UIImage imageNamed:@"pause"] forState:0];
    }else{
        [_bCheck setImage:[UIImage imageNamed:@"play"] forState:0];
    }
    
    if ([_delegate respondsToSelector:@selector(playButtonWithStates:)]) {
        [_delegate playButtonWithStates:sender.selected];
    }
    
}

@end
