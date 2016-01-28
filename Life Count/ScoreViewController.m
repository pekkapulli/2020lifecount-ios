//
//  ScoreViewController.m
//  Life Count
//
//  Created by Pekka Pulli on 5/4/13.
//  Copyright (c) 2013 Pekka Pulli. All rights reserved.
//

#import "ScoreViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DiceViewController.h"
#import <Google/Analytics.h>

@interface ScoreViewController ()

@end

@implementation ScoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.ownLifeLabelLocationStartX = -5000;
    self.enemyLifeLabelLocationStartX = -5000;
    self.refreshed = NO;

    self.historyViewController = ((HistoryViewController *)self.revealController.rightViewController);
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.uiBackground addGestureRecognizer:panRecognizer];
    self.ownLifeLabel.delegate = self;
    self.enemyLifeLabel.delegate = self;
    self.ownPoisonLabel.delegate = self;
    self.enemyPoisonLabel.delegate = self;
    
    self.ownLifeLabel.isOwn = true;
    self.enemyLifeLabel.isOwn = false;
    self.ownPoisonLabel.isOwn = true;
    self.enemyPoisonLabel.isOwn = false;
    
    self.refreshIndicatorViewLeft.alpha = 0.0;
    self.refreshIndicatorViewRight.alpha = 0.0;
    self.refreshIndicatorViewLeftStartX = self.refreshIndicatorViewLeft.frame.origin.x;
    CGRect rightRefreshFrame = self.refreshIndicatorViewRight.frame;
    rightRefreshFrame.origin.x = [[UIScreen mainScreen] bounds].size.width-5;
    self.refreshIndicatorViewRight.frame = rightRefreshFrame;
    self.refreshIndicatorViewRightStartX = self.refreshIndicatorViewRight.frame.origin.x;
    
    [self readUserDefaults];
    [self showingFrontView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"ScoreViewController"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Handle touch gestures

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.ownLifeLabelLocationStartX == -5000) {
        self.ownLifeLabelLocationStartX = self.ownLifeLabel.frame.origin.x;
        self.enemyLifeLabelLocationStartX = self.enemyLifeLabel.frame.origin.x;
        self.ownPoisonViewLocationStartX = self.ownPoisonView.frame.origin.x;
        self.enemyPoisonViewLocationStartX = self.enemyPoisonView.frame.origin.x;
    }
    
    [self rotateRefreshArrowsToDefault:YES withAnimation:NO];
    
    self.refreshLabelLeft.text = @"Reset";
    self.refreshLabelRight.text = @"Reset";
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    [self.refreshIndicatorViewLeft.layer removeAllAnimations];
    CGPoint pt = [sender translationInView:self.view];
    
    self.refreshIndicatorViewLeft.alpha = 1.0;
    self.refreshIndicatorViewRight.alpha = 1.0;
    
    CGRect ownLifeLabelPosition = self.ownLifeLabel.frame;
    CGRect enemyLifeLabelPosition = self.enemyLifeLabel.frame;
    CGRect ownPoisonViewPosition = self.ownPoisonView.frame;
    CGRect enemyPoisonViewPosition = self.enemyPoisonView.frame;
    CGRect refreshIndicatorPositionLeft = self.refreshIndicatorViewLeft.frame;
    CGRect refreshIndicatorPositionRight = self.refreshIndicatorViewRight.frame;
    float ownSpeed = 10.0f;
    float enemySpeed = 5.0f;
    if (pt.x < 0) { // drag direction
        ownSpeed = 5.0f;
        enemySpeed = 10.0f;
    }
    ownLifeLabelPosition.origin.x = self.ownLifeLabelLocationStartX + pt.x/ownSpeed;
    enemyLifeLabelPosition.origin.x = self.enemyLifeLabelLocationStartX + pt.x/enemySpeed;
    ownPoisonViewPosition.origin.x = self.ownPoisonViewLocationStartX + pt.x/ownSpeed;
    enemyPoisonViewPosition.origin.x = self.enemyPoisonViewLocationStartX + pt.x/enemySpeed;
    refreshIndicatorPositionLeft.origin.x = self.refreshIndicatorViewLeftStartX + pt.x/5.0f;
    refreshIndicatorPositionRight.origin.x = self.refreshIndicatorViewRightStartX + pt.x/5.0f;
    
    self.ownLifeLabel.frame = ownLifeLabelPosition;
    self.enemyLifeLabel.frame = enemyLifeLabelPosition;
    self.ownPoisonView.frame = ownPoisonViewPosition;
    self.enemyPoisonView.frame = enemyPoisonViewPosition;
    self.refreshIndicatorViewLeft.frame = refreshIndicatorPositionLeft;
    self.refreshIndicatorViewRight.frame = refreshIndicatorPositionRight;
    
    if (fabs(pt.x) > [[UIScreen mainScreen] bounds].size.height*[self getResetThreshold]) {
        if (!self.refreshed) {
            [self.ownLifeLabel reset];
            [self.enemyLifeLabel reset];
            [self.ownPoisonLabel reset];
            [self.enemyPoisonLabel reset];
            self.refreshLabelLeft.text = @"Cancel";
            self.refreshLabelRight.text = @"Cancel";
            [self rotateRefreshArrowsToDefault:NO withAnimation:YES];
            self.refreshed = YES;
        }
    } else {
        if (self.refreshed) {
            [self rotateRefreshArrowsToDefault:YES withAnimation:YES];
            self.refreshLabelLeft.text = @"Reset";
            self.refreshLabelRight.text = @"Reset";
            [self.ownLifeLabel undoReset];
            [self.enemyLifeLabel undoReset];
            [self.ownPoisonLabel undoReset];
            [self.enemyPoisonLabel undoReset];
            self.refreshed = NO;
        }
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.3 animations:^{
            // set new position of label which it will animate to
            CGRect ownOldPos = self.ownLifeLabel.frame;
            ownOldPos.origin.x=self.ownLifeLabelLocationStartX;
            self.ownLifeLabel.frame = ownOldPos;
            CGRect enemyOldPos = self.enemyLifeLabel.frame;
            enemyOldPos.origin.x=self.enemyLifeLabelLocationStartX;
            self.enemyLifeLabel.frame = enemyOldPos;

            CGRect ownPoisonOldPos = self.ownPoisonView.frame;
            ownPoisonOldPos.origin.x=self.ownPoisonViewLocationStartX;
            self.ownPoisonView.frame = ownPoisonOldPos;
            CGRect enemyPoisonOldPos = self.enemyPoisonView.frame;
            enemyPoisonOldPos.origin.x=self.enemyPoisonViewLocationStartX;
            self.enemyPoisonView.frame = enemyPoisonOldPos;
            
            //Return refresh arrows
            CGRect refreshLeftOldPos = self.refreshIndicatorViewLeft.frame;
            refreshLeftOldPos.origin.x = self.refreshIndicatorViewLeftStartX;
            self.refreshIndicatorViewLeft.frame = refreshLeftOldPos;
            self.refreshIndicatorViewLeft.alpha = 0.0;
            
            CGRect refreshRightOldPos = self.refreshIndicatorViewRight.frame;
            refreshRightOldPos.origin.x = self.refreshIndicatorViewRightStartX;
            self.refreshIndicatorViewRight.frame = refreshRightOldPos;
            self.refreshIndicatorViewRight.alpha = 0.0;
        }];
        if (self.refreshed) {
            [self reset];
        }
        self.refreshed = NO;
        self.eventOrigin = nil;
    }
}

