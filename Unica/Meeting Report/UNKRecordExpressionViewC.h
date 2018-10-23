//
//  UNKRecordExpressionViewC.h
//  Unica
//
//  Created by Shilpa Sharma on 10/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNKRecordExpressionViewC : UIViewController<SWRevealViewControllerDelegate> {
    
    __weak IBOutlet UIBarButtonItem *menuButton;
}
- (IBAction)backButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,retain) NSMutableArray *countryFilter;
@property (nonatomic,retain) NSMutableArray *typeFilter;
@property (nonatomic,retain) NSMutableArray *eventFilter;
@property (nonatomic,retain) NSString *isFilterApply;
@property(nonatomic,retain) NSString *fromView;
@end
