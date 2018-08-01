//
//  FG_logHttpRequest.m
//  logingUP
//
//  Created by 王放歌 on 2018/7/21.
//  Copyright © 2018年 WangFangGe. All rights reserved.
//

#import "FG_logHttpRequest.h"
#import "FG_eventInfosTool.h"

@interface FG_logHttpRequest()<FG_eventInfosToolDelegate>

@property (nonatomic,strong) NSMutableArray *LogArray;
@property (nonatomic,assign) __block BOOL isUploading;//标记正在上传
@property (nonatomic,strong) FG_eventInfosTool *eventTool;

@end

@implementation FG_logHttpRequest{
    
    NSURLSession *_session;
}

- (NSMutableArray *)LogArray{
    if (_LogArray == nil) {
        _LogArray = [NSMutableArray array];
    }
    return _LogArray;
}
- (FG_eventInfosTool *)eventTool{
    if (_eventTool == nil) {
        _eventTool = [[FG_eventInfosTool alloc] init];
        _eventTool.delegate = self;
    }
    return _eventTool;
}
//准备上传的数据
- (void)initDate{
    
//    NSArray *OperationLog = [[DBManager sharedInstance] loginfoGetNotUpload];
//    
//    self.LogArray = [NSMutableArray arrayWithArray:OperationLog];
    
}


- (void)postOperationLogWithRequest{
    //查询是否有log需要上传
    [self.eventTool eventInfoArrayToUp];
    
}


#pragma marck <FG_eventInfosToolDelegate>

- (void)retunEventInfoArray:(NSArray *)upEvenArray{
    
    if (_isUploading) {
        //如果正在上传 跳出方法
        return;
    }
    _isUploading = YES;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:upEvenArray options:NSUTF8StringEncoding error:nil];
    NSURL *requesturl = [NSURL URLWithString:@""];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requesturl cachePolicy:0 timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    //4.构造session
    if (_session == nil) {
        _session = [NSURLSession sharedSession];
    }
    __block typeof(_isUploading)weakIsUploading = _isUploading;
    //链接服务器
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakIsUploading = NO;
            if (error == nil) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if ([dic[@"success"] boolValue]) {
                    //            NSLog(@"______成功");
                    //成功
                    
                }else{
                    //服务器插入错误
                    
                    if ([dic[@"code"] intValue] == -1) {
                        //  格式错误  进行错误处理
                        
                    }else{
                        
                    }
                    
                }
                
                
            }else{
                //网络错误
            }
        });
        
    }];
    [task resume];
    
}

@end