-(void)rotateRefreshArrowsToDefault:(BOOL)toDefault withAnimation:(BOOL)animated {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animated?0.3:0.0];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transformLeft;
    CGAffineTransform transformRight;
    if (toDefault) {
        transformLeft = CGAffineTransformMakeRotation(0);
        transformRight = CGAffineTransformMakeRotation(M_PI);
    } else {
        transformLeft = CGAffineTransformMakeRotation(M_PI);
        transformRight = CGAffineTransformMakeRotation(0);
    }
    self.refreshArrowImageLeft.transform = transformLeft;
    self.refreshArrowImageRight.transform = transformRight;
    
    // Commit the changes
    [UIView commitAnimations];
}

- (void)bounceResetWithDelay:(BOOL)withDelay {
    NSLog(@"start: %f",self.refreshIndicatorViewLeft.frame.origin.x);
    self.refreshIndicatorViewLeft.alpha = 1.0;
    [UIView animateWithDuration:0.3
                          delay:withDelay?1.0:0
                        options:(UIViewAnimationCurveEaseOut)
                     animations:^{
                         //Move refresh arrows
                         CGRect refreshLeftOldPos = self.refreshIndicatorViewLeft.frame;
                         refreshLeftOldPos.origin.x = 0;
                         self.refreshIndicatorViewLeft.frame = refreshLeftOldPos;
                     } completion:^(BOOL finished){
                         if (finished) {
                             [UIView animateWithDuration:0.3
                                                   delay:0.3
                                                 options:(UIViewAnimationCurveEaseIn)
                                              animations:^{
                                                  NSLog(@"mid: %f",self.refreshIndicatorViewLeft.frame.origin.x);

                                                  CGRect refreshLeftOldPos = self.refreshIndicatorViewLeft.frame;
                                                  refreshLeftOldPos.origin.x = self.refreshIndicatorViewLeftStartX;
                                                  self.refreshIndicatorViewLeft.frame = refreshLeftOldPos;
                                              } completion:^(BOOL finished){
                                                  if (finished) {
                                                      self.refreshIndicatorViewLeft.alpha = 0.0;
                                                      CGRect newLocation = self.refreshIndicatorViewLeft.frame;
                                                      newLocation.origin.x = self.refreshIndicatorViewLeftStartX;
                                                      self.refreshIndicatorViewLeft.frame = newLocation;
                                                      NSLog(@"end: %f",self.refreshIndicatorViewLeft.frame.origin.x);
                                                  }
                                              }];
                         }
                     }];
}

