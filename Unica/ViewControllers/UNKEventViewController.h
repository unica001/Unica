//
//  UNKEventViewController.h
//  Unica
//
//  Created by ramniwas on 02/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNKAgentFilterViewController.h"

@interface UNKEventViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource,SWRevealViewControllerDelegate,UISearchBarDelegate,delegateForCheckApplyButtonAction,delegateForRemoveAllFilter>{
    
    __weak IBOutlet UITableView *_eventTable;
    __weak IBOutlet UIBarButtonItem *_backButton;
    __weak IBOutlet UISearchBar *_searchBar;
    
    NSString *_cityFilterIDs;
    NSString *_countyFilterIDs;
    

    NSMutableArray *_eventArray;
    
    int pageNumber;
    int totalRecord;
    BOOL isLoading;
    UILabel *messageLabel;
 
    __weak IBOutlet UIButton *_filterButton;
    
    NSTimer *_timer;
}

@property (nonatomic,retain) NSString *isFilterApply;
@property (nonatomic,retain) NSString *eventId;
@property (nonatomic,retain) NSMutableArray *eventCityFilterArray;
@property (nonatomic,retain) NSMutableArray *eventCountryFilterArray;
@property (nonatomic,retain) NSString *incomingViewType;

- (IBAction)backButton_clicked:(id)sender;
- (IBAction)filterButton_clicked:(id)sender;

@end
