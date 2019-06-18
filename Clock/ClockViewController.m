//
//  ClockViewController.m
//  Clock
//
//  Created by hudongyang on 2019/6/10.
//  Copyright © 2019 hudongyang. All rights reserved.
//

#import "ClockViewController.h"
#import "ClockView.h"

@interface ClockViewController ()

@property (nonatomic, weak) NSTimer *timer;

@end

@implementation ClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

- (void)loadView {
    self.view = ClockView.new;    
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)tick {
    [self.view setNeedsDisplay];
}

@end
