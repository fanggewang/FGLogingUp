//
//  UIDevice+FG_Hardware.h
//  logingUP
//
//  Created by 王放歌 on 2018/8/27.
//  Copyright © 2018年 WangFangGe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
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
@interface UIDevice (FG_Hardware)

- (NSDictionary *)currentDeviceInfo;  //汇总获取
- (NSString *) platformString;      //平台信息
- (double)getCurrentBatteryLevel;    //获取当前设备电量

- (NSUInteger) cpuCount;            //cpu核数
- (NSArray *) cpuUsage;             //cpu利用率

- (NSUInteger) totalMemoryBytes;    //获取手机内存总量,返回的是字节数
- (NSUInteger) freeMemoryBytes;     //获取手机可用内存,返回的是字节数

- (long long) freeDiskSpaceBytes;   //获取手机硬盘空闲空间,返回的是字节数
- (long long) totalDiskSpaceBytes;  //获取手机硬盘总空间,返回的是字节数

- (BOOL) isJailBreak;               //是否越狱

- (NSString *)getAppVersion;        //App版本
- (NSString *)getAppStoreVersion;
- (NSString *)getAppBuildVersion;
- (NSString *)getNetType;
- (NSString *)getOsVersion;
- (NSString *)getTimeZone;
- (cpu_subtype_t)getSubCpuType;
- (cpu_type_t)getCpuType;

- (NSString *)getCPUTypeWithPlatformString:(NSString *)platformString;//cpu型号
- (NSString *)getCurrentIP;

@end
