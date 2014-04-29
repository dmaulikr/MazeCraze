//
//  MCMazeVC.m
//  MazeCraze
//
//  Created by Scott Delly on 4/28/14.
//  Copyright (c) 2014 Scott Delly. All rights reserved.
//

#import "MCMazeVC.h"
#import "MCMazeVCDelegate.h"
#import "MotionService.h"

//Views
#import "MCLevelView.h"
#import "Level.h"

#import "MCPuckView.h"
#import "Puck.h"

@interface MCMazeVC ()

@property (nonatomic, strong) MCPuckView *puckView;

@end

@implementation MCMazeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accelerationDidChange) name:MC_NOTI_ACCEL_CHANGE object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[MotionService sharedInstance] beginMonitoringMotion];
    
    Level *level = [self.mazeDelegate levelForMaze:self];
    Puck *puck = [self.mazeDelegate puckForMaze:self];
    
    self.puckView = [[MCPuckView alloc] initWithFrame:CGRectMake(level.puckStartPoint.x, level.puckStartPoint.y, puck.puckSize.width, puck.puckSize.height)];
    [self.view addSubview:self.puckView];
}

- (void)accelerationDidChange
{
    Puck *puck = [self.mazeDelegate puckForMaze:self];
    
    CGPoint moveToPoint = [puck applyForce:CGPointMake([[MotionService sharedInstance] xAccel], -1*[[MotionService sharedInstance] yAccel]) atPosition:self.puckView.frame.origin];
    
    [self.puckView setFrame:(CGRect){
        moveToPoint,
        self.puckView.frame.size
    }];
    [self.view setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