- (void)reset {
    [self.historyViewController resetHistory];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.ownLifeLabel.text forKey:@"own life"];
    [defaults setObject:self.enemyLifeLabel.text forKey:@"enemy life"];
    [defaults setObject:self.ownPoisonLabel.text forKey:@"own poison"];
    [defaults setObject:self.enemyPoisonLabel.text forKey:@"enemy poison"];
    if (![defaults boolForKey:@"user found reset"]) {
        [defaults setBool:YES forKey:@"user found reset"];
    }
    [defaults synchronize];
}

#pragma mark handle sidebar actions

- (IBAction)showLog:(id)sender {
    [self.revealController showViewController:self.revealController.rightViewController];

    [self.ownLifeLabel fireTimer];
    [self.ownPoisonLabel fireTimer];
    [self.enemyLifeLabel fireTimer];
    [self.enemyPoisonLabel fireTimer];
}

- (IBAction)showSettings:(id)sender {
    [self.revealController showViewController:self.revealController.leftViewController];
}

- (void)showingFrontView {
    //NSLog(@"showing front view and adding recognizers");
    //[self.historyViewButton addGestureRecognizer:self.revealController.revealPanGestureRecognizer];
    //[self.settingsViewButton addGestureRecognizer:self.revealController.revealPanGestureRecognizer];
}

#pragma mark - UILifeLabelDelegate

- (void)lifeLabelChangedValue:(UILifeLabel *)lifeLabel {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (lifeLabel == self.ownLifeLabel || lifeLabel == self.enemyLifeLabel) { //life totals
        BOOL ownLife = lifeLabel == self.ownLifeLabel;
        NSString *labelText = lifeLabel.text;
        NSInteger amount = [labelText integerValue];
        if (amount == 0) {
            [self bounceResetWithDelay:NO];
        }
        [defaults setObject:labelText forKey:(ownLife?@"own life":@"enemy life")];
    } else {                                                                  //poison totals
        BOOL ownLife = lifeLabel == self.ownPoisonLabel;
        NSString *labelText = lifeLabel.text;
        NSInteger amount = [labelText integerValue];
        if (amount == 10) {
            [self bounceResetWithDelay:NO];
        }
        [defaults setObject:labelText forKey:(ownLife?@"own poison":@"enemy poison")];
    }
    
    [defaults synchronize];
}

