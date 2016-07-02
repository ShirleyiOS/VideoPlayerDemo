//
//  ViewController.m
//  VideoPlayerDemo
//
//  Created by 王爽 on 16/7/1.
//  Copyright © 2016年 王爽. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()
@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createPlayView];
    [self addPlayerItem];
    [self createProgressView];
}

- (void)createPlayView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat ratio = 9.0 / 16.0;
    _playView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth * ratio)];
    _playView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_playView];
}

- (void)addPlayerItem{
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:@"http://45.113.121.198/bangbang/2016-06-29/bangbang_20160629015256.mp4"]];
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    self.avPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    //  playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.frame = _playView.bounds;
    [_playView.layer addSublayer:playerLayer];
}

- (void)createProgressView{
    CGFloat progressViewHeight = 10.0;
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, _playView.frame.size.height - progressViewHeight, _playView.frame.size.width, progressViewHeight)];
    [_playView addSubview:_progressView];
}

- (void)refreshProgressView{
    
    __weak typeof(self)weakSelf = self;
    [self.avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float currentTime = CMTimeGetSeconds(time);
        float totalTime = CMTimeGetSeconds(weakSelf.avPlayer.currentItem.duration);
        if (currentTime) {
            [ weakSelf.progressView setProgress:currentTime / totalTime ];
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        
    }else if ([keyPath isEqualToString:@"status"]){
        if (playerItem.status == AVPlayerItemStatusReadyToPlay){
            NSLog(@"playerItem is ready");
            [self.avPlayer play];
            [self refreshProgressView];
        } else{
            NSLog(@"load break");
        }
    }
}

@end
