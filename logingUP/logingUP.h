//
//  logingUP.h
//  logingUP
//
//  Created by 王放歌 on 2018/7/19.
//  Copyright © 2018年 WangFangGe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface logingUP : NSObject


/*
 *   初始化方法 设置上传到服务器的 URL
 */
+ (void)open_reader_sh_iosLogingUpWithUrl:(NSString *)url;


/*
 *  NSDictionary既为需要存储和上传的参数
 *  其中key  对应 上传到服务器的key
 *  values  对应 上传到服务器的values
 *   添加一条log
 */
+ (void)addLogWithDic:(NSDictionary *)dic;

/*
 *  手动开启日志上传
 */
+ (void)startUpLoading;

/**
 设置日志中的个人信息

 @param userInfo 个人信息字典
 */
+ (void)setUseopemrInfo:(NSDictionary *)userInfo;

@end
