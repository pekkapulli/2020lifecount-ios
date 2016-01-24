//
//  iPad_ScoreViewController.m
//  Life Count
//
//  Created by Pekka Pulli on 9/17/13.
//  Copyright (c) 2013 Pekka Pulli. All rights reserved.
//

#import "iPad_ScoreViewController.h"

@interface iPad_ScoreViewController ()

@end

@implementation iPad_ScoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.enemyPoisonLabel.poisonMargin = 58;
    self.ownPoisonLabel.poisonMargin = 58;
    // Do any additional setup after loading the view from its nib.
}

- (float)getResetThreshold {
    return 0.3;
}

@end
