//
//  UIDevice+FG_Hardware.m
//  logingUP
//
//  Created by 王放歌 on 2018/8/27.
//  Copyright © 2018年 WangFangGe. All rights reserved.
//

#import "UIDevice+FG_Hardware.h"

@implementation UIDevice (FG_Hardware)

-(NSDictionary *)currentDeviceInfo{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:20];
    [dict setObject:[self getModelPlatformString:[self platformString]] forKey:@"model"];
    [dict setObject:[NSString stringWithFormat:@"%.0f",[self getCurrentBatteryLevel]] forKey:@"Battery"];
    [dict setObject:[self getCPUTypeWithPlatformString:[self platformString]] forKey:@"cpu"];
    [dict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[self cpuCount]] forKey:@"cpuCount"];
    [dict setObject:[NSArray arrayWithArray:[self cpuUsage]] forKey:@"cpuUsage"];
    [dict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[self totalMemoryBytes]] forKey:@"totalMemoryBytes"];
    [dict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[self freeMemoryBytes]] forKey:@"freeMemoryBytes"];
    [dict setObject:[NSString stringWithFormat:@"%lld",[self freeDiskSpaceBytes]] forKey:@"freeDiskSpaceBytes"];
    [dict setObject:[NSString stringWithFormat:@"%lld",[self totalDiskSpaceBytes]] forKey:@"totalDiskSpaceBytes"];
    [dict setObject:[self getTimeZone] forKey:@"TimeZone"];
    [dict setObject:[self getNetType] forKey:@"NetType"];
    [dict setObject:[self getOsVersion] forKey:@"OsVersion"];
    [dict setObject:[self getAppVersion] forKey:@"AppVersion"];
//    [dict setObject:[self createUUID] forKey:@"UUID"];
    [dict setObject:[self getCurrentIP] forKey:@"IP"];
    return dict;
}
- (NSString *)getCurrentIP
{
    NSString *IP = [self getIPAddress];
    NSLog(@" Get IP Address %@",IP);
    return IP;
}

- (NSString *)getIPAddress
{
    NSString *address = @"error";
    
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    
    int success = 0;
    success = getifaddrs(&interfaces);
    
    if (success == 0)
    {
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    return address;
}

#pragma mark-Platform
- (NSString *) platformString
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
    
}

//Model ID        soc         ram         cpu              cpuArch       device
//iPad1,1         Apple A4    256         ARM Cortex-A8    ARMv7          iPad
//
//iPad2,1 2,2 2,3 Apple A5    512         ARM Cortex-A9    ARMv7          iPad 2
//iPad3,1 3,2 3,3    Apple A5X    1024        ARM Cortex-A9     ARMv7            iPad (3G)
//
//iPad3,4         Apple A6X    1024        Swift (Apple)    ARMv7s         iPad (4G)
//
//iPad4,1 4,2 4,3    Apple A7    1024        Cyclone (Apple)  ARMv8          iPad Air
//iPad4,4 4,5 4,6    Apple A7    1024        Cyclone (Apple)  ARMv8          iPad mini 2
//iPad4,7 4,8 4,9    Apple A7    1024        Cyclone (Apple)  ARMv8          iPad mini 3
//
//iPad5,3 5,4     Apple A8X    2048        Typhoon (Apple)  ARMv8          iPad Air 2
//iPad6,8         Apple A9X    4096        Twister (Apple)  ARMv8-A        iPad Pro

- (NSString *)getModel
{
    return [[UIDevice currentDevice] model];
}

- (NSString *)getModelPlatformString:(NSString *)platform{
    
    if([platform isEqualToString:@"iPad1,1"])  return@"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,11"])  return@"iPad";
    
    if([platform isEqualToString:@"iPad6,12"])  return@"iPad";
    
    if([platform isEqualToString:@"iPad7,1"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad7,2"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad7,3"])  return@"iPad Pro 10.5";
    
    if([platform isEqualToString:@"iPad7,4"])  return@"iPad Pro 10.5";
    
    if([platform isEqualToString:@"iPad7,5"])  return@"iPad";
    
    if([platform isEqualToString:@"iPad7,6"])  return@"iPad";
    
    return platform;
}

//获取cpu&cpuArch
- (NSString *)getCPUTypeWithPlatformString:(NSString *)platformString{
    NSString *cpuArch = [[NSString alloc] init];
    
    if ([platformString isEqualToString:@"iPad1,1"])
    {
        cpuArch = @"ARMv7";
    }
    else if ([platformString hasPrefix:@"iPad2"]||
             [platformString isEqualToString:@"iPad3,1"]||
             [platformString isEqualToString:@"iPad3,2"]||
             [platformString isEqualToString:@"iPad3,3"])
    {
        cpuArch = @"ARMv7";
    }
    else if([platformString isEqualToString:@"iPad3,4"])
    {
        cpuArch = @"ARMv7s";
    }
    else if ([platformString hasPrefix:@"iPad4"])
    {
        cpuArch = @"ARMv8";
    }
    else if ([platformString hasPrefix:@"iPad5"])
    {
        cpuArch = @"ARMv8s";
        
    }
    else if ([platformString hasPrefix:@"iPad6"])
    {
        cpuArch = @"ARMv9";
    }
    else if ([platformString hasPrefix:@"iPad7"])
    {
        cpuArch = @"ARMv10";
    }
    else
    {
        cpuArch = @"";
    }
    
    return cpuArch;
}

