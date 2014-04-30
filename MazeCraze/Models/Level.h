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
@property (nonatomic, strong) NSDictionary *levelObjects;
@property (nonatomic, strong) UIImage *objectBackground;

- (id)initWithPuckStart:(CGPoint)startPoint levelObjects:(NSDictionary *)objects;
- (BOOL)point:(CGPoint)point intersectsObjectOfType:(LevelObjectType)type;
- (CGPoint)puckStartPoint;

@end
