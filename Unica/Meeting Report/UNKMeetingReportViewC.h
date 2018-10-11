//
//  UNKMeetingReportViewC.h
//  Unica
//
//  Created by Shilpa Sharma on 09/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNKMeetingReportViewC : UIViewController <delegateForCheckApplyButtonAction, delegateForRemoveAllFilter>{
    NSMutableArray *arrReport;
    int pageNumber;
    BOOL isLoading;
}
@property (weak, nonatomic) IBOutlet UITableView *tblReport;
@property (nonatomic,retain) NSString *isFilterApply;
//@property (nonatomic,retain) NSMutableArray *countryFilter;
//@property (nonatomic,retain) NSMutableArray *typeFilter;
@property (nonatomic,retain) NSMutableArray *eventFilter;
@end
