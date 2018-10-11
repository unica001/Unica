//
//  UNKAgentViewController.h
//  Unica
//
//  Created by vineet patidar on 15/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"

@interface UNKAgentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SWRevealViewControllerDelegate,UISearchBarDelegate,agentFilterDelegate,delegateForRemoveAllFilter,deleageAgentLocationFilter,delegateAgentService,CLLocationManagerDelegate>{

    __weak IBOutlet UISearchBar *_searchBar;
    __weak IBOutlet UITableView *_agentTable;
    __weak IBOutlet UIBarButtonItem *_backButton;
    __weak IBOutlet UIButton *_filterButton;

   UIButton *_sendEmailButton;
   UIButton *_callButton;
   UIButton *_favoriteButton;
    
   NSMutableArray *_agentArray;
    NSInteger selectedIndex;
    
    int pageNumber;
    int totalRecord;
    BOOL isLoading;
    BOOL loadMore;
    UILabel *messageLabel;
    
    NSTimer *_timer;

    __weak IBOutlet UIView *_messageView;
    __weak IBOutlet UIView *_messageBGView;
    __weak IBOutlet UIView *_messageUsView;
    __weak IBOutlet UITextView *_textView;
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLGeocoder *geocoder;
    __weak IBOutlet NSLayoutConstraint *bartopconstant;
}

@property (nonatomic,retain) NSString *ratingFilter;
@property (nonatomic,retain) NSString *incomingViewType;
@property (nonatomic,retain) NSString *isFilterApply;

@property(nonatomic, strong) id<GAITracker> tracker;

- (IBAction)sendButton_clicked:(id)sender;

- (IBAction)backButton_clicked:(id)sender;
- (IBAction)filterButton_clicked:(id)sender;
- (IBAction)cancelButton_clicked:(id)sender;
@property ( nonatomic) double lat;
@property ( nonatomic) double lon;
@end
