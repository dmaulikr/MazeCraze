//
//  MCPuckManager.h
//  MazeCraze
//
//  Created by Scott Delly on 4/28/14.
//  Copyright (c) 2014 Scott Delly. All rights reserved.
//
@class Puck;

@interface MCPuckManager : NSObject <Singleton>

- (Puck *)defaultPuck;

@end
