//
//  FG_eventInfosTool.h
//  logingUP
//
//  Created by 王放歌 on 2018/7/31.
//  Copyright © 2018年 WangFangGe. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FG_eventInfosToolDelegate <NSObject>

- (void)retunEventInfoArray:(NSArray *)upEvenArray;

@end

@interface FG_eventInfosTool : NSObject

@property (nonatomic,weak) id <FG_eventInfosToolDelegate>delegate;

/**
 维护操作日志工具

 @return tool
 */
+ (instancetype)sharedInstance;

/**
 未上传的日志持久化到本地
 */
- (void)writeLog;

/**
 设置日志恒定上传的用户信息

 @param userInfo 用户信息字典
 */
- (void)addUserInfo:(NSDictionary *)userInfo;

/**
 添加一条单条的日志

 @param even 日志dic
 */
- (void)addEventInfo:(NSDictionary *)even;

/**
 添加一堆日志

 @param evenArray 日志dic的array
 */
- (void)addEventInfoArray:(NSArray *)evenArray;


/**
 获取需要上传的操作日志包 队列获取，返回方法走代理
 */
- (void)eventInfoArrayToUp;


/**
 开启定位
 */
- (void)startLocating;

/**
 将维护的操作日志数组保存到本地
 */
- (void)writeDataToPath;

@end
