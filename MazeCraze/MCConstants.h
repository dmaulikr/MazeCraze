//
//  MCConstants.h
//  MazeCraze
//
//  Created by Scott Delly on 4/28/14.
//  Copyright (c) 2014 Scott Delly. All rights reserved.
//

@interface MCConstants : NSObject

//Keys
FOUNDATION_EXPORT NSString *const MC_KEY_CURRENT_LEVEL;

//Global Notifications
FOUNDATION_EXPORT NSString *const MC_NOTI_ACCEL_CHANGE;

typedef NS_ENUM(NSUInteger, LevelObjectType){
    levelObjectTypeBoundary,
    levelObjectTypeGoal,
    levelObjectTypeCount
};

@end
