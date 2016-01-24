//
//  UILifeLabel.h
//  Life Count
//
//  Created by Pekka Pulli on 11/29/12.
//  Copyright (c) 2012 Pekka Pulli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UILifeLabel;

@protocol UILifeLabelDelegate <NSObject>
- (void)lifeLabelChangedValue:(UILifeLabel *)lifeLabel;
- (void)logLifeLabelEventForPlayer:(BOOL)own poison:(BOOL)poison newAmount:(NSInteger)newAmount change:(NSInteger)change;
- (void)lifeLabelDragHappened:(UIPanGestureRecognizer *)sender;
- (void)lifeLabelTouchHappened:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@interface UILifeLabel : UILabel

@property (assign, nonatomic) float previousY;
@property (weak, nonatomic) id<UILifeLabelDelegate> delegate;
@property (copy, nonatomic) NSString *lifeTotalBeforeReset;
@property (assign, nonatomic) BOOL lockedForLifeChange;
@property (assign, nonatomic) BOOL lockedForPan;
@property (nonatomic, strong) NSTimer *timer;
@property (assign, nonatomic) BOOL isOwn;
@property (assign, nonatomic) BOOL isPoison;

@property (assign, nonatomic) NSInteger previousLife;
@property (nonatomic, strong) NSTimer *changeTimer;

- (void)reset;
- (void)undoReset;
- (void)grow;
- (void)shrink;
- (void)changeAmount:(NSInteger)amount;
- (NSInteger)calculateChange:(float)pty;
- (void)fireTimer;

@end
