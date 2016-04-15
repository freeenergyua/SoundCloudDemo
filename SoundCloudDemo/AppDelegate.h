//
//  AppDelegate.h
//  SoundCloudDemo
//
//  Created by inailuy on 1/6/15.
//  Copyright (c) 2015 inailuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundCloud.h"
#import "AudioPlayer.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SoundCloud *soundCloud;
@property (strong, nonatomic) AudioPlayer *player;

+ (AppDelegate *)instance;

@end

