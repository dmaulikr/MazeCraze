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

#define TICK_TIME 1.0f/60.0f

@interface MCMazeVC ()

@property (nonatomic, strong) NSTimer *tickTimer;
@property (nonatomic, strong) MCLevelView *levelView;
@property (nonatomic, strong) MCPuckView *puckView;
@property (nonatomic) CGPoint puckPosition;
@property (nonatomic) CGVector puckVelocity;

@end

@implementation MCMazeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tickTimer = [NSTimer scheduledTimerWithTimeInterval:TICK_TIME target:self selector:@selector(movePuckView) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[MotionService sharedInstance] beginMonitoringMotion];
    
    Level *level = [self.mazeDelegate levelForMaze:self];
    self.levelView = [[MCLevelView alloc] initWithFrame:self.view.bounds];
    [self.levelView setBackgroundColor:level.levelBackgroundColor];
    if (level.levelBackgroundURL) {
        [self.levelView setBackgroundImage:[UIImage imageNamed:level.levelBackgroundURL]];
    }
    for (NSString *key in level.levelObjects) {
        NSDictionary *objects = [level.levelObjects objectForKey:key];
        NSSet *objectFrames = [objects objectForKey:MC_KEY_LEVEL_OBJECTS];
        UIColor *objectBackgroundColor = [objects objectForKey:MC_KEY_LEVEL_OBJECT_BACKGROUND_COLOR];
        NSString *objectBackgroundURL = [objects objectForKey:MC_KEY_LEVEL_OBJECT_BACKGROUND_URL];
        for (NSValue *val in objectFrames) {
            CGRect rect = [val CGRectValue];
            UIView *objectView = [[UIView alloc] initWithFrame:rect];
            if (objectBackgroundURL && ![objectBackgroundURL isEqualToString:@""]) {
                [objectView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:objectBackgroundURL]]];
            } else {
                [objectView setBackgroundColor:objectBackgroundColor];
            }
            [self.levelView addSubview:objectView];
        }
    }
    
    [self.view addSubview:self.levelView];
    
    Puck *puck = [self.mazeDelegate puckForMaze:self];
    self.puckPosition = level.puckStartPoint;
    self.puckVelocity = CGVectorMake(0, 0);
    self.puckView = [[MCPuckView alloc] initWithFrame:CGRectMake(self.puckPosition.x, self.puckPosition.y, puck.puckSize.width, puck.puckSize.height)];
    [self.puckView setPuckColor:puck.puckColor];
    if (puck.puckImageURL) {
        [self.puckView setPuckImage:[UIImage imageNamed:puck.puckImageURL]];
    }
    [self.view addSubview:self.puckView];
}

- (void)accelerationDidChange
{
    [self movePuckView];
}

- (void)movePuckView
{
    Puck *puck = [self.mazeDelegate puckForMaze:self];
    
    CGVector velocity = [self velocityForPuck];
    CGSize viewSize = self.view.bounds.size;
    CGPoint maxPuckPosition = CGPointMake(viewSize.width - puck.puckSize.width, viewSize.height - puck.puckSize.height);
    CGPoint newPuckPosition = CGPointMake(MIN(MAX(self.puckPosition.x + velocity.dx,0),maxPuckPosition.x), MIN(MAX(self.puckPosition.y + velocity.dy,0),maxPuckPosition.y));//Where the puck does end up after factoring collisions into the velocity
    self.puckVelocity = velocity;
//    NSLog(@"VELX:%f VELY:%f", velocity.dx, velocity.dy);
    self.puckPosition = newPuckPosition;
    [self.puckView setFrame:(CGRect){
        self.puckPosition,
        self.puckView.frame.size
    }];
    [self.view setNeedsDisplay];
}

