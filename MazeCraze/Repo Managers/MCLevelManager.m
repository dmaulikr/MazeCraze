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
    Level *level = [[Level alloc] initWithPuckStart:startPoint mazeBoundaires:nil andGoals:nil];
    return level;
}

@end
