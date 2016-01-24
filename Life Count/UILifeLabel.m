//
//  UILifeLabel.m
//  Life Count
//
//  Created by Pekka Pulli on 11/29/12.
//  Copyright (c) 2012 Pekka Pulli. All rights reserved.
//

#import "UILifeLabel.h"
#define DRAG_THRESHOLD 50.0
#define SHRINK_AMOUNT 0.97
#define WAIT_TIME 1.5

@interface UILifeLabel ()

@end

@implementation UILifeLabel
@synthesize delegate;
@synthesize isOwn;
@synthesize isPoison;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        isOwn = false;
        isPoison = false;
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:panRecognizer];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:tapRecognizer];
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        [self addGestureRecognizer:longPressRecognizer];
        self.previousY = 0;
        self.lifeTotalBeforeReset = @"20";
        self.lockedForLifeChange = FALSE;
        self.lockedForPan = FALSE;
    }
    return self;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    
    CGPoint pt = [sender locationInView:self];
    
    if (pt.y < self.frame.size.height/2-self.font.pointSize/2) {
        [self changeAmount:1];
    } else {
        [self changeAmount:-1];
    }
    
    [self grow];
}

- (void)handleLongPressGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint pt = [sender locationInView:self];
        NSString *yPos = [NSString stringWithFormat: @"%f", pt.y];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(handleLifeChange:) userInfo:yPos repeats:YES];
    
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self.timer invalidate];
        [self grow];
    }
}

- (void)handleLifeChange:(NSTimer*) theTimer {
    float yPos = [(NSString*)[theTimer userInfo] floatValue];
    if (yPos < self.frame.size.height/2-self.font.pointSize/2) {
        [self changeAmount:5];
    } else {
        [self changeAmount:-5];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint pt = [sender translationInView:self];
    if (!self.lockedForLifeChange && !self.lockedForPan) {
        if (fabsf(pt.y) > 10) { //Lock to vertical pan
            self.lockedForLifeChange = TRUE;
            self.lockedForPan = FALSE;
        } else if (fabsf(pt.x) > 10) { //Lock to horizontal pan
            self.lockedForPan = TRUE;
            self.lockedForLifeChange = FALSE;
        }
    }
    if (self.lockedForLifeChange) {
        NSInteger change = [self calculateChange:pt.y];
        [self changeAmount:change];
    }
    if (self.lockedForPan) {
        [self.delegate lifeLabelDragHappened:sender];
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.previousY = 0;
        [self grow];
        self.lockedForLifeChange = FALSE;
        self.lockedForPan = FALSE;
    }
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    [self shrink];
    [self.delegate lifeLabelTouchHappened:touches withEvent:event];
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    [self grow];
    self.lockedForLifeChange = FALSE;
    self.lockedForPan = FALSE;
}

-(void)shrink {
    [UIView animateWithDuration:0.05 animations:^{
        self.transform = CGAffineTransformScale(self.transform, SHRINK_AMOUNT, SHRINK_AMOUNT);
    }];
}

-(void)grow {
    [UIView animateWithDuration:0.05 animations:^{
        self.transform = CGAffineTransformScale(self.transform, 1.0/SHRINK_AMOUNT, 1.0/SHRINK_AMOUNT);
    }];
}

-(void)reset {
    self.lifeTotalBeforeReset = self.text;
    NSString *startingLifeTotal = @"20";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"starting life total"] != nil) {
        startingLifeTotal = [defaults valueForKey:@"starting life total"];
//        self.previousLife
    }
    [self setText:startingLifeTotal];
    //[self.delegate lifeLabelChangedValue:self];
}

-(void)undoReset {
    [self setText:self.lifeTotalBeforeReset];
    //[self.delegate lifeLabelChangedValue:self];
}

- (NSInteger)calculateChange:(float)pty {
    NSInteger change = round(pty / (-1.0 * DRAG_THRESHOLD) - self.previousY);
    if (change != 0) {
        self.previousY = pty / (-1.0 * DRAG_THRESHOLD);
        return change;
    }
    return 0;
}

- (void)changeAmount:(NSInteger)amount {
    if (amount != 0) {
        NSInteger number = [self.text integerValue];
        
        if (self.changeTimer == nil || ![self.changeTimer isValid]) {
            self.previousLife = number;
        } else if (self.changeTimer != nil) {
            [self.changeTimer invalidate];
        }
        
        self.changeTimer = [NSTimer scheduledTimerWithTimeInterval:WAIT_TIME target:self selector:@selector(fireLifeTotalChange:) userInfo:nil repeats:NO];
        
        number += amount;
        [self setText:[NSString stringWithFormat:@"%d",number]];
        [self.delegate lifeLabelChangedValue:self];
    }
}

- (void)fireLifeTotalChange:(NSTimer*) theTimer {
    NSInteger newAmount = [self.text integerValue];
    NSInteger oldAmount = self.previousLife;
    [self.delegate logLifeLabelEventForPlayer:isOwn poison:isPoison newAmount:newAmount change:(newAmount-oldAmount)];
}

-(void)fireTimer {
    if (self.changeTimer != nil && [self.changeTimer isValid]) {
        [self.changeTimer fire];
    }
}

@end
