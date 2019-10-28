//
//  PlayingViewController.m
//  LiveOCDemo
//
//  Created by 张恒 on 2019/6/17.
//  Copyright © 2019 张恒. All rights reserved.
//
/*
 * Function: 使用LiteAVSDK完成直播播放
 */


#import "PlayingViewController.h"
#import "TXLiteAVSDK_Professional/TXLivePlayer.h"
#import "AFNetworking.h"


@interface PlayingViewController ()<TXLivePlayListener>
{
    UIView           *_videoView; // 视频画面
}
@property(nonatomic,strong) TXLivePlayer *txLivePlayer;
@property(nonatomic,strong) NSString     *playUrl;


@end

@implementation PlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建播放器
    _txLivePlayer = [[TXLivePlayer alloc] init];
    
    [self initUI];
    [self startPlay];
    
    // Do any additional setup after loading the view.
}

-(void)initUI{
    // 视频画面显示
    CGRect videoFrame = self.view.bounds;
    _videoView = [[UIView alloc] initWithFrame:CGRectMake(videoFrame.size.width, 0, videoFrame.size.width, videoFrame.size.height)];
    _videoView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:_videoView atIndex:0];
}

- (void)startPlay{
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    _videoView.frame = frame;
    
    [_txLivePlayer setDelegate:self];
    //用 setupVideoWidget 给播放器绑定决定渲染区域的view，其首个参数 frame 在 1.5.2 版本后已经被废弃
    [_txLivePlayer setupVideoWidget:CGRectMake(0, 0, 0, 0) containView:_videoView insertIndex:0];
    self.playUrl = @"http://play.xianbing100.com/live/test.flv";
    //    NSString* flvUrl = @"http://5815.liveplay.myqcloud.com/live/5815_89aad37e06ff11e892905cb9018cf0d4_900.flv";
    int ret = [_txLivePlayer startPlay:self.playUrl type:PLAY_TYPE_LIVE_FLV];
    if (ret != 0) {
        NSLog(@"播放器启动失败");
    }
    [_txLivePlayer showVideoDebugLog:YES];
    [_txLivePlayer setRenderRotation:HOME_ORIENTATION_DOWN];
    [_txLivePlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
}
- (void)stopPlay{
    // 停止播放
    if (_txLivePlayer) {
        [_txLivePlayer setDelegate:nil];
        [_txLivePlayer removeVideoWidget];// 记得销毁view控件
        [_txLivePlayer stopPlay];
    }
}

#pragma mark - TXLivePlayListener
- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary *)param {
    NSDictionary *dict = param;
//    NSLog(@"%@",dict);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID == PLAY_EVT_PLAY_BEGIN) {
      
        } else if (EvtID == PLAY_ERR_NET_DISCONNECT || EvtID == PLAY_EVT_PLAY_END) {
            // 断开连接时，模拟点击一次关闭播放
             [self stopPlay];
            
            if (EvtID == PLAY_ERR_NET_DISCONNECT) {
            
            }
            
        } else if (EvtID == PLAY_EVT_PLAY_LOADING){
           
        } else if (EvtID == PLAY_EVT_CONNECT_SUCC) {
            BOOL isWifi = [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
            if (!isWifi) {
                __weak __typeof(self) weakSelf = self;
                [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                    if (weakSelf.playUrl.length == 0) {
                        return;
                    }
                    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                                       message:@"您要切换到Wifi再观看吗?"
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [alert dismissViewControllerAnimated:YES completion:nil];
                            
                            // 先停止，再重新播放
                            [weakSelf stopPlay];
                            [weakSelf startPlay];
                        }]];
                        [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [alert dismissViewControllerAnimated:YES completion:nil];
                        }]];
                        [weakSelf presentViewController:alert animated:YES completion:nil];
                    }
                }];
            }
        }
    });
    
    
}
- (void)onNetStatus:(NSDictionary *)param {
    
}

- (void)dealloc {
    [self stopPlay];
}
@end
