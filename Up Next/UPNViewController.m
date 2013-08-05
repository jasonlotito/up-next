//
//  UPNViewController.m
//  Up Next
//
//  Created by Jason Lotito on 8/2/13.
//  Copyright (c) 2013 Jason Lotito. All rights reserved.
//

#import "UPNViewController.h"
#import "UPNClockModel.h"
#import "UPNTimeUpdateViewController.h"

const NSString *timeUpdateSegue = @"timeUpdateSegue";

@interface UPNViewController ()
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer *upGesture;
@property (weak, nonatomic) IBOutlet UILabel *currentPresenterName;
@property (weak, nonatomic) IBOutlet UILabel *nextPresenterName;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (assign, nonatomic) BOOL timerRunning;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSUInteger time;
@property (strong, nonatomic) UPNClockModel *clock;
@property (assign, nonatomic) BOOL onStartReset;
@property (strong, nonatomic) UPNTimeUpdateViewController *timeUpdate;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@end

@implementation UPNViewController
- (void)resetTimerDisplayStylePreAlarm
{
    self.timerLabel.textColor = [UIColor whiteColor];
}

- (void)restartTimerDisplay
{
    [self.clock reset];
    [self resetTimerDisplayStylePreAlarm];
    [self updateTimeDisplay];
}

- (IBAction)timerSwipedLeft:(UISwipeGestureRecognizer *)sender
{
    [self restartTimerDisplay];
}

-(UPNTimeUpdateViewController *)timeUpdate
{
    if ( ! _timeUpdate) {
        _timeUpdate = [[UPNTimeUpdateViewController alloc]init];
    }
    
    return _timeUpdate;
}

- (IBAction)timerSwipedUp:(UISwipeGestureRecognizer *)sender {
//    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
//    datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
//    [self.view addSubview:datePicker];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"timeUpdateSegue"]) {
        [self willRunTimeUpdateSegue:segue];
    }
}

-(void) willRunTimeUpdateSegue:(UIStoryboardSegue *)segue
{
    UPNTimeUpdateViewController *inputVC = segue.destinationViewController;
    [inputVC setDefaultMinutes:[self.clock originalMinutesAsString] seconds:[self.clock originalSecondsAsString]];
}

- (IBAction)timeTapped:(UITapGestureRecognizer *)sender
{
    if(self.timerRunning) {
        [self stopTimer];
    } else {
        [self startTimer];
    }
}

-(void) startTimer
{
    if(self.onStartReset)
    {
        [self restartTimerDisplay];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(updateTime)
                                                userInfo:nil
                                                 repeats:YES];
    self.timerRunning = YES;
}

-(void) finishTimer
{
    [self stopTimer];
    self.onStartReset = YES;
}

-(void) stopTimer
{
    [self.timer invalidate];
    self.timerRunning = NO;
}

- (void)updateTimeDisplay
{
    self.timerLabel.text = [self.clock remainingTime];
    [self.progress setProgress:[self.clock progress]];
    NSLog(@"%f", [self.clock progress]);
}

-(void)updateTime
{
    [self.clock decrementBySeconds:1];
    [self updateTimeDisplay];
}

- (void)soundAlarm
{
    self.timerLabel.textColor = [UIColor redColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Not sure I want the progress bar
    self.progress.hidden = YES;
    self.onStartReset = NO;
    self.timerRunning = NO;
    self.clock = [[UPNClockModel alloc]initWithMinutes:5 seconds:0];
    [self setupClock:self.clock];

    self.timerLabel.text = [self.clock remainingTime];
}

- (void)setupClock:(UPNClockModel *)clock
{
    __block UPNViewController *vc = self;
    [clock atMinutes:0
                  seconds:2
               soundAlarm:^{
                   [vc soundAlarm];
               }];
    
    clock.clockFinished = ^{
        [vc finishTimer];
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)flipBack:(UIStoryboardSegue *) segue
{
    
}

-(IBAction)goBack:(UIStoryboardSegue *) segue
{
    UPNTimeUpdateViewController *updateVC = segue.sourceViewController;

    self.clock = [[UPNClockModel alloc]initWithMinutes:[updateVC.minutes.text intValue] seconds:[updateVC.seconds.text intValue]];
    [self setupClock:self.clock];
    [self restartTimerDisplay];
    [self stopTimer];
}

@end
