//
//  MCLevelManager.h
//  MazeCraze
//
//  Created by Scott Delly on 4/28/14.
//  Copyright (c) 2014 Scott Delly. All rights reserved.
//
@class Level;

@interface MCLevelManager : NSObject <Singleton>

- (Level *)getCurrentLevel;

@end
