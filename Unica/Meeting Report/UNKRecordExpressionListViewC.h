//
//  UNKRecordExpressionListViewC.h
//  Unica
//
//  Created by Shilpa Sharma on 10/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNKRecordExpressionListViewC : UIViewController {
    NSMutableArray *arrRecord;
    int pageNumber;
    BOOL isLoading;
}
@property (weak, nonatomic) IBOutlet UITableView *tblRecordParticipant;
-(void)recordParticipantList:(BOOL)showHude type:(NSString*)type searchText:(NSString*)searchText;

@end
