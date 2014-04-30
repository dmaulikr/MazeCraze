//
//  MCMazeVC.h
//  MazeCraze
//
//  Created by Scott Delly on 4/28/14.
//  Copyright (c) 2014 Scott Delly. All rights reserved.
//

@protocol MCMazeVCDelegate;
@interface MCMazeVC : UIViewController

@property (nonatomic, weak) id<MCMazeVCDelegate>mazeDelegate;
@property (nonatomic) BOOL mazeActive;

@end
