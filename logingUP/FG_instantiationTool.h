//
//  FG_instantiationTool.h
//  logingUP
//
//  Created by 王放歌 on 2018/7/19.
//  Copyright © 2018年 WangFangGe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FG_instantiationTool : NSObject

/**
 构造函数

 @return 生成的单例
 */
+ (instancetype)sharedInstance;

/**
 启动轮询上传
 */
- (void)open_reader_sh_iosLogingUp;

/**
 手动日志上传
 */
- (void)startUpLoading;

/**
 设置上传URL
 
 @param upLoadingUrl 上传地址
 */
- (void)setUpLoadingUrl:(NSString *)upLoadingUrl;

@end
