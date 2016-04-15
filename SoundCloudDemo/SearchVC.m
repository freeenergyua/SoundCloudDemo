//
//  SearchVC.m
//  SoundCloudDemo
//
//  Created by inailuy on 1/13/15.
//  Copyright (c) 2015 inailuy. All rights reserved.
//

#import "SearchVC.h"
#import "AppDelegate.h"
#import "SoundCloud.h"
#import "LikedTrackObject.h"
#import "AudioPlayer.h"
#import "UIImageView+AFNetworking.h"

static char deleteKey;

@interface SearchVC ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) SoundCloud *soundCloud;
@property (nonatomic, strong) NSMutableArray *searchQueryResults;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AudioPlayer *player;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.player = [AppDelegate instance].player;
    self.soundCloud = [AppDelegate instance].soundCloud;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(longPressTableViewCell:)];
    lpgr.minimumPressDuration = .4; //seconds
    [self.tableView addGestureRecognizer:lpgr];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        self.searchQueryResults = [self.soundCloud searchForTracksWithQuery:@"rl grime"];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.tableView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view.window endEditing:YES];
}

#pragma mark - UISearchBarDelegate -

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{

}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@", searchText);
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarTextDidEndEditing %@", searchBar.text);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view.window endEditing:YES];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        self.searchQueryResults = [self.soundCloud searchForTracksWithQuery:searchBar.text];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.tableView reloadData];
        });
    });
}

#pragma mark - UITableView Delegate/DataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Id"];
    
    LikedTrackObject *obj = self.searchQueryResults[indexPath.row];
    
    cell.textLabel.text = obj.title;
    [cell.imageView setImageWithURL:obj.artworkURL placeholderImage:[UIImage imageNamed:@"Icon"]];
    
    //[albumCover setImageWithURL:tmp.imgURL placeholderImage:[UIImage imageNamed:@"Icon"]];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchQueryResults.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LikedTrackObject *trackObj = self.searchQueryResults[indexPath.row];
    [self.player playSongFromURL:trackObj.streamURL ];
}

- (void)longPressTableViewCell:(UILongPressGestureRecognizer *)gestureRecognizer
{
    //Container *container;
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    LikedTrackObject *obj = self.searchQueryResults[indexPath.row];
    NSString *message = [NSString stringWithFormat:@"would you like to favorite %@?", obj.title];
    
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
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Favorite Track?"
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
            LikedTrackObject *obj = self.searchQueryResults[self.indexPath.row];
            [self.soundCloud favoriteTrack:obj.idValue];
            [self.soundCloud loadLikedTrackArray];
        });
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
