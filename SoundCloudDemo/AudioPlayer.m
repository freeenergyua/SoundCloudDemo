//
//  AudioPlayer.m
//  SoundCloudDemo
//
//  Created by inailuy on 1/19/15.
//  Copyright (c) 2015 inailuy. All rights reserved.
//

#import "AudioPlayer.h"
#import "SoundCloud.h"

@interface AudioPlayer()

@property (nonatomic, strong) AVPlayerItem *playerItem;


@end

@implementation AudioPlayer

-(void) playSongFromURL:(NSURL *)songUrl
{
  
    
    NSString *scToken=[[NSUserDefaults standardUserDefaults] objectForKey:SC_TOKEN];
    NSString *songUrlString = [NSString stringWithFormat:@"%@?oauth_token=%@",songUrl.absoluteString, scToken];
    songUrl = [NSURL URLWithString:songUrlString];
    
    self.playerItem = [AVPlayerItem playerItemWithURL:songUrl];
    
    if (!self.player)
    {
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        
    }
    else
    {
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    }

    [self.player play];
    
}

@end
