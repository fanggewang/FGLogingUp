//
//  FG_eventInfosTool.m
//  logingUP
//
//  Created by 王放歌 on 2018/7/31.
//  Copyright © 2018年 WangFangGe. All rights reserved.
//

#import "FG_eventInfosTool.h"
#define FG_LogUPloadNumber 50//一次最大上传日志条数

@interface FG_eventInfosTool()

@property (nonatomic,strong) NSMutableArray *eventInfos;

@property (nonatomic,strong) NSOperationQueue *arrayQueue;

@end

@implementation FG_eventInfosTool
static FG_eventInfosTool *_tool;
/**
 *     构造方法
 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_tool == nil) {
            _tool = [super allocWithZone:zone];
            
        }
    });
    return _tool;
}
+ (instancetype)sharedInstance
{
    // 最好用self 用FGLogingUP他的子类调用时会出现错误
    return [[self alloc]init];
}
// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
- (id)copyWithZone:(NSZone *)zone
{
    return _tool;
}
- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _tool;
}

- (NSMutableArray *)eventInfos{
    if (_eventInfos == nil) {
        _eventInfos = [NSMutableArray array];
    }
    return _eventInfos;
}
- (NSOperationQueue *)arrayQueue{
    if (_arrayQueue == nil) {
        _arrayQueue = [[NSOperationQueue alloc] init];
        _arrayQueue.maxConcurrentOperationCount = 1;
    }
    return _arrayQueue;
}


- (void)addEventInfo:(NSDictionary *)even{
    
    NSBlockOperation *addOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        [self.eventInfos addObject:even];
        
    }];
    [self.arrayQueue addOperation:addOperation];

    
    
}

- (void)addEventInfoArray:(NSArray *)evenArray{
    
    NSBlockOperation *addOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        [self.eventInfos addObjectsFromArray:evenArray];
        
    }];
    [self.arrayQueue addOperation:addOperation];
    
}

- (void)eventInfoArrayToUp{
    
    NSBlockOperation *addOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSArray *upEvenInfoArray;
        if (self.eventInfos.count > FG_LogUPloadNumber) {
            
            upEvenInfoArray = [self.eventInfos subarrayWithRange:NSMakeRange(0, FG_LogUPloadNumber)];
            [self.eventInfos removeObjectsInRange:NSMakeRange(0, FG_LogUPloadNumber)];
        }else{
            
            upEvenInfoArray = [NSArray arrayWithArray:self.eventInfos];
            [self.eventInfos removeAllObjects];
            
        }
        if (upEvenInfoArray.count > 0) {
            
            [self.delegate retunEventInfoArray:upEvenInfoArray];
        }else{
            //所有 log 全部上传完成
            
        }
        
    }];
    
    [self.arrayQueue addOperation:addOperation];
    
}

- (void)writeDataToPath{
    
    
}
@end