#pragma mark-获取当前设备电量
- (double)getCurrentBatteryLevel
{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    double percent = [UIDevice currentDevice].batteryLevel * 100;
    return percent;
}

#pragma mark sysctl utils
- (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}
- (NSUInteger) cpuCount
{
    return [self getSysInfo:HW_NCPU];
}

- (NSArray *)cpuUsage
{
    NSMutableArray *usage = [NSMutableArray array];
    //    float usage = 0;
    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
    unsigned _numCPUs;
    NSLock *_cpuUsageLock;
    
    int _mib[2U] = { CTL_HW, HW_NCPU };
    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
    if(_status)
        _numCPUs = 1;
    
    _cpuUsageLock = [[NSLock alloc] init];
    
    natural_t _numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
    if(err == KERN_SUCCESS) {
        [_cpuUsageLock lock];
        
        for(unsigned i = 0U; i < _numCPUs; ++i) {
            Float32 _inUse, _total;
            if(_prevCPUInfo) {
                _inUse = (
                          (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                          );
                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } else {
                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            
            //            NSLog(@"Core : %u, Usage: %.2f%%", i, _inUse / _total * 100.f);
            float u = _inUse / _total * 100.f;
            [usage addObject:[NSNumber numberWithFloat:u]];
        }
        
        [_cpuUsageLock unlock];
        
        if(_prevCPUInfo) {
            size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
        }
        
        _prevCPUInfo = _cpuInfo;
        _numPrevCPUInfo = _numCPUInfo;
        
        _cpuInfo = nil;
        _numCPUInfo = 0U;
    } else {
        NSLog(@"Error!");
    }
    return usage;
}

#pragma mark memory information
- (NSUInteger) totalMemoryBytes
{
    return [self getSysInfo:HW_PHYSMEM];
}

- (NSUInteger) freeMemoryBytes
{
    mach_port_t           host_port = mach_host_self();
    mach_msg_type_number_t   host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t               pagesize;
    vm_statistics_data_t     vm_stat;
    
    host_page_size(host_port, &pagesize);
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) NSLog(@"Failed to fetch vm statistics");
    
    //    natural_t   mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
    natural_t   mem_free = vm_stat.free_count * pagesize;
    //    natural_t   mem_total = mem_used + mem_free;
    
    return mem_free;
}

#pragma mark disk information
- (long long) freeDiskSpaceBytes
{
    struct statfs buf;
    long long freespace;
    freespace = 0;
    if(statfs("/private/var", &buf) >= 0){
        freespace = (long long)buf.f_bsize * buf.f_bfree;
    }
    return freespace;
}

- (long long) totalDiskSpaceBytes
{
    struct statfs buf;
    long long totalspace;
    totalspace = 0;
    if(statfs("/private/var", &buf) >= 0){
        totalspace = (long long)buf.f_bsize * buf.f_blocks;
    }
    return totalspace;
}

#pragma mark-是否越狱
- (BOOL) isJailBreak
{
    int res = access("/var/mobile/Library/AddressBook/AddressBook.sqlitedb", F_OK);
    if (res != 0)
        return NO;
    return YES;
}

#pragma mark-获取时间区域
- (NSString *)getTimeZone{
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    
    NSString *timeZoneString = [timeZone localizedName:NSTimeZoneNameStyleStandard locale:[NSLocale currentLocale]];
    if ([timeZone isDaylightSavingTimeForDate:[NSDate date]]) {
        timeZoneString = [timeZone localizedName:NSTimeZoneNameStyleDaylightSaving locale:[NSLocale currentLocale]];
    }
    
    return timeZoneString;
}

- (NSString*)getAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

- (NSString*)getAppStoreVersion
{
    NSString* sAppVersion = [self getAppVersion];
    NSArray* subVersionArr = [sAppVersion componentsSeparatedByString:@"."];
    if ([ subVersionArr count] >3)
    {
        sAppVersion = [NSString stringWithFormat:@"%@.%@.%@",[subVersionArr objectAtIndex:0]
                       ,[subVersionArr objectAtIndex:1]
                       ,[subVersionArr objectAtIndex:2]
                       ];
    }
    return sAppVersion;
}

- (NSString*)getAppBuildVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleVersion"];
}


- (NSString*)getNetType
{
    return [UIDevice getNetWorkStates];
}

- (NSString*)getOsVersion
{
    return [self systemVersion];
}

+ (NSString *)getNetWorkStates
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    NSString *state = [[NSString alloc] init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"NoNet";
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                {
                    state = @"Wifi";
                }
                    break;
                default:
                {
                    state = @"UnknownNetName";
                }
                    break;
            }
        }
    }
    return state;
}



//通过hostInfo来获取subCpuType
- (cpu_subtype_t)getSubCpuType
{
    host_basic_info_data_t hostInfo;
    mach_msg_type_number_t infoCount = HOST_BASIC_INFO_COUNT;
    kern_return_t ret = host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)&hostInfo ,&infoCount);
    if (ret == KERN_SUCCESS) {
        NSLog(@"❤️the cpu_subType is :%d",hostInfo.cpu_subtype);
    }
    return  hostInfo.cpu_subtype;
}

//通过archInfo来获取cpuType
- (cpu_type_t)getCpuType{
    const NXArchInfo *archInfo = NXGetLocalArchInfo();
    NSLog(@"❤️the type is :%d",archInfo->cputype);
    return archInfo->cpusubtype;
}

@end
