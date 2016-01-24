//
//  SettingsViewController.h
//  Life Count
//
//  Created by Pekka Pulli on 6/7/13.
//  Copyright (c) 2013 Pekka Pulli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

//@property (strong, nonatomic) IBOutlet UIButton *uiPlayersButton;
@property (strong, nonatomic) IBOutlet UIButton *uiLifeTotalButton;
@property (strong, nonatomic) IBOutlet UIButton *uiPoisonButton;
@property (strong, nonatomic) IBOutlet UIButton *uiColorPickerButton;

//- (IBAction)changeNumberOfPlayers:(id)sender;
- (IBAction)changeStartingLifeTotal:(id)sender;
- (IBAction)togglePoison:(id)sender;
- (IBAction)toggleColorScheme:(id)sender;
- (IBAction)rateMeButtonPressed:(id)sender;
- (IBAction)twitterButtonPressed:(id)sender;
@end
