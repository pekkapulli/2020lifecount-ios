//
//  UIPoisonLabel.m
//  Life Count
//
//  Created by Pekka Pulli on 9/2/13.
//  Copyright (c) 2013 Pekka Pulli. All rights reserved.
//

#import "UIPoisonLabel.h"
#define DRAG_THRESHOLD 20.0

@implementation UIPoisonLabel

@synthesize poisonMargin;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        poisonMargin = 33;
        self.isOwn = false;
        self.isPoison = true;
    }
    return self;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    
    CGPoint pt = [sender locationInView:self];
    
    if (pt.y > self.frame.size.height/2+self.font.pointSize/2) {
        [super changeAmount:-1];
    } else {
        [super changeAmount:1];
    }
    
    [self grow];
}

- (void)handleLifeChange:(NSTimer*) theTimer {
    float yPos = [(NSString*)[theTimer userInfo] floatValue];
    if (yPos > self.frame.size.height/2+self.font.pointSize/2) {
        [super changeAmount:-5];
    } else {
        [super changeAmount:5];
    }
}

- (NSInteger)calculateChange:(float)pty {
    NSInteger change = round(pty / (-1.0 * DRAG_THRESHOLD) - self.previousY);
    if (change != 0) {
        self.previousY = pty / (-1.0 * DRAG_THRESHOLD);
        return change;
    }
    return 0;
}

-(void)reset {
    self.lifeTotalBeforeReset = self.text;
    [self setText:@"0"];
    //[self.delegate lifeLabelChangedValue:self];
}

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, poisonMargin, 0, 0};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
