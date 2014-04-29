//
//  MotionService.m
//  MazeCraze
//
//  Created by Scott Delly on 4/28/14.
//  Copyright (c) 2014 Scott Delly. All rights reserved.
//

#import "MotionService.h"
#import <CoreMotion/CoreMotion.h>

@interface MotionService ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation MotionService

+ (instancetype)sharedInstance
{
    static MotionService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [MotionService new];
    });
    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.gyroUpdateInterval = 0.1f;
        self.motionManager.accelerometerUpdateInterval = 0.1f;
        self.xRotation = 0;
        self.yRotation = 0;
        self.xAccel = 0;
        self.yAccel = 0;
    }
    return self;
}

- (void)beginMonitoringMotion
{
    __weak __typeof__(self) weakSelf = self;
//    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData *gyroData, NSError *error) {
//        [weakSelf deviceDidRotateWithRate:gyroData.rotationRate];
//    }];
//    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        [weakSelf deviceDidAccelerateWithAcceleration:accelerometerData.acceleration];
    }];
}

- (void)deviceDidRotateWithRate:(CMRotationRate)rate
{
    [self setXRotation:rate.x];
    [self setYRotation:rate.y];
    [[NSNotificationCenter defaultCenter] postNotificationName:MC_NOTI_ACCEL_CHANGE object:nil];
}

- (void)deviceDidAccelerateWithAcceleration:(CMAcceleration)acceleration
{
    [self setXAccel:acceleration.x];
    [self setYAccel:acceleration.y];
    [[NSNotificationCenter defaultCenter] postNotificationName:MC_NOTI_ACCEL_CHANGE object:nil];
}

@end
