//
//  HistoryViewController.h
//  Life Count
//
//  Created by Pekka Pulli on 5/2/13.
//  Copyright (c) 2013 Pekka Pulli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController <UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *historyTableView;

@property (nonatomic, strong) NSTimer *gameTimer;
@property (assign, nonatomic) NSInteger minuteCount;
@property (assign, nonatomic) float ownLifeTotal;
@property (assign, nonatomic) float enemyLifeTotal;
@property (retain, nonatomic) NSMutableArray *dataRows;

- (void)resetHistory;
- (void)lifeTotalChangedWithPlayer:(BOOL)ownLife isPoison:(BOOL)poison toAmount:(NSInteger)newAmount change:(NSInteger)change;
- (void)setInitValuesForOwnLife:(NSString*)ownLife enemyLife:(NSString*)enemyLife;

@end
