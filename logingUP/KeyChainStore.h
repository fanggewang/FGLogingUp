//
//  KeyChainStore.h
//  Reader_SH
//
//  Created by 糖心儿 on 2017/3/23.
//  Copyright © 2017年 Sumtice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end
