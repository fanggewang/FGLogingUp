//
//  FG_eventInfosTool.m
//  logingUP
//
//  Created by 王放歌 on 2018/7/31.
//  Copyright © 2018年 WangFangGe. All rights reserved.
//

#import "FG_eventInfosTool.h"
#import <objc/message.h>
#import <UIKit/UIKit.h>

#define FG_LogUPloadNumber 50//一次最大上传日志条数
#define Fg_LogFile [NSString stringWithFormat:@"%@/FGLOG",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]
#define FG_dataFile [NSString stringWithFormat:@"%@/eventLog",Fg_LogFile]

@interface FG_eventInfosTool()

@property (nonatomic,strong) NSMutableArray *eventInfos;

@property (nonatomic,strong) NSOperationQueue *arrayQueue;

@end

@implementation FG_eventInfosTool

static FG_eventInfosTool *_tool;

+ (void)load{
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:Fg_LogFile]) {
        //创建日志持久化缓存文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:Fg_LogFile withIntermediateDirectories:YES attributes:nil error:nil];
    }

}
+ (void)initialize{
    /*
     *  监听退出APP
     */
    id app = [UIApplication sharedApplication].delegate;
    Method myWillTerminate = class_getInstanceMethod(self, @selector(FG_applicationWillTerminate:));
    Method appDelegateWillTerminate = class_getInstanceMethod([app class], @selector(applicationWillTerminate:));
    method_exchangeImplementations(myWillTerminate, appDelegateWillTerminate);
    
    Method myDidEnterBackground = class_getInstanceMethod(self, @selector(FG_applicationDidEnterBackground:));
    Method applicationDidEnterBackground = class_getInstanceMethod([app class], @selector(applicationDidEnterBackground:));
    method_exchangeImplementations(myDidEnterBackground, applicationDidEnterBackground);
}
#pragma mark 退出app相关操作

- (void)comeHome:(UIApplication *)application {
    NSLog(@"进入后台");
}
- (void)FG_applicationDidEnterBackground:(UIApplication *)application{
    
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(){}];
    
    [[FG_eventInfosTool sharedInstance] FG_applicationDidEnterBackground:application];
}

- (void)FG_applicationWillTerminate:(UIApplication *)application{
    [[FG_eventInfosTool sharedInstance] writeLog];
    
    [[FG_eventInfosTool sharedInstance] FG_applicationWillTerminate:application];
}



/**
 *     构造方法
 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_tool == nil) {
            _tool = [super allocWithZone:zone];
            [[NSNotificationCenter defaultCenter] addObserver:_tool selector:@selector(comeHome:) name:@"UIApplicationDidEnterBackgroundNotification" object:nil];
            
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

- (NSMutableArray *)eventInfos{
    if (_eventInfos == nil) {
        _eventInfos = [NSMutableArray array];
        NSArray * arr = [NSArray arrayWithContentsOfFile:FG_dataFile];
        if (arr.count) {
            [_eventInfos addObject:arr];
        }
    }
    return _eventInfos;
}

- (NSOperationQueue *)arrayQueue{
    if (_arrayQueue == nil) {
        _arrayQueue = [[NSOperationQueue alloc] init];
        _arrayQueue.maxConcurrentOperationCount = 1;
    }
    return _arrayQueue;
}



/**
 日志持久化到本地
 */
- (void)writeLog{
    
    NSLog(@"程序退出，写日志到本地");
    BOOL state = [self.eventInfos writeToFile:FG_dataFile atomically:YES];
    if (state == YES) {
        NSLog(@"write successfully");
    }else{
        NSLog(@"fail to write");
    }
}

- (void)addEventInfo:(NSDictionary *)even{
    
    NSBlockOperation *addOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        [self.eventInfos addObject:even];
        
    }];
    [self.arrayQueue addOperation:addOperation];

    
    
}

- (void)addEventInfoArray:(NSArray *)evenArray{
    
    NSBlockOperation *addOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        [self.eventInfos addObjectsFromArray:evenArray];
        
    }];
    [self.arrayQueue addOperation:addOperation];
    
}

- (void)eventInfoArrayToUp{


    NSBlockOperation *addOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSArray *upEvenInfoArray;
        if (self.eventInfos.count > FG_LogUPloadNumber) {
            
            upEvenInfoArray = [self.eventInfos subarrayWithRange:NSMakeRange(0, FG_LogUPloadNumber)];
            [self.eventInfos removeObjectsInRange:NSMakeRange(0, FG_LogUPloadNumber)];
        }else{
            
            upEvenInfoArray = [NSArray arrayWithArray:self.eventInfos];
            [self.eventInfos removeAllObjects];
            
        }
        if (upEvenInfoArray.count > 0) {
            
            [self.delegate retunEventInfoArray:upEvenInfoArray];
        }else{
            //所有 log 全部上传完成
            
        }
        
    }];
    
    [self.arrayQueue addOperation:addOperation];
    
}

- (void)writeDataToPath{
    
    
}
@end
