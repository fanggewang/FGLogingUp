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
            
        }else{
            
            upEvenInfoArray = [NSArray arrayWithArray:self.eventInfos];
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
