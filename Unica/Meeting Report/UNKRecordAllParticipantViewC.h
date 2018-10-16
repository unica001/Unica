//
//  UNKRecordAllParticipantViewC.h
//  Unica
//
//  Created by Shilpa Sharma on 10/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNKRecordAllParticipantViewC : UIViewController {
    NSMutableArray *arrRecord;
    UILabel *messageLabel;
}
@property (assign, nonatomic) NSInteger pageNumber;
@property (strong, nonatomic) UIWindow *window;

@property (weak, nonatomic) IBOutlet UITableView *tblRecordAllParticipant;
-(void)recordAllParticipantList:(BOOL)showHude type:(NSString*)type searchText:(NSString*)searchText countryId:(NSString *)countryId typeId:(NSString *)typeId eventId:(NSString *)eventId;
@end
