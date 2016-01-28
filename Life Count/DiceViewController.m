//
//  DiceViewController.m
//  Life Count
//
//  Created by Janne Kiirikki on 27/01/16.
//  Copyright © 2016 Pekka Pulli. All rights reserved.
//

#import "DiceViewController.h"
#import "UILifeLabel.h"
#import "Masonry/Masonry.h"
#import <Google/Analytics.h>

@implementation DiceViewController

- (instancetype)initWithBackground:(UIColor *)backgroundColor own:(UILifeLabel *)own enemy:(UILifeLabel *)enemy
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = backgroundColor;
        
        self.enemyDiceView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DiceBGRed"]];
        [self.view addSubview:self.enemyDiceView];
        
        self.ownDiceView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DiceBGBlue"]];
        [self.view addSubview:self.ownDiceView];
        
        self.closeButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CloseIcon"]];
        
        [self.view addSubview:self.closeButton];
        
        self.ownDice = [[UILabel alloc] initWithFrame:own.frame];
        self.ownDice.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:56];
        self.ownDice.textColor = own.textColor;
        self.ownDice.textAlignment = own.textAlignment;
        [self.view addSubview:self.ownDice];
        self.ownDice.text = [NSString stringWithFormat:@"%d", arc4random() % 20];
        
        self.enemyDice = [[UILabel alloc] initWithFrame:enemy.frame];
        self.enemyDice.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:56];
        self.enemyDice.textColor = enemy.textColor;
        self.enemyDice.textAlignment = enemy.textAlignment;
        [self.view addSubview:self.enemyDice];
        self.enemyDice.text = [NSString stringWithFormat:@"%d", arc4random() % 20];
        
        [self.ownDiceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.ownDice);
        }];
        
        [self.enemyDiceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.enemyDice);
        }];
        
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-15);
            make.top.equalTo(self.view).offset(15);
        }];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self.view addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startAnimation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*
     id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
     [tracker set:kGAIScreenName value:@"DiceViewController"];
     [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
     */
}

- (void)startAnimation
{
    self.timerStep = arc4random() % 30 + 10;
    self.ownNumber = arc4random() % 20;
    self.enemyNumber = arc4random() % 20;
    
    [self timerFired];
}

- (void)timerFired
{
    
    self.timerStep = self.timerStep - 1;
    
    if (self.timerStep > 0)
    {
        self.ownNumber = (self.ownNumber + 1) % 20;
        self.enemyNumber = (self.enemyNumber + 1) % 20;
        
        self.enemyDice.text = [NSString stringWithFormat:@"%i", self.ownNumber];
        self.ownDice.text = [NSString stringWithFormat:@"%i", self.enemyNumber];
        float nextInterval = 0.05;
        
        
        [NSTimer scheduledTimerWithTimeInterval:nextInterval
                                         target:self
                                       selector:@selector(timerFired)
                                       userInfo:nil
                                        repeats:NO];
    }

}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self startAnimation];
    }
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
