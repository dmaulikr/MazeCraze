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

- (id)initWithSize:(CGSize)size andImageURL:(NSString *)imageURL;

- (CGPoint)applyForce:(CGPoint)force atPosition:(CGPoint)position;

@end
