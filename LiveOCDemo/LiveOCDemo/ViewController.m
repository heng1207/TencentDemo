//
//  ViewController.m
//  LiveOCDemo
//
//  Created by 张恒 on 2019/6/13.
//  Copyright © 2019 张恒. All rights reserved.
//

#import "ViewController.h"
#import "PlayingViewController.h"


#define kDarvinNotificationNamePushStart        CFSTR("Darwin_ReplayKit2_Push_Start")
#define kDarvinNotificaiotnNamePushStop         CFSTR("Darwin_ReplayKit2_Push_Stop")


@interface ViewController ()
@property(nonatomic,strong)NSString *pushUrl;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pushUrl = @"rtmp://24799.livepush.myqcloud.com/live/test?txSecret=16ca1ae9a70bb8a7eecc7a13296f3147&txTime=5D1244FF";
    
    // Do any additional setup after loading the view.
}


- (IBAction)startPush:(id)sender {
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"腾讯云录屏推流" message:@"录屏只支持iOS11以上系统，请升级！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (self.pushUrl.length < 1) {
        NSString* message = @"请输入推流地址";
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"腾讯云录屏推流" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    
    if (![UIScreen mainScreen].isCaptured) {
        NSString* message = @"请先到控制中心->长按启动屏幕录制";
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"腾讯云录屏推流" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction* action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    
    UIPasteboard* pb = [UIPasteboard generalPasteboard];
    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setObject:self.pushUrl forKey:@"replaykit2RtmpURL"];
    [dict setObject:@"replaykit2Portrait"     forKey:@"replaykit2Rotation" ];
    [dict setObject:@"FHD"     forKey:@"replaykit2Resolution"];
    NSString* transString = [self dictionary2JsonString:dict];
    pb.string = transString;
    
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),kDarvinNotificationNamePushStart,NULL,nil,YES);
}
- (IBAction)endPush:(id)sender {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),kDarvinNotificaiotnNamePushStop,NULL,nil,YES);
    
}
- (IBAction)livePlay:(id)sender {
    PlayingViewController *vc=[[PlayingViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - tool func
- (NSString *)dictionary2JsonString:(NSDictionary *)dict
{
    // 转成Json数据
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
        if(error)
        {
            NSLog(@"[%@] Post Json Error", [self class]);
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    else
    {
        NSLog(@"[%@] Post Json is not valid", [self class]);
    }
    return nil;
}


@end
