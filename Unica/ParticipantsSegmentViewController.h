//
//  ParticipantsSegmentViewController.h
//  Unica
//
//  Created by Ram Niwas on 04/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParticipantsViewController.h"

@interface ParticipantsSegmentViewController : UIViewController<SWRevealViewControllerDelegate,YSLContainerViewControllerDelegate,UISearchBarDelegate>{
    
    ParticipantsViewController *participantsViewAll;
    ParticipantsViewController *participantsViewSend;
    ParticipantsViewController *participantsViewRecieved;
    YSLContainerViewController *containerVC;

    __weak IBOutlet UISearchBar *searchBar;
    __weak IBOutlet UIBarButtonItem *menuButton;
    __weak IBOutlet UIView *segmentView;
    

}

@property(nonatomic,retain) NSString *eventID;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)filterButtonAction:(id)sender;

@end
