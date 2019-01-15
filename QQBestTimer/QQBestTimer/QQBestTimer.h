//
//  QQBestTimer.h
//  QQBestTimer
//
//  Created by 彭倩倩 on 2019/1/15.
//  Copyright © 2019 彭倩倩. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^QQBestTimerBlock)(NSInteger row);

NS_ASSUME_NONNULL_BEGIN

@interface QQBestTimer : NSObject

/** 创建单例对象 */
+ (instancetype)bestTimerSingleton;
/** 创建定时器 */
- (void)createBestTimer;
/** 暂停定时器 */
- (void)pauseBestTimer;
/** 恢复定时器 */
- (void)resumeBestTimer;
/** 销毁定时器 */
- (void)stopBestTimer;

/** 事件回调 */
@property (nonatomic, copy) QQBestTimerBlock bestTimerBlock;

/** 下列方法拒绝外部调用 */
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE;
- (id)mutableCopy NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
