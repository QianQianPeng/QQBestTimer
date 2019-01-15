//
//  QQBestTimer.m
//  QQBestTimer
//
//  Created by 彭倩倩 on 2019/1/15.
//  Copyright © 2019 彭倩倩. All rights reserved.
//

#import "QQBestTimer.h"

@interface QQBestTimer()

@property (nonatomic, strong) dispatch_source_t bestTimer;

@end

@implementation QQBestTimer

/** 创建单例对象 */
+ (instancetype)bestTimerSingleton {
    static QQBestTimer *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSingleton = [[self alloc] init];
    });
    return _sharedSingleton;
}

/** 创建定时器 */
- (void)createBestTimer {
    
    [self stopBestTimer];
    
    NSTimeInterval interval = 1.0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _bestTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 每秒执行 1 次
    dispatch_source_set_timer(_bestTimer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0);
    // 定时器事件回调
    dispatch_source_set_event_handler(_bestTimer, ^{
        NSLog(@"每秒执行test");
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.bestTimerBlock) {
                self.bestTimerBlock(1);
            }
        });
    });
    dispatch_resume(_bestTimer);
}

/** 暂停定时器 */
- (void)pauseBestTimer {
    if (_bestTimer) {
        dispatch_suspend(_bestTimer);
    }
}

/** 恢复定时器 */
- (void)resumeBestTimer {
    if (_bestTimer) {
        dispatch_resume(_bestTimer);
    }
}

/** 销毁定时器 */
- (void)stopBestTimer {
    if (_bestTimer) {
        dispatch_source_cancel(_bestTimer);
    }
}

@end
