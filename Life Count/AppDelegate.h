//
//  AppDelegate.h
//  Life Count
//
//  Created by Pekka Pulli on 11/7/12.
//  Copyright (c) 2012 Pekka Pulli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PKRevealController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong, readwrite) PKRevealController *revealController;
@property (strong, nonatomic) UIWindow *window;

@end
