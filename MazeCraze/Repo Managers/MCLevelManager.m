//
//  MCLevelManager.m
//  MazeCraze
//
//  Created by Scott Delly on 4/28/14.
//  Copyright (c) 2014 Scott Delly. All rights reserved.
//

#import "MCLevelManager.h"
#import "Level.h"

@implementation MCLevelManager

+ (instancetype)sharedInstance
{
    static MCLevelManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [MCLevelManager new];
    });
    return sharedInstance;
}

- (Level *)getCurrentLevel
{
    CGPoint startPoint = CGPointMake(10, 10);
    NSSet *boundaries = [NSSet setWithObjects:[NSValue valueWithCGRect:CGRectMake(100, 0, 20, 200)], nil];
    NSSet *goals = [NSSet setWithObjects:[NSValue valueWithCGRect:CGRectMake(300, 548, 20, 20)], nil];
    
    Level *level = [[Level alloc] initWithPuckStart:startPoint levelObjects:@{
                                                                              [NSNumber numberWithInteger:levelObjectTypeBoundary]:boundaries,
                                                                              [NSNumber numberWithInteger:levelObjectTypeGoal]:goals
                                                                              }];
    return level;
}

@end
