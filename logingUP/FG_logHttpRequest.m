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
@property (nonatomic,strong) NSLock *fgLock;
@property (nonatomic,copy) NSString *upUrlString;
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

-(NSLock *)fgLock{
    if (_fgLock == nil) {
        _fgLock = [[NSLock alloc] init];
    }
    return _fgLock;
}


- (void)postOperationLogWithRequestUrlString:(NSString *)urlString{
    _upUrlString = urlString;
    //查询是否有log需要上传
    [FG_eventInfosTool sharedInstance].delegate = self;
    
    [[FG_eventInfosTool sharedInstance] eventInfoArrayToUp];
    
}


#pragma marck <FG_eventInfosToolDelegate>

- (void)retunEventInfoArray:(NSArray *)upEvenArray{
    
    if (_isUploading) {
        //如果正在上传 跳出方法
        return;
    }
    _isUploading = YES;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:upEvenArray options:NSUTF8StringEncoding error:nil];
    NSURL *requesturl = [NSURL URLWithString:_upUrlString];
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
        
        [self.fgLock lock];
            weakIsUploading = NO;
            if (error == nil) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if ([dic[@"success"] boolValue]) {
                    //成功,查询是否还有需要上传的日志
                    [[FG_eventInfosTool sharedInstance] eventInfoArrayToUp];
                }else{
                    
                    //服务器插入错误
                    
                    if ([dic[@"code"] intValue] == -1) {
                        //  格式错误  进行错误处理
                        
                    }else{
                        
                    }
                    [[FG_eventInfosTool sharedInstance] addEventInfoArray:upEvenArray];
                }
                
            }else{
                //网络错误
                [[FG_eventInfosTool sharedInstance] addEventInfoArray:upEvenArray];
                
            }
        [self.fgLock unlock];
        
    }];
    [task resume];
    
}

@end
