//
//  Puck.h
//  MazeCraze
//
//  Created by Scott Delly on 4/28/14.
//  Copyright (c) 2014 Scott Delly. All rights reserved.
//

@interface Puck : NSObject

@property (nonatomic) CGSize puckSize;
@property (nonatomic, strong) NSString *puckImageURL;
@property (nonatomic, strong) UIColor *puckColor;

- (id)initWithSize:(CGSize)size;

- (CGVector)applyForce:(CGVector)force; // We'll use this to allow different pucks to respond to forces in different ways

@end
