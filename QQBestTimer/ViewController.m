//
//  ViewController.m
//  QQBestTimer
//
//  Created by 彭倩倩 on 2019/1/15.
//  Copyright © 2019 彭倩倩. All rights reserved.
//

#import "ViewController.h"
#import "QQBestTimer.h"

#define QQWeakSelf __weak typeof(self) weakSelf = self;

@interface ViewController ()

/** 10秒倒计时 */
@property (nonatomic, assign) NSInteger countdown;
/** 定时器 */
@property (nonatomic, strong) QQBestTimer *bestTimer;
/** 判断是不是第一次进入此界面 */
@property (nonatomic, assign) BOOL isFirst;
/** 定时器显示文本 */
@property (nonatomic, strong) UILabel *timerLabel;
/** 记录时间 */
@property (nonatomic, assign) NSInteger bestTimerCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.countdown = 10;
    [[UIApplication sharedApplication].keyWindow addSubview:self.timerLabel];
    [self initBestTimer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isFirst) {
        [_bestTimer resumeBestTimer];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_bestTimer pauseBestTimer];
    _isFirst = YES;
    [[NSUserDefaults standardUserDefaults] setObject:@(self.bestTimerCount) forKey:@"bestTimerCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 代理方法区域
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.countdown <= 0) {
        [_bestTimer resumeBestTimer];
    }
    self.countdown = 10;
}

#pragma mark - 私有方法区域
- (void)initBestTimer {
    _bestTimer = [QQBestTimer bestTimerSingleton];
    [_bestTimer createBestTimer];
    
    NSString *bestTimerString = [[NSUserDefaults standardUserDefaults] objectForKey:@"bestTimerCount"];
    self.bestTimerCount = [bestTimerString integerValue];
    QQWeakSelf
    _bestTimer.bestTimerBlock = ^(NSInteger row) {
        weakSelf.bestTimerCount++;
        weakSelf.timerLabel.text = [weakSelf timingWithBestTimerCount:weakSelf.bestTimerCount];
        if (weakSelf.countdown <= 0) {
            [weakSelf.bestTimer pauseBestTimer];
            [[NSUserDefaults standardUserDefaults] setObject:@(weakSelf.bestTimerCount) forKey:@"bestTimerCount"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        weakSelf.countdown--;
    };
    
    // 程序进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    // 程序进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    // 程序被杀死
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
}

- (NSString *)timingWithBestTimerCount:(NSInteger)bestTimerCount {
    NSInteger hours = bestTimerCount / 60 / 60 % 24; // 小时
    NSInteger minutes = bestTimerCount / 60 % 60; // 分钟
    NSInteger seconds = bestTimerCount % 60; // 秒
    if (hours <= 0) {
        if (minutes <= 0) {
            return [NSString stringWithFormat:@"%ld秒", seconds];
        }
        return [NSString stringWithFormat:@"%ld分%ld秒", minutes, seconds];
    }
    return [NSString stringWithFormat:@"%ld时%ld分%ld秒", hours, minutes, seconds];
}

/** 程序进入后台 */
- (void)applicationDidEnterBackground {
    [_bestTimer pauseBestTimer];
    [[NSUserDefaults standardUserDefaults] setObject:@(self.bestTimerCount) forKey:@"bestTimerCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _isFirst = YES;
}

/** 程序进入前台 */
- (void)applicationDidBecomeActive {
    if (_isFirst) {
        [_bestTimer resumeBestTimer];
    }
}

/** 程序被杀死 */
- (void)applicationWillTerminate {
    [_bestTimer pauseBestTimer];
    [_bestTimer stopBestTimer];
    [[NSUserDefaults standardUserDefaults] setObject:@(self.bestTimerCount) forKey:@"bestTimerCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 懒加载区域
- (UILabel *)timerLabel {
    if (!_timerLabel) {
        _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 25)];
        _timerLabel.backgroundColor = [UIColor blackColor];
        _timerLabel.font = [UIFont systemFontOfSize:14];
        _timerLabel.textColor = [UIColor redColor];
        _timerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timerLabel;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
