
#import <UIKit/UIKit.h>
#import "GKActionSheetPicker.h"
#import "GKActionSheetPickerItem.h"

@interface UNKRecordExpressionController : UIViewController<SWRevealViewControllerDelegate,GKActionSheetPickerDelegate,UITextViewDelegate>{
    
    __weak IBOutlet UIBarButtonItem *menuButton;
    __weak IBOutlet UITableView *tableView;
}
@property (nonatomic, strong) GKActionSheetPicker *picker;
@property (nonatomic, strong) NSDate *dateCellSelectedDate;

@end
