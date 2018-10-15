
#import <UIKit/UIKit.h>

@interface UNKRecordExpressionListViewC : UIViewController {
    NSMutableArray *arrRecord;
    int pageNumber;
    BOOL isLoading;
}
@property (weak, nonatomic) IBOutlet UITableView *tblRecordParticipant;
-(void)recordParticipantList:(BOOL)showHude type:(NSString*)type searchText:(NSString*)searchText;

@end
