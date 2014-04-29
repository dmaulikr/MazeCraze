//
//  Singleton.h
//  MazeCraze
//
//  Created by Scott Delly on 4/28/14.
//  Copyright (c) 2014 Scott Delly. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Singleton <NSObject>

+ (instancetype)sharedInstance;

@end
