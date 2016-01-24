//
//  HistoryViewController.m
//  Life Count
//
//  Created by Pekka Pulli on 5/2/13.
//  Copyright (c) 2013 Pekka Pulli. All rights reserved.
//

#import "HistoryViewController.h"
#import "Controller/PKRevealController.h"
#import "HistoryViewCell.h"

#define WAIT_TIME 1.5

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults valueForKey:@"history data"] != nil) {
            self.dataRows = [NSMutableArray arrayWithArray:[defaults objectForKey:@"history data"]];
            if ([self.dataRows lastObject] != nil) {
                NSString *changeTime = [(NSDictionary*)[self.dataRows lastObject] valueForKey:@"time"];
                self.minuteCount = [changeTime integerValue];
            } else {
                self.minuteCount = 0;
            }
        } else {
            self.dataRows = [[NSMutableArray alloc] init];
            self.minuteCount = 0;
            [self setInitValuesForOwnLife:@"20" enemyLife:@"20"];
        }
        
        self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(addMinute) userInfo:nil repeats:YES];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.historyTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //[self.revealController setMinimumWidth:240.0f maximumWidth:240.0f forViewController:self];
    [self.historyTableView setContentInset:UIEdgeInsetsMake(12,0,12,0)];
    
    self.historyTableView.autoresizingMask = ( UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth );
    self.historyTableView.dataSource = self;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Log logic

- (void)resetHistory {
    [self.dataRows removeAllObjects];
    self.minuteCount = 0;
    [self.gameTimer invalidate];
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(addMinute) userInfo:nil repeats:YES];
    NSString *startingLifeTotal = @"20";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"starting life total"] != nil) {
        startingLifeTotal = [defaults valueForKey:@"starting life total"];
    }
    [self setInitValuesForOwnLife:startingLifeTotal enemyLife:startingLifeTotal];
}

- (void)setInitValuesForOwnLife:(NSString*)ownLife enemyLife:(NSString*)enemyLife {
    NSDictionary *row = [NSDictionary dictionaryWithObjects:
                         [NSArray arrayWithObjects:@"0", ownLife, enemyLife, @"0",[self getCurrentTime], nil]
                                      forKeys:
                         [NSArray arrayWithObjects:@"isPoison", @"ownScore", @"enemyScore", @"change", @"time", nil]];
    
    [self.dataRows addObject:row];
    [self.historyTableView reloadData];
    [[NSUserDefaults standardUserDefaults] setObject:self.dataRows forKey:@"history data"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)lifeTotalChangedWithPlayer:(BOOL)ownLife isPoison:(BOOL)poison toAmount:(NSInteger)newAmount change:(NSInteger)change {
    if (change != 0) {
        NSString *ownLifeValue = ownLife?[NSString stringWithFormat:@"%d", newAmount]:@"";
        NSString *enemyLifeValue = ownLife?@"":[NSString stringWithFormat:@"%d", newAmount];
        NSString *changeAmount = change < 0 ? [NSString stringWithFormat:@"%d",change]:[NSString stringWithFormat:@"+%d",change];
        NSString *time = [self getCurrentTime];
        
        NSDictionary *row = [NSDictionary dictionaryWithObjects:
                [NSArray arrayWithObjects:poison?@"1":@"0", ownLifeValue,enemyLifeValue, changeAmount, time, nil]
            forKeys:
                [NSArray arrayWithObjects:@"isPoison", @"ownScore", @"enemyScore", @"change", @"time", nil]];

        [self.dataRows addObject:row];
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:[self.dataRows count]-1 inSection:0];
        
        [self.historyTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        if ([self.dataRows count] > 1) { //no updating needed with only one cell in table
            NSIndexPath *prevRowIndexPath = [NSIndexPath indexPathForRow:[self.dataRows count]-2 inSection:0];
            [self.historyTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevRowIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        [self.historyTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataRows count]-1 inSection:0]
                                     atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            
        [[NSUserDefaults standardUserDefaults] setObject:self.dataRows forKey:@"history data"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSInteger)getLatestTotalForPoison:(BOOL)poison own:(BOOL)own {
    for (int i = [self.dataRows count]-1; i>=0; i--) {
        NSDictionary *row = [self.dataRows objectAtIndex:i];
        
        if (own && ![[row valueForKey:@"ownScore"] isEqual: @""]) {
            if ((poison && [[row valueForKey:@"isPoison"] isEqualToString:@"1"])
                || (!poison && [[row valueForKey:@"isPoison"] isEqualToString:@"0"])) {
                return [[row valueForKey:@"ownScore"] integerValue];
            }
        }
        if (!own && ![[row valueForKey:@"enemyScore"] isEqual: @""]) {
            if ((poison && [[row valueForKey:@"isPoison"] isEqualToString:@"1"])
                || (!poison && [[row valueForKey:@"isPoison"] isEqualToString:@"0"])) {
                return [[row valueForKey:@"enemyScore"] integerValue];
            }
        }
    }
    return poison?0:20;
}

- (NSString*)getCurrentTime {
    return [NSString stringWithFormat:@"%d", self.minuteCount];
}

- (void)addMinute {
    self.minuteCount++;
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Where we configure the cell in each row
    
    static NSString *CellIdentifier = @"Cell";    
    HistoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"HistoryViewCell" owner:nil options:nil];
        
        for (UIView *view in views) {
            if([view isKindOfClass:[UITableViewCell class]])
            {
                cell = (HistoryViewCell*)view;
            }
        }
    }
    
    // Configure the cell... setting the text of our cell's label
    NSDictionary *row = [self.dataRows objectAtIndex:indexPath.row];
    if (row) {
        NSString *poison = [row valueForKey:@"isPoison"];
        NSString *ownLife = [row valueForKey:@"ownScore"];
        NSString *enemyLife = [row valueForKey:@"enemyScore"];
        NSString *changeTime = [row valueForKey:@"time"];
        
        [cell setDataForPoison:poison ownLife:ownLife enemyLife:enemyLife changeAmount:[row valueForKey:@"change"] changeTime:[NSString stringWithFormat:@"%@'",changeTime]];
        
        if (indexPath.row == 0) {
            if ([self.dataRows count] == 1) {
                [cell setOnly];
            } else {
                [cell setTop];
            }
        } else {
            NSDictionary *previousRow = [self.dataRows objectAtIndex:indexPath.row-1];
            if ([changeTime isEqual:[previousRow valueForKey:@"time"]]) {
                [cell hideTime];
            }
            if (indexPath.row == [self.dataRows count]-1) {
                [cell setBottom];
            } else {
                [cell setMid];
            }
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32;
}
@end
