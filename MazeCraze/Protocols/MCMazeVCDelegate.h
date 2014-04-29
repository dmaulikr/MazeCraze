//
//  MCMazeVCDelegate.h
//  MazeCraze
//
//  Created by Scott Delly on 4/28/14.
//  Copyright (c) 2014 Scott Delly. All rights reserved.
//


@class MCMazeVC, Level, Puck;

@protocol MCMazeVCDelegate <NSObject>

- (Level *)levelForMaze:(MCMazeVC *)maze;
- (Puck *)puckForMaze:(MCMazeVC *)maze;
- (void)mazeCompleted;
- (void)mazeFailed; // Used if the puck falls into a trap or player goes over time

@end
