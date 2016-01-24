//
//  HistoryViewCell.h
//  Life Count
//
//  Created by Pekka Pulli on 5/8/13.
//  Copyright (c) 2013 Pekka Pulli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *enemyHistoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *ownHistoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *historyTimeLabel;
@property (strong, nonatomic) IBOutlet UIView *centerLineTop;
@property (strong, nonatomic) IBOutlet UIView * centerLineBottom;
@property (strong, nonatomic) IBOutlet UILabel *enemyChangeLabel;
@property (strong, nonatomic) IBOutlet UILabel *ownChangeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *enemyPoisonIcon;
@property (strong, nonatomic) IBOutlet UIImageView *ownPoisonIcon;

- (NSString*)getTime;
- (void)hideTime;
- (void)setDataForPoison:(NSString*)poison ownLife:(NSString*)ownLife enemyLife:(NSString*)enemyLife changeAmount:(NSString*)changeAmount changeTime:(NSString*)time;
- (void)setOnly;
- (void)setTop;
- (void)setMid;
- (void)setBottom;

@end