- (CGVector)velocityForPuck
{
    Puck *puck = [self.mazeDelegate puckForMaze:self];
    
    double xVelocity = self.puckVelocity.dx + 100*[[MotionService sharedInstance] xAccel]*TICK_TIME;
    double yVelocity = self.puckVelocity.dy + -100*[[MotionService sharedInstance] yAccel]*TICK_TIME;
    
    CGVector velocity = [puck applyForce:CGVectorMake(xVelocity, yVelocity)];
    CGPoint predictedPuckPosition = CGPointMake(self.puckPosition.x + velocity.dx, self.puckPosition.y + velocity.dy);//Where the puck might end up granted there are no collisions
    
    // We create 3 "detector points" per corner of the puck. These points give us the ability to detect a collision and which side of the puck the collision was on, even if the full side of the puck isnt involved with the collision. This variable says how far apart the points shold be from the exact corners
    CGFloat detectorPointSpacing = 4.0f;
    
    CGPoint puckTopLeft = predictedPuckPosition;
    CGPoint puckTopLeftLeft = CGPointMake(predictedPuckPosition.x, predictedPuckPosition.y + detectorPointSpacing);
    CGPoint puckTopTopLeft = CGPointMake(predictedPuckPosition.x + detectorPointSpacing, predictedPuckPosition.y);
    
    
    CGPoint puckTopRight = CGPointMake(predictedPuckPosition.x + puck.puckSize.width, predictedPuckPosition.y);
    CGPoint puckTopRightRight = CGPointMake(predictedPuckPosition.x + puck.puckSize.width, predictedPuckPosition.y + detectorPointSpacing);
    CGPoint puckTopTopRight = CGPointMake(predictedPuckPosition.x + puck.puckSize.width - detectorPointSpacing, predictedPuckPosition.y);
    
    CGPoint puckBottomLeft = CGPointMake(predictedPuckPosition.x, predictedPuckPosition.y + puck.puckSize.height);
    CGPoint puckBottomLeftLeft = CGPointMake(predictedPuckPosition.x, predictedPuckPosition.y + puck.puckSize.height - detectorPointSpacing);
    CGPoint puckBottomBottomLeft = CGPointMake(predictedPuckPosition.x + detectorPointSpacing, predictedPuckPosition.y + puck.puckSize.height);

    CGPoint puckBottomRight = CGPointMake(predictedPuckPosition.x + puck.puckSize.width, predictedPuckPosition.y + puck.puckSize.height);
    CGPoint puckBottomRightRight = CGPointMake(predictedPuckPosition.x + puck.puckSize.width, predictedPuckPosition.y + puck.puckSize.height - detectorPointSpacing);
    CGPoint puckBottomBottomRight = CGPointMake(predictedPuckPosition.x + puck.puckSize.width - detectorPointSpacing, predictedPuckPosition.y + puck.puckSize.height);

    BOOL puckMovingRight = velocity.dx > 0;
    BOOL puckMovingDown = velocity.dy > 0;
    
    BOOL xCollision = NO;
    BOOL yCollision = NO;
    
    Level *level = [self.mazeDelegate levelForMaze:self];
    
    //Based on the direction of the puck, we'll detect collisions with level boundaries and view frame
    if (puckMovingRight) {
        xCollision =    ([level point:puckTopRight intersectsObjectOfType:levelObjectTypeBoundary] &&
                         [level point:puckTopRightRight intersectsObjectOfType:levelObjectTypeBoundary]) ||
                        ([level point:puckBottomRight intersectsObjectOfType:levelObjectTypeBoundary] &&
                        [level point:puckBottomRightRight intersectsObjectOfType:levelObjectTypeBoundary]) ||
                        !(CGRectContainsPoint(self.levelView.frame, puckTopRight) ||
                          CGRectContainsPoint(self.levelView.frame, puckBottomRight));
    } else {
        xCollision =    ([level point:puckTopLeft intersectsObjectOfType:levelObjectTypeBoundary] &&
                         [level point:puckTopLeftLeft intersectsObjectOfType:levelObjectTypeBoundary]) ||
                        ([level point:puckBottomLeft intersectsObjectOfType:levelObjectTypeBoundary] &&
                         [level point:puckBottomLeftLeft intersectsObjectOfType:levelObjectTypeBoundary]) ||
                        !(CGRectContainsPoint(self.levelView.frame, puckTopLeft) ||
                          CGRectContainsPoint(self.levelView.frame, puckBottomLeft));
    }
    
    if (puckMovingDown) {
        yCollision =    ([level point:puckBottomLeft intersectsObjectOfType:levelObjectTypeBoundary] &&
                         [level point:puckBottomBottomLeft intersectsObjectOfType:levelObjectTypeBoundary]) ||
                        ([level point:puckBottomRight intersectsObjectOfType:levelObjectTypeBoundary] &&
                         [level point:puckBottomBottomRight intersectsObjectOfType:levelObjectTypeBoundary]) ||
                        !(CGRectContainsPoint(self.levelView.frame, puckBottomLeft) ||
                          CGRectContainsPoint(self.levelView.frame, puckBottomRight));
        
    } else {
        yCollision =    ([level point:puckTopLeft intersectsObjectOfType:levelObjectTypeBoundary] &&
                         [level point:puckTopTopLeft intersectsObjectOfType:levelObjectTypeBoundary]) ||
                        ([level point:puckTopRight intersectsObjectOfType:levelObjectTypeBoundary] &&
                         [level point:puckTopTopRight intersectsObjectOfType:levelObjectTypeBoundary]) ||
                        !(CGRectContainsPoint(self.levelView.frame, puckTopLeft) ||
                          CGRectContainsPoint(self.levelView.frame, puckTopRight));
    }
    
    return CGVectorMake(!xCollision * velocity.dx, !yCollision * velocity.dy);
}

@end
