//
//  SettingsViewController.m
//  Life Count
//
//  Created by Pekka Pulli on 6/7/13.
//  Copyright (c) 2013 Pekka Pulli. All rights reserved.
//

#import "SettingsViewController.h"
#import "ScoreViewController.h"
#import "PKRevealController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self.revealController setMinimumWidth:240.0f maximumWidth:240.0f forViewController:self];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"dark color scheme"]) {
        [self.uiColorPickerButton setSelected:YES];
    }
    if ([defaults valueForKey:@"starting life total"]) {
        NSString *startingLifeTotal = [defaults valueForKey:@"starting life total"];
        [self.uiLifeTotalButton setTitle:startingLifeTotal forState:UIControlStateNormal];
        [self.uiLifeTotalButton setTitle:startingLifeTotal forState:UIControlStateHighlighted];
    }
    if ([defaults boolForKey:@"poison counter shown"]) {
        [self.uiPoisonButton setSelected:YES];
        [self.uiPoisonButton setTitle:@"on" forState:UIControlStateHighlighted];
    } else {
        [self.uiPoisonButton setSelected:NO];
        [self.uiPoisonButton setTitle:@"off" forState:UIControlStateHighlighted];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark button actions

/*- (IBAction)changeNumberOfPlayers:(id)sender {
    UIButton *numberOfPlayersButton = (UIButton*)sender;
    NSInteger currentValue = [[[numberOfPlayersButton titleLabel] text] integerValue];
    NSInteger newValue = 0;
    if (currentValue < 6) {
        newValue = currentValue + 1;
    } else {
        newValue = 2;
    }
    NSString *newStringValue = [NSString stringWithFormat:@"%d",newValue];
    [numberOfPlayersButton setTitle:newStringValue forState:UIControlStateNormal];
    [numberOfPlayersButton setTitle:newStringValue forState:UIControlStateHighlighted];
    [[NSUserDefaults standardUserDefaults]  setValue:newStringValue forKey:@"number of players"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}*/

- (IBAction)changeStartingLifeTotal:(id)sender {
    UIButton *lifeTotalButton = (UIButton*)sender;
    NSInteger currentValue = [[[lifeTotalButton titleLabel] text] integerValue];
    NSInteger newValue = 0;
    if (currentValue < 40) {
        newValue = currentValue + 10;
    } else {
        newValue = 20;
    }
    NSString *newStringValue = [NSString stringWithFormat:@"%ld",(long)newValue];
    [lifeTotalButton setTitle:newStringValue forState:UIControlStateNormal];
    [lifeTotalButton setTitle:newStringValue forState:UIControlStateHighlighted];
    [[NSUserDefaults standardUserDefaults]  setValue:newStringValue forKey:@"starting life total"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)togglePoison:(id)sender {
    UIButton *toggleButton = (UIButton*)sender;
    if ([toggleButton isSelected]) { // Selected == poison counter on
        [toggleButton setSelected:NO];
        [toggleButton setTitle:@"off" forState:UIControlStateHighlighted];
        [(ScoreViewController*)[self.revealController frontViewController] setPoisonVisible:NO];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"poison counter shown"];
    } else {
        [toggleButton setSelected:YES];
        [toggleButton setTitle:@"on" forState:UIControlStateHighlighted];
        [(ScoreViewController*)[self.revealController frontViewController] setPoisonVisible:YES];
        [[NSUserDefaults standardUserDefaults]  setBool:YES forKey:@"poison counter shown"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)toggleColorScheme:(id)sender {
    UIButton *toggleButton = (UIButton*)sender;
    if ([toggleButton isSelected]) { // Selected == dark mode
        [toggleButton setSelected:NO];
        [(ScoreViewController*)[self.revealController frontViewController] setColorSchemeToDark:NO];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"dark color scheme"];
    } else {
        [toggleButton setSelected:YES];
        [(ScoreViewController*)[self.revealController frontViewController] setColorSchemeToDark:YES];
        [[NSUserDefaults standardUserDefaults]  setBool:YES forKey:@"dark color scheme"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)rateMeButtonPressed:(id)sender {
    NSString *str = @"https://itunes.apple.com/us/app/20-20-life-count/id649385525";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (IBAction)twitterButtonPressed:(id)sender {
    NSString *myProfile = @"twitter://user?screen_name=2020lifecount";
    NSURL *url = [NSURL URLWithString:myProfile];
    
    if ([[UIApplication sharedApplication] canOpenURL: url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        myProfile = @"https://twitter.com/2020lifecount";
        url = [NSURL URLWithString:myProfile];
        [[UIApplication sharedApplication] openURL:url];
    }
}
@end
