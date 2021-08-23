//
//  ViewController.m
//  WKKeepVideoPlayerDemo
//
//  Created by liuwenkai on 2021/8/20.
//
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "WKKeepVideoPlayerVC.h"
#import "WKVideoModel.h"
#import <MJExtension.h>
@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *videoModelArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*** 演示按钮 点击跳转视频播放界面 ***/
    [self prepareForUI];
    
   /*** 加载视频资源 ，Demo加载的本地视频资源 ，方便演示把示例资源放到了本地json文件中并转成模型使用 使用时可根据后端返回调整数据结构把对应视频下载资源url添加上，本框架为个人整理不涉及商用，如有问题联系QQ：815476562  ***/
    [self loadVideoSourceData];
   
}

- (void)loadVideoSourceData{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"videosArray.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
   self.videoModelArray = [WKVideoModel mj_objectArrayWithKeyValuesArray:dict[@"videos"]];
    for (int i=0; i<self.videoModelArray.count; i++) {
        WKVideoModel *model = self.videoModelArray[i];
        model.url = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%d",i] ofType:@"mp4"];
        self.videoModelArray[i] = model;
    }
}

- (void)prepareForUI{
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"进入仿keep视频播放器" forState:UIControlStateNormal];
    btn.frame = CGRectMake(ScreenWidth/2-100, ScreenHeight/3, 200, 44);
    btn.backgroundColor = UIColor.brownColor;
    [self.view addSubview:btn];
    btn.layer.cornerRadius = 8;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(videoPlay) forControlEvents:UIControlEventTouchUpInside];
}

- (void)videoPlay{
    WKKeepVideoPlayerVC *vc = [[WKKeepVideoPlayerVC alloc]init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.videoArr = self.videoModelArray;
    
    [self presentViewController:vc animated:YES completion:nil];
}

@end
