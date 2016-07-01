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
@property (nonatomic, strong) AVPlayer *avPlayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat ratio = 9.0 / 16.0;
    UIView *playView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth * ratio)];
    playView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:playView];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:@"http://45.113.121.198/bangbang/2016-06-29/bangbang_20160629015256.mp4"]];
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    self.avPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
  //  playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
   // playerLayer.contentsScale = [UIScreen mainScreen].scale;
    playerLayer.frame = playView.bounds;
    [playView.layer addSublayer:playerLayer];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        
    }else if ([keyPath isEqualToString:@"status"]){
        if (playerItem.status == AVPlayerItemStatusReadyToPlay){
            NSLog(@"playerItem is ready");
            [self.avPlayer play];
        } else{
            NSLog(@"load break");
        }
    }
}

@end
