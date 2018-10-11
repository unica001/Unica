//
//  UNKAgentRatingFilterViewController.h
//  Unica
//
//  Created by vineet patidar on 21/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol agentFilterDelegate <NSObject>
-(void)agentRatingFilter:(NSString *)rating;
@end

@interface UNKAgentRatingFilterViewController : UIViewController{

    __weak IBOutlet UIView *_ratingBackGroundView;
    __weak IBOutlet UILabel *ratingTitle;
    __weak IBOutlet UIView *_ratingView;
    __weak IBOutlet UIButton *applyFilter;
    
    NSMutableDictionary *filterDictionaty;
}
- (IBAction)applyFilterButton_clicked:(id)sender;

@property (nonatomic,retain) id <agentFilterDelegate> agentFilter;

@end
