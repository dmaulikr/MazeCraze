//
//  MCLevelManager.m
//  MazeCraze
//
//  Created by Scott Delly on 4/28/14.
//  Copyright (c) 2014 Scott Delly. All rights reserved.
//

#import "MCLevelManager.h"
#import "Level.h"
#import "SettingService.h"

@interface MCLevelManager ()

@property (nonatomic, strong) NSArray *levels;

@end

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

 - (id)init
{
    if (self = [super init]) {
        CGPoint startPoint0 = CGPointMake(10, 10);
        NSSet *boundaries0 = [NSSet setWithObjects:
                              [NSValue valueWithCGRect:CGRectMake(40, 100, 100, 468)],
                              [NSValue valueWithCGRect:CGRectMake(180, 100, 100, 468)],
                              nil];
        NSSet *pits0 = [NSSet setWithObjects:
                        [NSValue valueWithCGRect:CGRectMake(0, 528, 40, 40)],
                        nil];
        
        NSSet *goals0 = [NSSet setWithObjects:[NSValue valueWithCGRect:CGRectMake(280, 528, 40, 40)], nil];
        
        Level *level0 = [[Level alloc] initWithPuckStart:startPoint0 levelObjects:@{
                                                                                    [NSNumber numberWithInteger:levelObjectTypeBoundary]:@{
                                                                                            MC_KEY_LEVEL_OBJECTS:boundaries0,
                                                                                            MC_KEY_LEVEL_OBJECT_BACKGROUND_COLOR:[UIColor blackColor],
                                                                                            MC_KEY_LEVEL_OBJECT_BACKGROUND_URL:@"background_brick.jpg"
                                                                                            },
                                                                                    [NSNumber numberWithInteger:levelObjectTypeGoal]:@{
                                                                                            MC_KEY_LEVEL_OBJECTS:goals0,
                                                                                            MC_KEY_LEVEL_OBJECT_BACKGROUND_COLOR:[UIColor greenColor],
                                                                                            MC_KEY_LEVEL_OBJECT_BACKGROUND_URL:@""
                                                                                            },
                                                                                    [NSNumber numberWithInteger:levelObjectTypePit]:@{
                                                                                            MC_KEY_LEVEL_OBJECTS:pits0,
                                                                                            MC_KEY_LEVEL_OBJECT_BACKGROUND_COLOR:[UIColor redColor],
                                                                                            MC_KEY_LEVEL_OBJECT_BACKGROUND_URL:@""
                                                                                            }
                                                                                    }];
        [level0 setBlockingBoundaryKeys:[NSSet setWithObjects:[NSNumber numberWithInteger:levelObjectTypeBoundary], nil]];//Let the level know which set of objects will block the puck's movement
        [level0 setLevelBackgroundColor:[UIColor darkGrayColor]];
        [level0 setLevelBackgroundURL:@"background_light_wood.jpg"];

        CGPoint startPoint1 = CGPointMake(10, 566);
        NSSet *boundaries1 = [NSSet setWithObjects:
                             [NSValue valueWithCGRect:CGRectMake(60, 50, 260, 10)],
                             [NSValue valueWithCGRect:CGRectMake(0, 110, 260, 10)],
                             [NSValue valueWithCGRect:CGRectMake(110, 110, 10, 406)],
                             [NSValue valueWithCGRect:CGRectMake(50, 160, 10, 406)],
                             [NSValue valueWithCGRect:CGRectMake(160, 170, 160, 10)],
                             [NSValue valueWithCGRect:CGRectMake(120, 230, 160, 10)],
                             [NSValue valueWithCGRect:CGRectMake(270, 230, 10, 100)],
                             [NSValue valueWithCGRect:CGRectMake(200, 280, 10, 200)],
                             [NSValue valueWithCGRect:CGRectMake(200, 400, 120, 10)],
                             [NSValue valueWithCGRect:CGRectMake(110, 508, 100, 10)],
                             
                             nil];
        NSSet *pits1 = [NSSet setWithObjects:
                       [NSValue valueWithCGRect:CGRectMake(280, 528, 40, 40)],
                       nil];
        
        NSSet *goals1 = [NSSet setWithObjects:[NSValue valueWithCGRect:CGRectMake(280, 0, 40, 50)], nil];
        
        Level *level1 = [[Level alloc] initWithPuckStart:startPoint1 levelObjects:@{
                                                                                  [NSNumber numberWithInteger:levelObjectTypeBoundary]:@{
                                                                                          MC_KEY_LEVEL_OBJECTS:boundaries1,
                                                                                          MC_KEY_LEVEL_OBJECT_BACKGROUND_COLOR:[UIColor blackColor],
                                                                                          MC_KEY_LEVEL_OBJECT_BACKGROUND_URL:@"background_brick.jpg"
                                                                                          },
                                                                                  [NSNumber numberWithInteger:levelObjectTypeGoal]:@{
                                                                                          MC_KEY_LEVEL_OBJECTS:goals1,
                                                                                          MC_KEY_LEVEL_OBJECT_BACKGROUND_COLOR:[UIColor greenColor],
                                                                                          MC_KEY_LEVEL_OBJECT_BACKGROUND_URL:@""
                                                                                          },
                                                                                  [NSNumber numberWithInteger:levelObjectTypePit]:@{
                                                                                          MC_KEY_LEVEL_OBJECTS:pits1,
                                                                                          MC_KEY_LEVEL_OBJECT_BACKGROUND_COLOR:[UIColor redColor],
                                                                                          MC_KEY_LEVEL_OBJECT_BACKGROUND_URL:@""
                                                                                          }
                                                                                  }];
        [level1 setBlockingBoundaryKeys:[NSSet setWithObjects:[NSNumber numberWithInteger:levelObjectTypeBoundary], nil]];//Let the level know which set of objects will block the puck's movement
        [level1 setLevelBackgroundColor:[UIColor darkGrayColor]];
        [level1 setLevelBackgroundURL:@"background_light_wood.jpg"];
        
        self.levels = [ NSArray arrayWithObjects:level0, level1, nil];
    }
    return self;
}

- (Level *)getCurrentLevel
{
    NSNumber *currentLevel = [SettingService loadSettingForKey:MC_KEY_CURRENT_LEVEL];
    if (!currentLevel) {
        currentLevel = @0;
    }
    return [self.levels objectAtIndex:[currentLevel integerValue]];
}

- (void)incrementLevel
{
    NSNumber *currentLevel = [SettingService loadSettingForKey:MC_KEY_CURRENT_LEVEL];
    if (!currentLevel) {
        currentLevel = @0;
    }
    NSUInteger nextLevelInt = [currentLevel integerValue] + 1;
    if (nextLevelInt == [self.levels count]) {
        nextLevelInt = 0;
    }
    [SettingService saveSetting:[NSNumber numberWithInteger:nextLevelInt] forKey:MC_KEY_CURRENT_LEVEL];
}

@end
