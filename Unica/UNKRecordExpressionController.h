
#import <UIKit/UIKit.h>
#import "GKActionSheetPicker.h"
#import "GKActionSheetPickerItem.h"
#import "RecordExpressionCell.h"
#import "TOCropViewController.h"

@interface UNKRecordExpressionController : UIViewController<GKActionSheetPickerDelegate,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TOCropViewControllerDelegate,UITextViewDelegate>{
    
    __weak IBOutlet UIBarButtonItem *menuButton;
    __weak IBOutlet UITableView *tableView;
    __weak IBOutlet UILabel *orgNameLabel;
    __weak IBOutlet UICollectionView *collectionView;
    __weak IBOutlet UIImageView *businessCartImage;
}

@property (nonatomic, strong) GKActionSheetPicker *picker;
@property (nonatomic, strong) NSDate *dateCellSelectedDate;
@property (nonatomic, strong) NSString *participantId;
- (IBAction)scanBusinessCartAction:(id)sender;
- (IBAction)submitButtonAction:(id)sender;
- (IBAction)cancelButtonAcrtion:(id)sender;

@end
