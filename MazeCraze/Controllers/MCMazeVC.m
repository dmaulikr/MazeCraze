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
@synthesize mazeActive = _mazeActive;
@synthesize tickTimer = _tickTimer;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//    }
//    return self;
//}

- (void)setMazeActive:(BOOL)mazeActive
{
    _mazeActive = mazeActive;
    if (mazeActive) {
        [self tickTimer];
        [[MotionService sharedInstance] beginMonitoringMotion];
    } else if (_tickTimer){
        [[MotionService sharedInstance] endMonitoringMotion];
        [[self tickTimer] invalidate];
        _tickTimer = nil;
    }
}

- (NSTimer *)tickTimer
{
    if (!_tickTimer) {
        _tickTimer = [NSTimer scheduledTimerWithTimeInterval:TICK_TIME target:self selector:@selector(movePuckView) userInfo:nil repeats:YES];
    }
    return _tickTimer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buildMaze];
}

- (void)buildMaze
{
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

- (void)resetMaze
{
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.puckView = nil;
    self.levelView = nil;
    [self buildMaze];
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
    LevelObjectType contactedObject = [self collisionWithNonBlockingObjectsAtPoint:self.puckPosition];
    if (contactedObject == levelObjectTypeGoal) {
        [self.mazeDelegate completedMaze:self];
    } else if (contactedObject == levelObjectTypePit) {
        [self.mazeDelegate failedMaze:self];
    } else {
        [self.view setNeedsDisplay];
    }
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
    for (NSNumber *key in level.blockingBoundaryKeys) {
        NSUInteger intKey = [key integerValue];
        if (puckMovingRight) {
            xCollision = xCollision || ([level point:puckTopRight intersectsObjectOfType:intKey] &&
                                        [level point:puckTopRightRight intersectsObjectOfType:intKey]) ||
                                       ([level point:puckBottomRight intersectsObjectOfType:intKey] &&
                                        [level point:puckBottomRightRight intersectsObjectOfType:intKey]) ||
                                      !(CGRectContainsPoint(self.levelView.frame, puckTopRight) ||
                                        CGRectContainsPoint(self.levelView.frame, puckBottomRight));
        } else {
            xCollision = xCollision || ([level point:puckTopLeft intersectsObjectOfType:intKey] &&
                                        [level point:puckTopLeftLeft intersectsObjectOfType:intKey]) ||
                                       ([level point:puckBottomLeft intersectsObjectOfType:intKey] &&
                                        [level point:puckBottomLeftLeft intersectsObjectOfType:intKey]) ||
                                      !(CGRectContainsPoint(self.levelView.frame, puckTopLeft) ||
                                        CGRectContainsPoint(self.levelView.frame, puckBottomLeft));
        }
        
        if (puckMovingDown) {
            yCollision = yCollision || ([level point:puckBottomLeft intersectsObjectOfType:intKey] &&
                                        [level point:puckBottomBottomLeft intersectsObjectOfType:intKey]) ||
                                       ([level point:puckBottomRight intersectsObjectOfType:intKey] &&
                                        [level point:puckBottomBottomRight intersectsObjectOfType:intKey]) ||
                                      !(CGRectContainsPoint(self.levelView.frame, puckBottomLeft) ||
                                        CGRectContainsPoint(self.levelView.frame, puckBottomRight));
            
        } else {
            yCollision = yCollision || ([level point:puckTopLeft intersectsObjectOfType:intKey] &&
                                        [level point:puckTopTopLeft intersectsObjectOfType:intKey]) ||
                                       ([level point:puckTopRight intersectsObjectOfType:intKey] &&
                                        [level point:puckTopTopRight intersectsObjectOfType:intKey]) ||
                                      !(CGRectContainsPoint(self.levelView.frame, puckTopLeft) ||
                                        CGRectContainsPoint(self.levelView.frame, puckTopRight));
        }
    }
    return CGVectorMake(!xCollision * velocity.dx, !yCollision * velocity.dy);
}

- (LevelObjectType)collisionWithNonBlockingObjectsAtPoint:(CGPoint)point
{
    Level *level = [self.mazeDelegate levelForMaze:self];
    for (int objectType = levelObjectTypeNone; objectType < levelObjectTypeCount; objectType++) {
        if (objectType == levelObjectTypeNone || [level.blockingBoundaryKeys containsObject:[NSNumber numberWithInteger:objectType]]) {
            continue;
        }
        if ([level point:point intersectsObjectOfType:objectType]) {
            return objectType;
        }
    }
    return levelObjectTypeNone;
}

@end
