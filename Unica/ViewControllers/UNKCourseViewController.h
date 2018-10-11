//
//  UNKCourseViewController.h
//  Unica
//
//  Created by vineet patidar on 28/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import "UNKQuestionnaireViewController.h"
#import "MRMSDevFPiOS.h"
#import "PaymentModeViewController.h"
#import "UNKCourseDetailsViewController.h"
#import "PaymentPop.h"

@interface UNKCourseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SWRevealViewControllerDelegate,UISearchBarDelegate,delegateForCheckApplyButtonAction,delegateForRemoveAllFilter>{
    
    __weak IBOutlet UISearchBar *_searchBar;
    __weak IBOutlet UITableView *_courseTable;
    __weak IBOutlet UIBarButtonItem *_backButton;
    
    UIButton *_chemarkButton;
    UIButton *_favoriteButton;
    
    NSMutableArray *_courseArray;
    
    int pageNumber;
    int totalRecord;
    BOOL isLoading;
    BOOL isHude;

    UILabel *messageLabel;
    
    NSTimer *_timer;
    __weak IBOutlet UISegmentedControl *_segment;
    
    BOOL isInfoClicked;
    UIView  *popupView;
    NSString *textMessage;
    NSString *subTitle;
    NSString *amount;
    UIView  *bgView;
    
}
@property(nonatomic,retain)NSString *reference_no;
@property (nonatomic,retain) NSString *ratingFilter;
@property (nonatomic,retain) NSString *incomingViewType;

@property (nonatomic,retain) NSString *isFilterApply;

// filter string
@property (nonatomic,retain) NSMutableArray *institutionFilter;
@property (nonatomic,retain) NSMutableArray *countryFilter;
@property (nonatomic,retain) NSMutableArray *scholarShipFilter;
@property (nonatomic,retain) NSMutableArray *perfectFilter;



- (IBAction)segment_clicked:(id)sender;
- (IBAction)filterButton_clicked:(id)sender;

- (IBAction)backButton_clicked:(id)sender;
@end
