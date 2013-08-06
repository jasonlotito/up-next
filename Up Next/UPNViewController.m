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
@property (weak, nonatomic) IBOutlet UILabel *currentPresenterAnimated;
@property (weak, nonatomic) IBOutlet UILabel *nextPresenterAnimated;
@property (weak, nonatomic) IBOutlet UILabel *nextPresenterFromBelow;

@property (assign, nonatomic) CGPoint nextPresenterAnimatedStartingPoint;
@property (assign, nonatomic) CGPoint nextPresenterHiddenStartingPoint;

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
//
//-(IBAction)swipeUpOnNextSpeaker:(UISwipeGestureRecognizer *)sender {
//    NSLog(@"swipe up");
//}
- (IBAction)swipeUpOnNextSpeaker:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if(point.y <= -50){
            self.currentPresenterName.hidden = YES;
            self.currentPresenterAnimated.hidden = NO;

            [UIView animateWithDuration:0.5 animations:^{
                NSLog(@"Staring animation");
                
                [self.nextPresenterAnimated setFrame:self.currentPresenterName.frame];
                self.nextPresenterAnimated.alpha = 1.0;
                [self.currentPresenterAnimated setFrame:CGRectMake(self.currentPresenterAnimated.frame.origin.x,
                                                                  self.currentPresenterAnimated.frame.origin.y - 100,
                                                                  self.currentPresenterAnimated.frame.size.width,
                                                                  self.currentPresenterAnimated.frame.size.height)];
                self.nextPresenterFromBelow.hidden = NO;
                [self.nextPresenterFromBelow setFrame:self.nextPresenterName.frame];

            } completion:^(BOOL finished) {
                [self.nextPresenterAnimated setFrame:CGRectMake(self.nextPresenterAnimatedStartingPoint.x,
                                                                self.nextPresenterAnimatedStartingPoint.y,
                                                                self.nextPresenterAnimated.frame.size.width,
                                                                self.nextPresenterAnimated.frame.size.height)];
                [self.nextPresenterFromBelow setFrame:CGRectMake(self.nextPresenterHiddenStartingPoint.x,
                                                                 self.nextPresenterHiddenStartingPoint.y,
                                                                 self.nextPresenterFromBelow.frame.size.width,
                                                                 self.nextPresenterFromBelow.frame.size.height)];
                
                [self.nextPresenterAnimated setFrame:self.nextPresenterName.frame];
                
                [self.currentPresenterAnimated setFrame:self.currentPresenterName.frame];
                self.currentPresenterName.text = self.nextPresenterName.text;
                self.nextPresenterName.hidden = NO;
                self.nextPresenterAnimated.hidden = YES;
                self.nextPresenterAnimated.alpha = 0.5;
                self.currentPresenterName.hidden = NO;
                self.currentPresenterAnimated.hidden = YES;
                self.nextPresenterAnimatedStartingPoint = CGPointMake(0, 0);
                self.nextPresenterFromBelow.hidden = YES;

            }];
            
        } else {
            [UIView animateWithDuration:0.5 animations:^{
                [self.nextPresenterAnimated setFrame:CGRectMake(self.nextPresenterAnimatedStartingPoint.x,
                                                                self.nextPresenterAnimatedStartingPoint.y,
                                                                self.nextPresenterAnimated.frame.size.width,
                                                                self.nextPresenterAnimated.frame.size.height)];
                [self.nextPresenterFromBelow setFrame:CGRectMake(self.nextPresenterHiddenStartingPoint.x,
                                                                 self.nextPresenterHiddenStartingPoint.y,
                                                                 self.nextPresenterFromBelow.frame.size.width,
                                                                 self.nextPresenterFromBelow.frame.size.height)];
            } completion:^(BOOL finished) {
                self.nextPresenterName.hidden = NO;
                self.nextPresenterAnimated.hidden = YES;
            }];
        }
        
        NSLog(@"Ended Gesture");
        return;
    }
    
    if( self.nextPresenterAnimatedStartingPoint.x == 0 ) {
        self.nextPresenterAnimatedStartingPoint = self.nextPresenterAnimated.frame.origin;
    }
    
    if( self.nextPresenterHiddenStartingPoint.x == 0 ) {
        self.nextPresenterHiddenStartingPoint = self.nextPresenterFromBelow.frame.origin;
    }
    
    NSLog(@"swipe up x: %f, y: %f", [sender translationInView:self.view].x, [sender translationInView:self.view].y);

    self.nextPresenterName.hidden = YES;
    self.nextPresenterAnimated.hidden = NO;
    [self.nextPresenterAnimated setFrame:CGRectMake(self.nextPresenterAnimatedStartingPoint.x,
                                                   self.nextPresenterAnimatedStartingPoint.y + point.y,
                                                   self.nextPresenterAnimated.frame.size.width,
                                                   self.nextPresenterAnimated.frame.size.height)];
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
             seconds:30
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
