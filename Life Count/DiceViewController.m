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
    
    // animate?
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
