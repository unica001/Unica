//
//  UNKMeetingParticipantViewC.h
//  Unica
//
//  Created by Shilpa Sharma on 09/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNKMeetingParticipantViewC : UIViewController<UISearchBarDelegate> {
    NSMutableArray *arrParticipant;
    __weak IBOutlet UISearchBar *searchBar;
    int pageNumber;
    BOOL isLoading;
}
@property (weak, nonatomic) IBOutlet UITableView *tblParticipant;
@property(nonatomic,retain) NSDictionary *meetingReportDict;
@property(nonatomic,retain) NSString *eventID;


@end
