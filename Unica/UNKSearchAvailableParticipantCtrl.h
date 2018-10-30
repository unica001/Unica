

#import <UIKit/UIKit.h>
#import "ParticipantsCell.h"

@interface UNKSearchAvailableParticipantCtrl : UIViewController{
    NSMutableArray *arrParticipant;
    __weak IBOutlet UISearchBar *searchBar;
    int pageNumber;
    BOOL isLoading;
    __weak IBOutlet UITableView *tableView;
    __weak IBOutlet UILabel *messageLabel;
    
    __weak IBOutlet UIButton *selectAllButton;
    __weak IBOutlet UIView *bottomView;
    __weak IBOutlet UILabel *countLabel;
    __weak IBOutlet NSLayoutConstraint *bottomViewHeight;
}

- (IBAction)selectAllButtonAction:(id)sender;
- (IBAction)filterButtonAction:(id)sender;
- (IBAction)backButtonAction:(id)sender;

@property(nonatomic,retain) NSString *selectedSlotID;
@property (nonatomic,retain) NSString *isFilterApply;
@property (nonatomic,retain) NSMutableArray *countryFilter;
@property (nonatomic,retain) NSMutableArray *typeFilter;
@end
