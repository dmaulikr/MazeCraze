//
//  MotionService.h
//  MazeCraze
//
//  Created by Scott Delly on 4/28/14.
//  Copyright (c) 2014 Scott Delly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MotionService : NSObject <Singleton>

@property (nonatomic) double xAccel;
@property (nonatomic) double yAccel;

- (void)beginMonitoringMotion;
- (void)endMonitoringMotion;

@end
