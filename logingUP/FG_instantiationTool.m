//
//  FG_instantiationTool.m
//  logingUP
//
//  Created by 王放歌 on 2018/7/19.
//  Copyright © 2018年 WangFangGe. All rights reserved.
//

#import "FG_instantiationTool.h"
#import "FG_logHttpRequest.h"
#import "FG_eventInfosTool.h"
#import "FG_AFNetworkReachabilityManager.h"
//日志发送周期时间
#define FG_MIXUpTime 60
#define FG_MAXUpTime 120
@interface FG_instantiationTool()

@property (nonatomic,strong) FG_logHttpRequest *UpLoadRequest;

@property (nonatomic,strong) FG_eventInfosTool *eventArrayTool;
@property (nonatomic,strong) NSTimer *logUpTimer;

@property (nonatomic,copy) NSString *upLoadingUrl;
@property (nonatomic,assign) BOOL isNetwrokConnect;

@end

@implementation FG_instantiationTool

static FG_instantiationTool *_tool;
/**
 *     构造方法
 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_tool == nil) {
            _tool = [super allocWithZone:zone];
            
        }
    });
    return _tool;
}
+ (instancetype)sharedInstance
{
    // 最好用self 用FGLogingUP他的子类调用时会出现错误
    return [[self alloc]init];
}
// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
- (id)copyWithZone:(NSZone *)zone
{
    return _tool;
}
- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _tool;
}
- (void)setUpLoadingUrl:(NSString *)upLoadingUrl{
    [self monitorNetworking];
    _upLoadingUrl = upLoadingUrl;
    
}
/*
 *      获取随机数，减少服务器的碰撞
 */
- (int)getRandomNumber
{
    return (int)(FG_MIXUpTime + (arc4random() %(FG_MAXUpTime -FG_MIXUpTime +1)));
}

/*
 *  关闭轮询
 */
- (void)closeTimer{
    
    [self.logUpTimer invalidate];
    self.logUpTimer = nil;
    
}



/*
 *   初始化方法 设置上传到服务器的 URL
 */
- (void)open_reader_sh_iosLogingUp{
    
    if (self.logUpTimer == nil || !self.logUpTimer) {
        
        self.logUpTimer = [NSTimer scheduledTimerWithTimeInterval:[self getRandomNumber] target:self selector:@selector(timerClick)userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.logUpTimer forMode:NSRunLoopCommonModes];
        
        
    }
    
}

- (void)timerClick{
    
    [self closeTimer];
    [self open_reader_sh_iosLogingUp];
    [self startUpLoading];
}


/*
 *  手动开启日志上传
 */
- (void)startUpLoading{
    if (_isNetwrokConnect) {
        
        // 有网则上传
        if (_isNetwrokConnect) {
            if (self.UpLoadRequest == nil) {
                self.UpLoadRequest = [[FG_logHttpRequest alloc]init];
            }
            [_UpLoadRequest postOperationLogWithRequestUrlString:_upLoadingUrl];
        }
        
    }else{
        //没网，则不上传
        
    }


}

- (void)setIsNetwrokConnect:(BOOL)isNetwrokConnect{
    _isNetwrokConnect = isNetwrokConnect;
}

#pragma mark - ------------- 监测网络状态 -------------
- (void)monitorNetworking
{
    [[FG_AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[FG_AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            //            NSLog(@"有网");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FG_instantiationTool sharedInstance] setIsNetwrokConnect:YES];
                
            });
            
        }else{
            //            NSLog(@"没网");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FG_instantiationTool sharedInstance] setIsNetwrokConnect:NO];
                
            });
        }
    }];
}

@end
