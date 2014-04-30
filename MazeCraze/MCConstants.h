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
FOUNDATION_EXPORT NSString *const MC_KEY_LEVEL_OBJECTS;// = @"objects";
FOUNDATION_EXPORT NSString *const MC_KEY_LEVEL_OBJECT_BACKGROUND_COLOR;// = @"object background color";
FOUNDATION_EXPORT NSString *const MC_KEY_LEVEL_OBJECT_BACKGROUND_URL;// = @"object background URL";

//Global Notifications
FOUNDATION_EXPORT NSString *const MC_NOTI_ACCEL_CHANGE;

typedef NS_ENUM(NSUInteger, LevelObjectType){
    levelObjectTypeBoundary,
    levelObjectTypeGoal,
    LevelObjectTypePit,
    levelObjectTypeCount
};

@end
