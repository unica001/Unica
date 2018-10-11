//
//  UNKInstitudeVideoViewController.h
//  Unica
//
//  Created by vineet patidar on 30/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import "MessagePopViewController.h"

@interface UNKInstitudeVideoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>{
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *institudeNameLabel;
    __weak IBOutlet UITableView *_videoTabel;
    
    NSMutableArray *_videoArray;
    
    NSMutableDictionary *_videoLiberayDictionary;
    __weak IBOutlet UIButton *_likeButton;
    __weak IBOutlet UICollectionView *collectionView;

    __weak IBOutlet UIButton *_fbButton;
    __weak IBOutlet UIButton *_twitterButton;
    __weak IBOutlet UIButton *linkedInButton;
    __weak IBOutlet UIButton *_youTubeButton;
    
    BOOL isHude;
}
@property (nonatomic,retain) NSMutableDictionary *institudeDictionary;
@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;
@property (nonatomic,retain)  NSMutableArray *favouriteArray;
@property (nonatomic,retain) NSString *incomingViewType;

-(void)getVideoLiberayData:(NSMutableDictionary *)selectedDictionary;
- (IBAction)messageButton_clicked:(id)sender;
- (IBAction)likeButton_clicked:(id)sender;
- (IBAction)fbButton_clicked:(id)sender;
- (IBAction)twitterButton_clicked:(id)sender;
- (IBAction)linkedInButton_clicked:(id)sender;
- (IBAction)youTubeButton_clicked:(id)sender;

@end
