//
//  Level.m
//  MazeCraze
//
//  Created by Scott Delly on 4/28/14.
//  Copyright (c) 2014 Scott Delly. All rights reserved.
//

#import "Level.h"

@implementation Level
@synthesize puckStart = _puckStart;

- (id)initWithPuckStart:(CGPoint)startPoint mazeBoundaires:(NSSet *)bounds andGoals:(NSSet *)goals
{
    if (self = [super init]) {
        _puckStart = [NSValue valueWithCGPoint:startPoint];
        self.levelBoundaries = bounds;
        self.levelGoals = goals;
    }
    return self;
}

- (CGPoint)puckStartPoint
{
    return [self.puckStart CGPointValue];
}

@end
