//
//  DiceViewController.h
//  Life Count
//
//  Created by Janne Kiirikki on 27/01/16.
//  Copyright © 2016 Pekka Pulli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UILifeLabel;

@interface DiceViewController : UIViewController

- (instancetype)initWithBackground:(UIColor *)backgroundColor own:(UILifeLabel *)own enemy:(UILifeLabel *)enemy;

@property (strong, nonatomic) UILabel *ownDice;
@property (strong, nonatomic) UILabel *enemyDice;
@end
