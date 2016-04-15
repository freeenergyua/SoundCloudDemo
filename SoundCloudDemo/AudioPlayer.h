//
//  AudioPlayer.h
//  SoundCloudDemo
//
//  Created by inailuy on 1/19/15.
//  Copyright (c) 2015 inailuy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer : NSObject

@property (nonatomic, strong) AVPlayer *player;

-(void) playSongFromURL:(NSURL *)songUrl;

@end
