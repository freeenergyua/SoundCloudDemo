//
//  AppDelegate.m
//  SoundCloudDemo
//
//  Created by inailuy on 1/6/15.
//  Copyright (c) 2015 inailuy. All rights reserved.
//

#import "AppDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import "SoundCloud.h"

/*
//Redirect URI http://www.mxtap.es/redirectsoundcloud

NSString * const kBaseURL = @"https://api.soundcloud.com";
NSString * const kConnectURL = @"https://api.soundcloud.com/connect";
NSString * const kOauth2URL = @"https://api.soundcloud.com/oauth2/token";

NSString * const kClientID = @"client_id";
NSString * const kClientSecret = @"client_secret";
NSString * const kRedirctURL = @"redirect_uri";

#define CLIENT_ID @"7bc951b0417a018ebcbdb97e40e7e886"
#define CLIENT_SECRET @"cf2630dfddfd203251a95707a5629e89"
#define REDIRECT_URL @"http://www.mxtap.es/redirectsoundcloud"
*/


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

//[[NSUserDefaults standardUserDefaults] setObject:self.scToken forKey:SC_TOKEN];
    
    
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:SC_TOKEN]);
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:NULL];
    
    self.player = [[AudioPlayer alloc] init];
    self.soundCloud =[[SoundCloud alloc]init];
    [self.soundCloud login];
    
    return YES;
}

// this happens while we are running ( in the background, or from within our own app )
// only valid if Info.plist specifies a protocol to handle
- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)url
{
    if (!url) {
        return NO;
    }
    
    [self checkForSoundCloudLogin:url.absoluteString];
    //do your other custom url handling here
    
    return YES;
}

-(void) checkForSoundCloudLogin :(NSString *) url
{
    if( [url rangeOfString:REDIRECT_URI].location!=NSNotFound)
    {
        NSLog(@"Found oauth");
        //NSArray *tokenArray =[url componentsSeparatedByString:@"token"];
        NSArray *codeArray =[url componentsSeparatedByString:@"code="];
        NSLog(@"If logging in does not work, please look for this log message and check if the code is being stored correctly");
        if(codeArray.count>1) {
            NSString *code = codeArray[1];
            if([code hasSuffix:@"#"])code = [code substringToIndex:code.length-1];
            NSLog(@"Found login code for SoundCloud");
            [[NSUserDefaults standardUserDefaults] setObject:code forKey:SC_CODE];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (AppDelegate *)instance
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

@end
