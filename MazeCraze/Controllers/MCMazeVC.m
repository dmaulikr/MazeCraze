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
@property (nonatomic) CGPoint puckPosition;

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
    self.puckPosition = level.puckStartPoint;
    self.puckView = [[MCPuckView alloc] initWithFrame:CGRectMake(self.puckPosition.x, self.puckPosition.y, puck.puckSize.width, puck.puckSize.height)];
    [self.view addSubview:self.puckView];
}

- (void)accelerationDidChange
{
    [self movePuckView];
}

- (void)movePuckView
{
    Puck *puck = [self.mazeDelegate puckForMaze:self];
    
    CGVector velocity = [puck applyForce:CGVectorMake(10*[[MotionService sharedInstance] xAccel], -10*[[MotionService sharedInstance] yAccel])];
    CGSize viewSize = self.view.bounds.size;
    CGPoint maxPuckPosition = CGPointMake(viewSize.width - puck.puckSize.width, viewSize.height - puck.puckSize.height);
    CGPoint newPuckPosition = CGPointMake(MIN(MAX(self.puckPosition.x + velocity.dx,0),maxPuckPosition.x), MIN(MAX(self.puckPosition.y + velocity.dy,0),maxPuckPosition.y));//Moves the puck and keeps it on the screen
    self.puckPosition = newPuckPosition;
    [self.puckView setFrame:(CGRect){
        self.puckPosition,
        self.puckView.frame.size
    }];
    [self.view setNeedsDisplay];
}

@end
