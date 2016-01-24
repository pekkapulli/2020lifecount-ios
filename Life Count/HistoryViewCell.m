//
//  HistoryViewCell.m
//  Life Count
//
//  Created by Pekka Pulli on 5/8/13.
//  Copyright (c) 2013 Pekka Pulli. All rights reserved.
//

#import "HistoryViewCell.h"

@implementation HistoryViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataForPoison:(NSString*)poison ownLife:(NSString*)ownLife enemyLife:(NSString*)enemyLife changeAmount:(NSString*)changeAmount changeTime:(NSString*)time {
    if (![ownLife isEqual: @""]) {                      //own
        [self.ownHistoryLabel setText:ownLife];
        if (![changeAmount isEqual: @"0"]) {
            [self.ownChangeLabel setText:changeAmount];
        } else {
            [self.ownChangeLabel setAlpha:0];
        }
        if ([poison isEqualToString:@"1"]) {
            [self.ownPoisonIcon setAlpha:1];
        } else {
            [self.ownPoisonIcon setAlpha:0];
        }
    } else {
        [self.ownHistoryLabel setAlpha:0];
        [self.ownChangeLabel setAlpha:0];
        [self.ownPoisonIcon setAlpha:0];
    }
    if (![enemyLife isEqual: @""]) {                    //enemy
        [self.enemyHistoryLabel setText:enemyLife];
        if (![changeAmount isEqual: @"0"]) {
            [self.enemyChangeLabel setText:changeAmount];
        } else {
            [self.enemyChangeLabel setAlpha:0];
        }
        if ([poison isEqualToString:@"1"]) {
            [self.enemyPoisonIcon setAlpha:1];
        } else {
            [self.enemyPoisonIcon setAlpha:0];
        }
    } else {
        [self.enemyHistoryLabel setAlpha:0];
        [self.enemyChangeLabel setAlpha:0];
        [self.enemyPoisonIcon setAlpha:0];
    }

    [self.historyTimeLabel setText:time];
    
    [self.historyTimeLabel setAlpha:1];
    [self.centerLineTop setAlpha:1];
}

- (void)setOnly {
    [self.centerLineTop setAlpha:0];
    [self.centerLineBottom setAlpha:0];
}

- (void)setTop {
    [self.centerLineTop setAlpha:0];
    [self.centerLineBottom setAlpha:1];
}

- (void)setMid {
    [self.centerLineTop setAlpha:1];
    [self.centerLineBottom setAlpha:1];
}

- (void)setBottom {
    [self.centerLineTop setAlpha:1];
    [self.centerLineBottom setAlpha:0];
}

- (NSString*)getTime {
    return [self.historyTimeLabel text];
}

- (void)hideTime {
    [self.historyTimeLabel setAlpha:0];
}

@end
