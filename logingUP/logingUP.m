//
//  logingUP.m
//  logingUP
//
//  Created by 王放歌 on 2018/7/19.
//  Copyright © 2018年 WangFangGe. All rights reserved.
//

#import "logingUP.h"
#import "FG_instantiationTool.h"
#import "FG_eventInfosTool.h"
#import "FG_UncaughtExceptionHandler.h"

@implementation logingUP
/*
 *   初始化方法 设置上传到服务器的 URL
 */
+ (void)open_reader_sh_iosLogingUpWithUrl:(NSString *)url{
    
    InstallUncaughtExceptionHandler();//监听崩溃
    
    [[FG_instantiationTool sharedInstance] setUpLoadingUrl:url];
    
    [[FG_instantiationTool sharedInstance] open_reader_sh_iosLogingUp];
    
    
}

/*
 *  NSDictionary既为需要存储和上传的参数
 *  其中key  对应 上传到服务器的key
 *  values  对应 上传到服务器的values
 *   添加一条log
 */
+ (void)addLogWithDic:(NSDictionary *)dic{
    
    [[FG_eventInfosTool sharedInstance] addEventInfo:dic];
    
}

/*
 *  手动开启日志上传
 */
+ (void)startUpLoading{
    
    [[FG_instantiationTool sharedInstance] startUpLoading];
    
}
+ (void)setUserInfo:(NSDictionary *)userInfo{
    
    [[FG_eventInfosTool sharedInstance] addUserInfo:userInfo];
    
}

@end
