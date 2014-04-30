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
    NSSet *boundaries = [NSSet setWithObjects:
                         [NSValue valueWithCGRect:CGRectMake(80, 80, 20, 200)],
                         nil];
    NSSet *goals = [NSSet setWithObjects:[NSValue valueWithCGRect:CGRectMake(300, 548, 20, 20)], nil];
    
    Level *level = [[Level alloc] initWithPuckStart:startPoint levelObjects:@{
                                                                              [NSNumber numberWithInteger:levelObjectTypeBoundary]:@{
                                                                                      MC_KEY_LEVEL_OBJECTS:boundaries,
                                                                                      MC_KEY_LEVEL_OBJECT_BACKGROUND_COLOR:[UIColor blackColor],
                                                                                      MC_KEY_LEVEL_OBJECT_BACKGROUND_URL:@"background_brick.jpg"
                                                                                      },
                                                                              [NSNumber numberWithInteger:levelObjectTypeGoal]:@{
                                                                                      MC_KEY_LEVEL_OBJECTS:goals,
                                                                                      MC_KEY_LEVEL_OBJECT_BACKGROUND_COLOR:[UIColor greenColor],
                                                                                      MC_KEY_LEVEL_OBJECT_BACKGROUND_URL:@""
                                                                                      },
                                                                              }];
    [level setBlockingBoundaryKeys:[NSSet setWithObjects:[NSNumber numberWithInteger:levelObjectTypeBoundary], nil]];//Let the level know which set of objects will block the puck's movement
    [level setLevelBackgroundColor:[UIColor darkGrayColor]];
    [level setLevelBackgroundURL:@"background_light_wood.jpg"];
    return level;
}

@end
