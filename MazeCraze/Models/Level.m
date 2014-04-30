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

- (id)initWithPuckStart:(CGPoint)startPoint levelObjects:(NSDictionary *)objects
{
    if (self = [super init]) {
        _puckStart = [NSValue valueWithCGPoint:startPoint];
        self.levelObjects = objects;
    }
    return self;
}

- (CGPoint)puckStartPoint
{
    return [self.puckStart CGPointValue];
}

- (BOOL)point:(CGPoint)point intersectsObjectOfType:(LevelObjectType)type
{
    NSDictionary *objects = [self.levelObjects objectForKey:[NSNumber numberWithInteger:type]];
    NSSet *objectFrames = [objects objectForKey:MC_KEY_LEVEL_OBJECTS];

    for (NSValue *val in objectFrames) {
        CGRect frame = [val CGRectValue];
        if (CGRectContainsPoint(frame, point)) {
            return YES;
        }
    }
    return NO;
}

@end
