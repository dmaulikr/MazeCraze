//
//  MCSuperController.m
//  MazeCraze
//
//  Created by Scott Delly on 4/28/14.
//  Copyright (c) 2014 Scott Delly. All rights reserved.
//

#import "MCSuperController.h"

//Mazes
#import "MCMazeVC.h"
#import "MCMazeVCDelegate.h"

//Levels
#import "Level.h"
#import "MCLevelManager.h"

//Pucks
#import "Puck.h"
#import "MCPuckManager.h"

@interface MCSuperController ()

@property (nonatomic, strong) MCMazeVC *currentMaze;

@end

@implementation MCSuperController

+ (instancetype)sharedInstance
{
    static MCSuperController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [MCSuperController new];
    });
    return sharedInstance;
}

- (id)init
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        //
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self presentMaze];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentMaze
{
    self.currentMaze = [[MCMazeVC alloc] initWithNibName:nil bundle:nil];
    [self.currentMaze setMazeDelegate:self];
    [self addChildViewController:self.currentMaze];
    [self.view addSubview:self.currentMaze.view];
    [self.currentMaze setMazeActive:YES];
}

- (void)resetMaze
{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    self.currentMaze = nil;
    [self presentMaze];
}

#pragma mark - MCMazeVCDelegate Methods

- (Level *)levelForMaze:(MCMazeVC *)maze
{
    return [[MCLevelManager sharedInstance] getCurrentLevel];
}

- (Puck *)puckForMaze:(MCMazeVC *)maze
{
    return [[MCPuckManager sharedInstance] defaultPuck];
}

- (void)completedMaze:(MCMazeVC *)maze
{
    [maze setMazeActive:NO];
    [[MCLevelManager sharedInstance] incrementLevel];
    UIAlertView *completeAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Level Complete", @"")
                                                            message:NSLocalizedString(@"Congratulations! You've completed the level", @"")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Next Level", @"")
                                                  otherButtonTitles:nil];
    [completeAlert show];
}

- (void)failedMaze:(MCMazeVC *)maze
{
    [maze setMazeActive:NO];
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Level Failed", @"")
                                                          message:NSLocalizedString(@"Oh No! You've failed this level", @"")
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"Try Again", @"")
                                                otherButtonTitles:nil];
    [failedAlert show];
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self resetMaze];
}

@end
