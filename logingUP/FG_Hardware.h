//
//  FG_Hardware.h
//  logingUP
//
//  Created by 王放歌 on 2018/8/27.
//  Copyright © 2018年 WangFangGe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <sys/types.h>
#import <sys/param.h>
#import <sys/mount.h>
#import <mach/processor_info.h>
#include <sys/stat.h>
#import <mach-o/arch.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
@interface FG_Hardware : NSObject

- (NSDictionary *)currentDeviceInfo;  //汇总获取

@end
