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
    NSSet *objects;
    if ((objects = [self.levelObjects objectForKey:[NSNumber numberWithInteger:type]])) {
        for (NSValue *object in objects) {
            CGRect objectRect = [object CGRectValue];
            if (CGRectContainsPoint(objectRect, point)) {
                return YES;
            }
        }
    }
    return NO;
}

@end
