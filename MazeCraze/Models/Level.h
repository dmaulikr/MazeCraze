//
//  Level.h
//  MazeCraze
//
//  Created by Scott Delly on 4/28/14.
//  Copyright (c) 2014 Scott Delly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : NSObject

@property (nonatomic, strong, readonly) NSValue *puckStart;
@property (nonatomic, strong) NSSet *levelBoundaries;
@property (nonatomic, strong) NSSet *levelGoals;

- (id)initWithPuckStart:(CGPoint)startPoint mazeBoundaires:(NSSet *)bounds andGoals:(NSSet *)goals;
- (CGPoint)puckStartPoint;

@end
