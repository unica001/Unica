//
//  UNKInstitudeViewController.h
//  Unica
//
//  Created by vineet patidar on 30/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNKInstitudeInfoViewController.h"
#import "UNKInstitudeVideoViewController.h"
#import "UNKAboutInstitudeViewController.h"
#import "UNKInstitudeCourseViewController.h"



@interface UNKInstitudeViewController : UIViewController<YSLContainerViewControllerDelegate>
{
    UNKAboutInstitudeViewController *_institudeInfoViewController;
    UNKInstitudeVideoViewController *_institudeVideoViewController;
    UNKAboutInstitudeViewController *_aboutInstitudeViewController;
    UNKInstitudeCourseViewController *_institudeCourseViewController;
    
    YSLContainerViewController *containerVC;
}
- (IBAction)backButton_clicked:(id)sender;
- (IBAction)notificationButton_clicked:(id)sender;

@property (nonatomic,retain)  NSMutableArray *favouriteArray;
@property (nonatomic,retain) NSString *incomingViewType;

@property (nonatomic,retain) NSMutableDictionary *institudeDictionary;

@end
