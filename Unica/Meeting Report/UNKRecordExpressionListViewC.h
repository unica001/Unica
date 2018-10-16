
#import <UIKit/UIKit.h>

@interface UNKRecordExpressionListViewC : UIViewController {
    NSMutableArray *arrRecord;
    BOOL isLoading;
    UILabel *messageLabel;
}
@property (assign, nonatomic) NSInteger pageNumber;
@property (weak, nonatomic) IBOutlet UITableView *tblRecordParticipant;
-(void)recordParticipantList:(BOOL)showHude type:(NSString*)type searchText:(NSString*)searchText countryId:(NSString *)countryId typeId:(NSString *)typeId eventId:(NSString *)eventId;

@end
