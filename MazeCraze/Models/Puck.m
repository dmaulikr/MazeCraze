//
//  Puck.m
//  MazeCraze
//
//  Created by Scott Delly on 4/28/14.
//  Copyright (c) 2014 Scott Delly. All rights reserved.
//

#import "Puck.h"

@implementation Puck

- (id)initWithSize:(CGSize)size
{
    if (self = [super init]) {
        self.puckSize = size;
    }
    return self;
}

- (CGVector)applyForce:(CGVector)force
{
    return CGVectorMake(force.dx/1.05f,force.dy/1.05f);
}

@end
