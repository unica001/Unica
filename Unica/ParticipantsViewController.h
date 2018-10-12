//
//  ParticipantsViewController.h
//  Unica
//
//  Created by Ram Niwas on 04/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParticipantsCell.h"
#import "ParticipantDetailViewController.h"
#import "ADPopupView.h"

@interface ParticipantsViewController : UIViewController<ADPopupViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    __weak IBOutlet UITableView *tableView;
    
    int pageNumber;
    int totalRecord;
    BOOL isLoading;
    BOOL isHude;
    BOOL isFromFilter;
    BOOL LoadMoreData;
    NSMutableArray *participantArray;
    
    __weak IBOutlet UIButton *selectAllButton;
    __weak IBOutlet UILabel *messageLabel;
    __weak IBOutlet UIView *bottomView;
    __weak IBOutlet UILabel *countLabel;
    __weak IBOutlet NSLayoutConstraint *bottomViewHeight;
    NSInteger selectedIndex;
}

@property (nonatomic, strong) ADPopupView *visiblePopup;



-(void)reloadParticipantsData:(NSInteger)index type:(NSString *)type searchText:(NSString*)searchText fromSearch:(BOOL)fromSearch;

- (IBAction)selectAllButtonAction:(id)sender;
@end
