//
//  ViewController.m
//  SoundCloudDemo
//
//  Created by inailuy on 1/6/15.
//  Copyright (c) 2015 inailuy. All rights reserved.
//

#import "UsersLikesVC.h"
#import "UIImageView+AFNetworking.h"
#import "SoundCloud.h"
#import "AppDelegate.h"
#import "LikedTrackObject.h"
#import "AudioPlayer.h"

@interface UsersLikesVC ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) SoundCloud *soundCloud;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AudioPlayer *player;

@property (nonatomic, strong) NSMutableArray *tracksLiked;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation UsersLikesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(longPressTableViewCell:)];
    lpgr.minimumPressDuration = .4; //seconds
    [self.tableView addGestureRecognizer:lpgr];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView
                                             selector:@selector(reloadData)
                                                 name:TRACKS_LOADED_NOTIFIACTION
                                               object:nil];
    
    self.player = [AppDelegate instance].player;
    self.soundCloud = [AppDelegate instance].soundCloud;
    [self.soundCloud loadLikedTrackArray];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender
{
   // NSLog(@"%i", [self.soundCloud login]);
    [self.soundCloud loadLikedTrackArray];
}

- (IBAction)userData:(id)sender
{
    [self.soundCloud loadLikedTrackArray];
}

#pragma mark - UITabeView Datasource/Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    
    if (self.soundCloud.tracksFavorited.count > 0)
    {
        LikedTrackObject *trackObj = self.soundCloud.tracksFavorited[indexPath.row];
        cell.textLabel.text = trackObj.title;
        [cell.imageView setImageWithURL:trackObj.artworkURL placeholderImage:[UIImage imageNamed:@"Icon"]];
    }
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"array size %lu", (unsigned long)self.soundCloud.tracksFavorited.count);
    return self.soundCloud.tracksFavorited.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LikedTrackObject *trackObj = self.soundCloud.tracksFavorited[indexPath.row];
    [self.player playSongFromURL:trackObj.streamURL];
}

- (void)longPressTableViewCell:(UILongPressGestureRecognizer *)gestureRecognizer
{
    //Container *container;
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    LikedTrackObject *obj = self.soundCloud.tracksFavorited[indexPath.row];
    NSString *message = [NSString stringWithFormat:@"would you like to delete %@?", obj.title];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        if (indexPath == nil)
        {
#ifdef DEBUG
            NSLog(@"long press on table view but not on a row");
#endif
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete Track?"
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"no"
                                                      otherButtonTitles:@"yes", nil];
            
            self.indexPath = indexPath;
            [alertView show];
            
        }
    }
}

#pragma mark - UIAlertView -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0){
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            LikedTrackObject *obj = self.soundCloud.tracksFavorited[self.indexPath.row];
            [self.soundCloud deleteTrack:obj.idValue];
            [self.soundCloud loadLikedTrackArray];
        });
    }
}

@end
