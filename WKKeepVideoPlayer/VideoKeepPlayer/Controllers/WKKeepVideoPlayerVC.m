//
//  WKKeepVideoPlayer.m
//  WKKeepVideoPlayerDemo
//
//  Created by liuwenkai on 2021/8/20.
//

#import "WKKeepVideoPlayerVC.h"
#import "WKVieoPlayerContainerView.h"

@interface WKKeepVideoPlayerVC ()
@property (nonatomic, strong) UIButton *closeBtn;
@end

@implementation WKKeepVideoPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    WKVieoPlayerContainerView *vpcView = [[WKVieoPlayerContainerView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:vpcView];
    [self.view addSubview:self.closeBtn];
    vpcView.videoModelArr = self.videoArr;

}

- (void)closeVideo{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton *)closeBtn
{
    if (_closeBtn == nil) {
        _closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 55, 50, 45, 45)];
        [_closeBtn setImage:[UIImage imageNamed:@"closeVideo"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeVideo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
