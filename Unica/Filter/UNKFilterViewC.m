//
//  UNKFilterViewC.m
//  Unica
//
//  Created by Shilpa Sharma on 05/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "UNKFilterViewC.h"
#import "UNKCountryFilterViewC.h"
#import "UNKEventFilterViewC.h"

@interface UNKFilterViewC () <YSLContainerViewControllerDelegate> {
    YSLContainerViewController *containerVC;
  
    UNKCountryFilterViewC *countryFilterView;
    UNKAgentServiceFilterViewController *serviceFilterViewController;
    UNKEventFilterViewC *eventTypeFilterView;
}

@end

@implementation UNKFilterViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Student" bundle:[NSBundle mainBundle]];
    // country
    countryFilterView = [storyBoard instantiateViewControllerWithIdentifier:@"UNKCountryFilterViewC"];
    countryFilterView.title = kCOUNTRY;
    countryFilterView.incomingViewType = _incomingViewType;
    countryFilterView.applyButtonDelegate = self.applyButtonDelegate;
    
    eventTypeFilterView = [storyBoard instantiateViewControllerWithIdentifier:@"UNKEventFilterViewC"];
    eventTypeFilterView.title = kEVENT;
    eventTypeFilterView.incomingViewType = _incomingViewType;
    eventTypeFilterView.eventDelegate = self.eventFilterDelegate;
    
    
    // service filter
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    serviceFilterViewController = [sb instantiateViewControllerWithIdentifier:kAgentServiceSegueIdentifier];
    serviceFilterViewController.incomingViewType = _incomingViewType;
    serviceFilterViewController.agentService = self.agentService;
    serviceFilterViewController.title = kTYPE;
    
    if ([_incomingViewType isEqualToString:kMeetingFilter]) {
        [self setContainerMeetingReport];
    } else if ([_incomingViewType isEqualToString:kScheduleFilter] || [_incomingViewType isEqualToString:kParticipantFilter]) {
        [self setContainerMyScheduleParticipant];
    } else if ([_incomingViewType isEqualToString:kRecordParticpantFilter]) {
        [self setRecordParticipant];
    }
    
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:kFontSFUITextMedium size:14];
    containerVC.menuBackGroudColor = kDefaultBlueColor;
    containerVC.menuItemSelectedTitleColor = [UIColor whiteColor];
    containerVC.menuItemTitleColor = [UIColor lightGrayColor];
    
    containerVC.menuIndicatorColor = [UIColor whiteColor];
    [self.view addSubview:containerVC.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setContainerMeetingReport {
    containerVC = [[YSLContainerViewController alloc]initWithControllers:@[eventTypeFilterView]
                                                            topBarHeight:0
                                                    parentViewController:self];
    [eventTypeFilterView eventList];
}

- (void)setContainerMyScheduleParticipant {
    containerVC = [[YSLContainerViewController alloc] initWithControllers:@[countryFilterView, serviceFilterViewController] topBarHeight:0 parentViewController:self];
}

- (void)setRecordParticipant {
    containerVC = [[YSLContainerViewController alloc] initWithControllers:@[countryFilterView, serviceFilterViewController, eventTypeFilterView] topBarHeight:0 parentViewController:self];
}

#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    if ([_incomingViewType isEqualToString:kMeetingFilter]) {
        eventTypeFilterView.title = @"EVENT";
        [eventTypeFilterView eventList];
    } else if ([_incomingViewType isEqualToString:kScheduleFilter] || [_incomingViewType isEqualToString:kParticipantFilter]) {
        if (index == 0) {
            countryFilterView.title = kCOUNTRY;
        } else if (index == 1) {
            serviceFilterViewController.title = @"TYPE";
            [serviceFilterViewController searchSeavices];
        }
    } else if ([_incomingViewType isEqualToString:kRecordParticpantFilter]) {
        if (index == 0) {
            countryFilterView.title = kCOUNTRY;
        } else if (index == 1) {
            serviceFilterViewController.title = @"TYPE";
            [serviceFilterViewController searchSeavices];
        } else {
            eventTypeFilterView.title = @"EVENT";
            [eventTypeFilterView eventList];
        }
    }
    [controller viewWillAppear:YES];
}

- (IBAction)clearAllButton_clicked:(id)sender {
    
    [Utility showAlertViewControllerIn:self title:@"" message:@"All filters cleared" block:^(int index){
        
        [kUserDefault setValue:kfilterscleared forKey:kfilterscleared];
        [kUserDefault setValue:@"Yes" forKey:kIsRemoveAll];

        if ([_incomingViewType isEqualToString:kMeetingFilter]) {
            [kUserDefault removeObjectForKey:kselectEventMeeting];
        } else if ([_incomingViewType isEqualToString:kScheduleFilter]) {
            [kUserDefault removeObjectForKey:kselectCountrySchedule];
            [kUserDefault removeObjectForKey:kselectTypeSchedule];
        } else if ([_incomingViewType isEqualToString:kParticipantFilter]) {
            [kUserDefault removeObjectForKey:kselectCountryParticipant];
            [kUserDefault removeObjectForKey:kselectTypeParticipant];
        } else if([_incomingViewType isEqualToString:kRecordParticpantFilter]) {
            [kUserDefault removeObjectForKey:kselectCountryRecord];
            [kUserDefault removeObjectForKey:kselectTypeRecord];
            [kUserDefault removeObjectForKey:kselectEventRecord];
        }
        
        [kUserDefault synchronize];
        
        if ([self.removeAllFilter respondsToSelector:@selector(removeAllFilter:)]) {
            [self.removeAllFilter removeAllFilter:0];
        }
        [self.navigationController popViewControllerAnimated:NO];
    }];
    
    
    
}

- (IBAction)crossButton_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
