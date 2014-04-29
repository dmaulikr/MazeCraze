//
//  MCPuckManager.m
//  MazeCraze
//
//  Created by Scott Delly on 4/28/14.
//  Copyright (c) 2014 Scott Delly. All rights reserved.
//

#import "MCPuckManager.h"
#import "Puck.h"

@implementation MCPuckManager

+ (instancetype)sharedInstance
{
    static MCPuckManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [MCPuckManager new];
    });
    return sharedInstance;
}

- (Puck *)defaultPuck
{
    Puck *puck = [[Puck alloc] initWithSize:CGSizeMake(10, 10) andImageURL:nil];
    return puck;
}

@end
