//
//  ScoreViewController.h
//  Life Count
//
//  Created by Pekka Pulli on 5/4/13.
//  Copyright (c) 2013 Pekka Pulli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILifeLabel.h"
#import "UIPoisonLabel.h"
#import "HistoryViewController.h"
#import "Controller/PKRevealController.h"

@interface ScoreViewController : UIViewController <UILifeLabelDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *uiBackgroundImage;
@property (strong, nonatomic) IBOutlet UIImageView *uiDarkBackgroundImage;
@property (strong, nonatomic) IBOutlet UIButton *historyViewButton;
@property (strong, nonatomic) IBOutlet UIButton *settingsViewButton;
@property (strong, nonatomic) IBOutlet UILifeLabel *ownLifeLabel;
@property (strong, nonatomic) IBOutlet UILifeLabel *enemyLifeLabel;
@property (strong, nonatomic) IBOutlet UIView *ownPoisonView;
@property (strong, nonatomic) IBOutlet UIView *enemyPoisonView;
@property (strong, nonatomic) IBOutlet UIPoisonLabel *ownPoisonLabel;
@property (strong, nonatomic) IBOutlet UIPoisonLabel *enemyPoisonLabel;


@property (strong, nonatomic) IBOutlet UIView *refreshIndicatorViewLeft;
@property (strong, nonatomic) IBOutlet UIImageView *refreshArrowImageLeft;
@property (strong, nonatomic) IBOutlet UILabel *refreshLabelLeft;
@property (strong, nonatomic) IBOutlet UIView *refreshIndicatorViewRight;
@property (strong, nonatomic) IBOutlet UIImageView *refreshArrowImageRight;
@property (strong, nonatomic) IBOutlet UILabel *refreshLabelRight;

@property (assign, nonatomic) float ownLifeLabelLocationStartX;
@property (assign, nonatomic) float enemyLifeLabelLocationStartX;
@property (assign, nonatomic) float ownPoisonViewLocationStartX;
@property (assign, nonatomic) float enemyPoisonViewLocationStartX;
@property (assign, nonatomic) float refreshIndicatorViewLeftStartX;
@property (assign, nonatomic) float refreshIndicatorViewRightStartX;

@property (assign, nonatomic) BOOL refreshed;
@property (assign, nonatomic) UIView *eventOrigin;

@property (strong, nonatomic) HistoryViewController *historyViewController;

- (IBAction)showLog:(id)sender;
- (IBAction)showSettings:(id)sender;

- (void)showingFrontView;

- (void) setColorSchemeToDark:(BOOL)setDark;
- (void) setPoisonVisible:(BOOL)visible;

@end
