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
#import "UPNSpeakerListModel.h"
#import <QuartzCore/QuartzCore.h>


const NSString *timeUpdateSegue = @"timeUpdateSegue";

@interface UPNViewController ()
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer *upGesture;
@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeRight;

@property (weak, nonatomic) IBOutlet UILabel *currentPresenterName;
@property (weak, nonatomic) IBOutlet UILabel *nextPresenterName;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPresenterAnimated;
@property (weak, nonatomic) IBOutlet UILabel *nextPresenterAnimated;
@property (weak, nonatomic) IBOutlet UILabel *nextPresenterFromBelow;

@property (assign, nonatomic) CGPoint nextPresenterAnimatedStartingPoint;
@property (assign, nonatomic) CGPoint nextPresenterHiddenStartingPoint;

@property (assign, nonatomic) BOOL timerHidden;
@property (strong, nonatomic) UIColor *timerOriginalBGColor;
@property (strong, nonatomic) UPNSpeakerListModel *speakerList;
@property (assign, nonatomic) BOOL timerRunning;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSUInteger time;
@property (strong, nonatomic) UPNClockModel *clock;
@property (assign, nonatomic) BOOL onStartReset;
@property (strong, nonatomic) UPNTimeUpdateViewController *timeUpdate;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@end

@implementation UPNViewController

#pragma - mark IBActions

- (IBAction)timerSwipedLeft:(UISwipeGestureRecognizer *)sender
{
    if (self.timerHidden) {
        [UIView animateWithDuration:1.0 animations:^{
            CGRect rect = self.timerLabel.frame;
            rect.origin.x = 0;
            [self.timerLabel setFrame:rect];
            self.timerLabel.backgroundColor = self.timerOriginalBGColor;
            self.timerHidden = NO;
        }];
    } else {
        [self restartTimerDisplay];
    }

}
- (IBAction)timerSwipedRight:(UISwipeGestureRecognizer *)sender {
    NSLog(@"Swiped right");
    [UIView animateWithDuration:1.0 animations:^{
        CGRect rect = self.timerLabel.frame;
        rect.origin.x = 300;
        [self.timerLabel setFrame:rect];
        self.timerOriginalBGColor = self.timerLabel.backgroundColor;
        self.timerLabel.backgroundColor = [UIColor grayColor];
        self.timerHidden = YES;
    }];
}

- (IBAction)swipeUpOnNextSpeaker:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:self.view];
    
    if( self.nextPresenterAnimatedStartingPoint.x == 0 ) {
        self.nextPresenterAnimatedStartingPoint = self.nextPresenterAnimated.frame.origin;
    }
    
    self.nextPresenterHiddenStartingPoint = self.nextPresenterFromBelow.frame.origin;
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if(point.y <= -75){
            self.currentPresenterName.hidden = YES;
            self.currentPresenterAnimated.hidden = NO;
            
            [self fadeOutAnimationForView:self.timerLabel];
            [self mainScrollUpAnimation];
        } else {
            [self restorePositionAnimation];
        }
        
        NSLog(@"Ended Gesture");
        return;
    }
    
    self.nextPresenterName.hidden = YES;
    self.nextPresenterAnimated.hidden = NO;
    [self.nextPresenterAnimated setFrame:CGRectMake(self.nextPresenterAnimatedStartingPoint.x,
                                                    self.nextPresenterAnimatedStartingPoint.y + point.y,
                                                    self.nextPresenterAnimated.frame.size.width,
                                                    self.nextPresenterAnimated.frame.size.height)];
}

- (IBAction)timeTapped:(UITapGestureRecognizer *)sender
{
    if(self.timerRunning) {
        [self stopTimer];
    } else {
        [self startTimer];
        __block UIColor *color = self.timerLabel.backgroundColor;
        self.timerLabel.backgroundColor = [UIColor whiteColor];
        [UIView animateWithDuration:0.5 animations:^{
            self.timerLabel.backgroundColor = color;
        }];
    }
}


-(IBAction)goBack:(UIStoryboardSegue *) segue
{
    UPNTimeUpdateViewController *updateVC = segue.sourceViewController;
    
    self.clock = [[UPNClockModel alloc]initWithMinutes:[updateVC.minutes.text intValue] seconds:[updateVC.seconds.text intValue]];
    [self setupClock:self.clock];
    [self restartTimerDisplay];
    [self stopTimer];
}

