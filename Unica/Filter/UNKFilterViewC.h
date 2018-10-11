//
//  UNKFilterViewC.h
//  Unica
//
//  Created by Shilpa Sharma on 05/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNKCountryFilterViewC.h"
#import "UNKEventFilterViewC.h"

@protocol delegateRemoveAllFilter <NSObject>
-(void)removeAllFilter:(NSInteger)index;
@end

@interface UNKFilterViewC : UIViewController<SWRevealViewControllerDelegate>{
    __weak IBOutlet UIBarButtonItem *_clearAllButton;
    __weak IBOutlet UIBarButtonItem *_crossButton;
}
@property (nonatomic,retain) id<delegateForCheckApply> applyButtonDelegate;
@property (nonatomic,retain) id<delegateRemoveAllFilter> removeAllFilter;
@property (nonatomic,retain) id<delegateAgentService> agentService;
@property (nonatomic, retain) id<delegateEvent> eventFilterDelegate;
// filter type
@property (nonatomic,retain) NSMutableArray *countryFilter;
@property (nonatomic,retain) NSString *incomingViewType;


- (IBAction)clearAllButton_clicked:(id)sender;
- (IBAction)crossButton_clicked:(id)sender;
@end
