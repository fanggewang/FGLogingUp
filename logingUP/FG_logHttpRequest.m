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

/**
 判断URL是否合法

 @param url 需要判断的url
 @return 正确or错误
 */
- (BOOL)checkIsUrlAtString:(NSString *)url {
    NSString *pattern = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?";
    
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *regexArray = [regex matchesInString:url options:0 range:NSMakeRange(0, url.length)];
    
    if (regexArray.count > 0) {
        return YES;
    }else {
        return NO;
    }
}

#pragma marck <FG_eventInfosToolDelegate>

- (void)retunEventInfoArray:(NSArray *)upEvenArray{
    
    if (_isUploading) {
        //如果正在上传 跳出方法
        return;
    }
    if (![self checkIsUrlAtString:_upUrlString]){
        
        [[FG_eventInfosTool sharedInstance] addEventInfoArray:upEvenArray];
        NSLog(@"链接无效，请输入正确的http或者https链接");
        return;
    }
    [self.fgLock lock];
    _isUploading = YES;
    [self.fgLock unlock];
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
//    __block typeof(_isUploading)weakIsUploading = _isUploading;
    
    //链接服务器
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        [self.fgLock lock];
            self.isUploading = NO;
            if (error == nil) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if ([dic[@"success"] boolValue]) {
                    //成功,查询是否还有需要上传的日志
                    [[FG_eventInfosTool sharedInstance] eventInfoArrayToUp];
                    NSLog(@"upEvenArray:%ld 上传成功",upEvenArray.count);
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
