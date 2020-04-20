//
//  FG_location.h
//  logingUP
//
//  Created by 王放歌 on 2018/9/26.
//  Copyright © 2018年 WangFangGe. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol FG_locationDelegate <NSObject>
- (void)changeLocation:(NSString *)country city:(NSString*)city area:(NSString *)area coord:(NSString*)coord;
@end

@interface FG_location : NSObject

- (void)FGLog_startLocating;

@property (nonatomic,weak) id<FG_locationDelegate> delegate;

@end