# pragma - mark Animations

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.fromValue = [NSNumber numberWithFloat:0.1];
    animation2.toValue = [NSNumber numberWithFloat:1.0];
    animation2.duration = 0.2;
    animation2.repeatCount = 1;
    [self.timerLabel.layer addAnimation:animation2 forKey:@"dim"];
    
    [self stopTimer];
    [self restartTimerDisplay];
}

- (void)fadeOutAnimationForView:(UIView *)view {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0.1];
    animation.duration = 0.3;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    animation.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:animation forKey:@"dim"];
}

- (void)mainScrollUpAnimation {
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
        [self resetAnimatedPresenterLabelPositions];
        
        [self moveNamesUpOneLabel];
        
        self.nextPresenterName.hidden = NO;
        self.nextPresenterAnimated.hidden = YES;
        self.nextPresenterAnimated.alpha = 0.5;
        self.currentPresenterName.hidden = NO;
        self.currentPresenterAnimated.hidden = YES;
        self.nextPresenterAnimatedStartingPoint = CGPointMake(0, 0);
        self.nextPresenterFromBelow.hidden = YES;
    }];
}

- (void)restorePositionAnimation {
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


- (void)moveNamesUpOneLabel {
    // Update the text in the labels to the next speaker
    [self currentPresenterName:self.nextPresenterName.text];
    [self nextPresenterName:self.nextPresenterFromBelow.text];
    [self nextPresenterFromBelowName:[self.speakerList nextSpeaker]];
}

- (void)resetAnimatedPresenterLabelPositions {
    [self.nextPresenterFromBelow setFrame:CGRectMake(self.nextPresenterHiddenStartingPoint.x,
                                                     self.nextPresenterHiddenStartingPoint.y,
                                                     self.nextPresenterFromBelow.frame.size.width,
                                                     self.nextPresenterFromBelow.frame.size.height)];
    
    [self.nextPresenterAnimated setFrame:self.nextPresenterName.frame];
    [self.currentPresenterAnimated setFrame:self.currentPresenterName.frame];
}

-(void) willRunTimeUpdateSegue:(UIStoryboardSegue *)segue
{
    UPNTimeUpdateViewController *inputVC = segue.destinationViewController;
    [inputVC setDefaultMinutes:[self.clock originalMinutesAsString] seconds:[self.clock originalSecondsAsString]];
}

#pragma - mark Timers

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


-(UPNTimeUpdateViewController *)timeUpdate
{
    if ( ! _timeUpdate) {
        _timeUpdate = [[UPNTimeUpdateViewController alloc]init];
    }
    
    return _timeUpdate;
}

- (void)soundAlarm
{
    self.timerLabel.textColor = [UIColor redColor];
}

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

#pragma - mark View Controller Functions

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Not sure I want the progress bar
    self.progress.hidden = YES;
    self.onStartReset = NO;
    self.timerRunning = NO;
    CGRect frame = self.nextPresenterFromBelow.frame;
    frame.origin.x = 200;
    self.nextPresenterHiddenStartingPoint = self.nextPresenterFromBelow.frame.origin;
    [self.nextPresenterFromBelow setFrame:frame];
    self.speakerList = [UPNSpeakerListModel sharedInstance];
    [self currentPresenterName:[self.speakerList nextSpeaker]];
    [self nextPresenterName:[self.speakerList nextSpeaker]];
    [self nextPresenterFromBelowName:[self.speakerList nextSpeaker]];
    self.clock = [[UPNClockModel alloc]initWithMinutes:5 seconds:0];
    [self setupClock:self.clock];

    self.timerLabel.text = [self.clock remainingTime];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"timeUpdateSegue"]) {
        [self willRunTimeUpdateSegue:segue];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma - mark Init methods

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

-(void)nextPresenterFromBelowName:(NSString*)name
{
    self.nextPresenterFromBelow.text = name;
}

-(void)nextPresenterName:(NSString*)name
{
    self.nextPresenterName.text = name;
    self.nextPresenterAnimated.text = name;
}

-(void)currentPresenterName:(NSString*)name
{
    self.currentPresenterName.text = name;
    self.currentPresenterAnimated.text = name;
}

@end
