//
//  MCPuckView.m
//  MazeCraze
//
//  Created by Scott Delly on 4/28/14.
//  Copyright (c) 2014 Scott Delly. All rights reserved.
//

#import "MCPuckView.h"

@implementation MCPuckView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.puckColor.CGColor);

    CGContextClearRect(context, rect);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, NULL, rect);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
//    CGContextClip(context);
    CGPathRelease(path);
    
    if (self.puckImage) {
        [self.puckImage drawInRect:rect];
    }
    CGContextRelease(context);
}

@end
