//
//  DiceViewController.m
//  Life Count
//
//  Created by Janne Kiirikki on 27/01/16.
//  Copyright © 2016 Pekka Pulli. All rights reserved.
//

#import "DiceViewController.h"
#import "UILifeLabel.h"

@implementation DiceViewController

- (instancetype)initWithBackground:(UIColor *)backgroundColor own:(UILifeLabel *)own enemy:(UILifeLabel *)enemy
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = backgroundColor;
        
        self.ownDice = [[UILabel alloc] initWithFrame:own.frame];
        self.ownDice.font = own.font;
        self.ownDice.textColor = own.textColor;
        self.ownDice.textAlignment = own.textAlignment;
        [self.view addSubview:self.ownDice];
        self.ownDice.text = [NSString stringWithFormat:@"%d", arc4random() % 20];
        
        self.enemyDice = [[UILabel alloc] initWithFrame:enemy.frame];
        self.enemyDice.font = enemy.font;
        self.enemyDice.textColor = enemy.textColor;
        self.enemyDice.textAlignment = enemy.textAlignment;
        [self.view addSubview:self.enemyDice];
        self.enemyDice.text = [NSString stringWithFormat:@"%d", arc4random() % 20];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self.view addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
