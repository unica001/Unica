//
//  UNKCourseDetailsViewController.h
//  Unica
//
//  Created by vineet patidar on 29/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "YTPlayerView.h"
#import <CTVideoPlayerView/CTVideoViewCommonHeader.h>
#import "UNKWebViewController.h"
#import "GlobalApplicationStep1ViewController.h"
#import "UNKInstitudeViewController.h"
#import "UNKQuestionnaireViewController.h"

@interface UNKCourseDetailsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate,AVPlayerViewControllerDelegate,YTPlayerViewDelegate,UIWebViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{

    __weak IBOutlet YTPlayerView *ytPlayerView;

    AVPlayer *video;
    AVPlayerViewController *viewController;
    
    NSMutableDictionary *courseDetailDictioanry;
    
    __weak IBOutlet UITableView *_courseDetailTable;
    __weak IBOutlet UIImageView *_countryImage;
    __weak IBOutlet UILabel *_countryName;
    __weak IBOutlet UILabel *_universityName;
    __weak IBOutlet UILabel *_countryName2;
  
    __weak IBOutlet UIView *_headerView;
    
    __weak IBOutlet UIView *_imageBackgroundView;
    __weak IBOutlet UIButton *_checkMarkButton;
    __weak IBOutlet UIButton *_likeButton;
    
    __weak IBOutlet UILabel *courseName;
 
    __weak IBOutlet NSLayoutConstraint *_universityNameHeight;
    __weak IBOutlet NSLayoutConstraint *_courseNameHeight;
    __weak IBOutlet UIButton *_videoButton;
    __weak IBOutlet UIButton *_applyButton;
    __weak IBOutlet UIView *_fooderView;
    
    __weak IBOutlet UILabel *videoLabel;
    BOOL isInfoClicked;
    UIView  *popupView;
    NSString *textMessage;
    NSString *subTitle;
    NSString *amount;
    UIView  *bgView;

  __weak IBOutlet UICollectionView *coursVideoCollectionView;
    __weak IBOutlet NSLayoutConstraint *videoButtonHeight;
    __weak IBOutlet NSLayoutConstraint *playerViewHeight;
    __weak IBOutlet NSLayoutConstraint *collectionViewHeight;
}

- (IBAction)institudeDetailsButton_clicked:(id)sender;
@property(nonatomic) BOOL feePaidStatus;
@property(nonatomic,retain) NSString *unica_fee;
@property(nonatomic) NSInteger applied_count;
@property(nonatomic) NSInteger apply_limit;
@property(nonatomic,retain) NSString *unica_feeCurrancy;

@property (nonatomic,retain) NSMutableDictionary *selectedCourseDictionary;
@property (nonatomic,retain) NSString *incomingViewType;
@property (nonatomic,retain)  NSMutableArray *favouriteArray;


- (IBAction)backButton_clicked:(id)sender;
- (IBAction)videoButton_clicked:(id)sender;
- (IBAction)applyButton_clicked:(id)sender;
- (IBAction)likeButton_clicked:(id)sender;

@end
