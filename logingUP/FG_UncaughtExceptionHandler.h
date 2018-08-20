//
//  FG_UncaughtExceptionHandler.h
//  logingUP
//
//  Created by 王放歌 on 2018/8/20.
//  Copyright © 2018年 WangFangGe. All rights reserved.
//

#import <Foundation/Foundation.h>
void HandleException(NSException *exception);
void SignalHandler(int signal);
void InstallUncaughtExceptionHandler(void);

@interface FG_UncaughtExceptionHandler : NSObject

@end
