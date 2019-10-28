//
//  ViewController.m
//  SuperPlay
//
//  Created by 张恒 on 2019/6/20.
//  Copyright © 2019 张恒. All rights reserved.
//

#import "ViewController.h"
// 引入头文件
#import "SuperPlayer/SuperPlayer.h"
#import "LeoDanmaku.h"

@interface ViewController ()<SuperPlayerDelegate>
{
    SuperPlayerView  *_playerView;
}
@property(strong, nonatomic)LeoDanmakuView *danmakuView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _playerView = [[SuperPlayerView alloc] init];
    // 设置代理，用于接受事件
    _playerView.delegate = self;
    // 设置父 View，_playerView 会被自动添加到 holderView 下面
    UIView *holderView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:holderView];
    _playerView.fatherView = holderView;
    
    SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
    
    NSString* flvUrl;
    flvUrl = @"http://play.xianbing100.com/live/test.flv";
    flvUrl = @"http://5815.liveplay.myqcloud.com/live/5815_89aad37e06ff11e892905cb9018cf0d4_900.flv";
//    flvUrl = @"http://200024424.vod.myqcloud.com/200024424_709ae516bdf811e6ad39991f76a4df69.f20.mp4";
    
    flvUrl = @"http://1256784417.vod2.myqcloud.com/8b2fd5cfvodcq1256784417/439fc0b55285890790932558461/f0.mp4";
    
    // 设置播放地址，直播、点播都可以
    playerModel.videoURL = flvUrl;
    // 开始播放
    [_playerView playWithModel:playerModel];
    
    
    
    [self creatUI];
    [self.danmakuView resume];
    self.danmakuView.allowOverlapping = true;
    [self performSelector:@selector(addDanmaku) withObject:nil afterDelay:3];
    
    // Do any additional setup after loading the view.
}

-(void)creatUI{
    self.danmakuView = [[LeoDanmakuView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [self.view addSubview:self.danmakuView];

}

- (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}
- (UIColor *)colorWithHex:(int)hexValue
{
    return [self colorWithHex:hexValue alpha:1.0];
}

-(void)addDanmaku{
    NSArray * colors = @[
                         [self colorWithHex:0xff66cc],
                         [self colorWithHex:0xff6666],
                         [self colorWithHex:0x9966ff],
                         [self colorWithHex:0x6699ff],
                         [self colorWithHex:0x66ffcc],
                         [self colorWithHex:0xccff99],
                         [self colorWithHex:0xffff66],
                         [self colorWithHex:0xff9966],
                         [self colorWithHex:0xffcccc],
                         ];
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i =0; i<50000; i++) {
        LeoDanmakuModel * danmaku = [LeoDanmakuModel randomDanmkuWithColors:colors MaxFontSize:18 MinFontSize:15];
        danmaku.text = @"hello";
        [arr addObject:danmaku];
    }
    [self.danmakuView addDanmakuWithArray:arr];
    
}


@end
