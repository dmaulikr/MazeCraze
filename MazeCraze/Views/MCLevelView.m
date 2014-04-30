//
//  MCLevelView.m
//  MazeCraze
//
//  Created by Scott Delly on 4/28/14.
//  Copyright (c) 2014 Scott Delly. All rights reserved.
//

#import "MCLevelView.h"

@implementation MCLevelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setBackgroundColor:[UIColor redColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    
    CGContextClearRect(context, rect);
    CGContextFillRect(context, rect);
    
    if (self.backgroundImage) {
        [self.backgroundImage drawAsPatternInRect:rect];
    }
}

@end
