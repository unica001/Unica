//
//  UNKAgentFilterViewController.h
//  Unica
//
//  Created by vineet patidar on 21/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNKAgentRatingFilterViewController.h"
#import "UNKAgentLocationFilterViewController.h"
#import "UNKAgentServiceFilterViewController.h"
#import "UNKCourseFilterViewController.h"

@protocol delegateForRemoveAllFilter <NSObject>
-(void)removeAllFilter:(NSInteger)index;
@end

@interface UNKAgentFilterViewController : UIViewController<SWRevealViewControllerDelegate>{

    __weak IBOutlet UIBarButtonItem *_clearAllButton;
    __weak IBOutlet UIBarButtonItem *_crossButton;
    
    
}

@property (nonatomic,retain) NSString *incomingViewType;
@property (nonatomic,retain) id<delegateForCheckApplyButtonAction> applyButtonDelegate;
@property (nonatomic,retain) id<delegateForRemoveAllFilter> removeAllFilter;
@property (nonatomic,retain) id <agentFilterDelegate> agentFilter;
@property (nonatomic,retain) id<deleageAgentLocationFilter> agentLocation;
@property (nonatomic,retain) id <delegateAgentService> agentService;


// course filter type
@property (nonatomic,retain) NSMutableArray *institutionFilter;
@property (nonatomic,retain) NSMutableArray *countryFilter;
@property (nonatomic,retain) NSMutableArray *scholarShipFilter;
@property (nonatomic,retain) NSMutableArray *perfectFilter;


@property (nonatomic,retain)  NSString *ratingString;
@property (nonatomic,retain)  NSString *locationString;


@property (nonatomic,retain) NSMutableArray *eventCityFilterArray;
@property (nonatomic,retain) NSMutableArray *eventCountryFilterArray;


- (IBAction)clearAllButton_clicked:(id)sender;
- (IBAction)crossButton_clicked:(id)sender;

@end