- (void)logLifeLabelEventForPlayer:(BOOL)own poison:(BOOL)poison newAmount:(NSInteger)newAmount change:(NSInteger)change {
    [self.historyViewController lifeTotalChangedWithPlayer:own isPoison:poison toAmount:newAmount change:change];
}

- (void)lifeLabelDragHappened:(UIPanGestureRecognizer *)sender {
    if (self.eventOrigin == nil) {
        self.eventOrigin = sender.view;
    }
    if (self.eventOrigin == sender.view) {
        [self handlePanGesture:sender];
    }
}

- (void)lifeLabelTouchHappened:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesBegan:touches withEvent:event];
}

#pragma mark Settings

- (void)readUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"own life"] != nil) {
        self.ownLifeLabel.text = [defaults objectForKey:@"own life"];
    } else if ([defaults valueForKey:@"starting life total"] != nil) {
            self.ownLifeLabel.text = [defaults valueForKey:@"starting life total"];
    }
    
    if ([defaults objectForKey:@"enemy life"] != nil) {
        self.enemyLifeLabel.text = [defaults objectForKey:@"enemy life"];
    } else if ([defaults valueForKey:@"starting life total"] != nil) {
        self.enemyLifeLabel.text = [defaults valueForKey:@"starting life total"];
    }
    
    if ([defaults objectForKey:@"own poison"] != nil) {
        self.ownPoisonLabel.text = [defaults objectForKey:@"own poison"];
    } else {
        self.ownPoisonLabel.text = @"0";
    }
    
    if ([defaults objectForKey:@"enemy poison"] != nil) {
        self.enemyPoisonLabel.text = [defaults objectForKey:@"enemy poison"];
    } else {
        self.enemyPoisonLabel.text = @"0";
    }
    
    if (![defaults boolForKey:@"user found reset"]) {
        [self bounceResetWithDelay:YES];
    }
    
    if ([defaults boolForKey:@"dark color scheme"]) {
        [self.uiDarkBackground setAlpha:1];
    }
    
    if ([defaults boolForKey:@"poison counter shown"]) {
        [self.ownPoisonView setAlpha:1];
        [self.enemyPoisonView setAlpha:1];
    } else {
        [self.ownPoisonView setAlpha:0];
        [self.enemyPoisonView setAlpha:0];
    }
}

- (void)setColorSchemeToDark:(BOOL)setDark {
    if (setDark) {
        [UIView animateWithDuration:0.50 animations:^{
            [self.uiDarkBackground setAlpha:1];
        }];
    } else {
        [UIView animateWithDuration:0.50 animations:^{
            [self.uiDarkBackground setAlpha:0];
        }];
    }
}

- (void)setPoisonVisible:(BOOL)visible {
    if (visible) {
        [UIView animateWithDuration:0.50 animations:^{
            [self.ownPoisonView setAlpha:1];
            [self.enemyPoisonView setAlpha:1];
        }];
    } else {
        [UIView animateWithDuration:0.50 animations:^{
            [self.ownPoisonView setAlpha:0];
            [self.enemyPoisonView setAlpha:0];
        }];
    }
}

- (float)getResetThreshold {
    return 0.5;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self shakeHappened];
    }
}

- (void)shakeHappened
{
    UIColor *bgColor =  self.uiDarkBackground.alpha ? self.uiDarkBackground.backgroundColor : self.uiBackground.backgroundColor;
    DiceViewController *diceViewController = [[DiceViewController alloc] initWithBackground:bgColor own:self.ownLifeLabel enemy:self.enemyLifeLabel];
    diceViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:diceViewController animated:YES completion:nil];
}

@end
