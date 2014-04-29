//
//  SettingService.h
//  MazeCraze
//
//  Created by Scott Delly on 4/28/14.
//  Copyright (c) 2014 Scott Delly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingService : NSObject

- (void)saveSetting:(id)value forKey:(NSString *)key;
- (id)loadSettingForKey:(NSString *)key;

@end
