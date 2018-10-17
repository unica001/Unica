

#import <UIKit/UIKit.h>

@interface UNKSearchAvailableParticipantCtrl : UIViewController{
    NSMutableArray *arrParticipant;
    __weak IBOutlet UISearchBar *searchBar;
    int pageNumber;
    BOOL isLoading;
    __weak IBOutlet UITableView *tableView;
    __weak IBOutlet UILabel *messageLabel;
}

@property(nonatomic,retain) NSString *selectedSlotID;
- (IBAction)filterButtonAction:(id)sender;
- (IBAction)backButtonAction:(id)sender;
@property (nonatomic,retain) NSString *isFilterApply;
@property (nonatomic,retain) NSMutableArray *countryFilter;
@property (nonatomic,retain) NSMutableArray *typeFilter;
@end
