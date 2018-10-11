//
//  UNKAgentDetailsSliderViewController.h
//  Unica
//
//  Created by vineet patidar on 24/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNKAgentAboutViewController.h"
#import "UNKAgentReviewViewController.h"
#import "UNKAgentMessageViewController.h"


@interface UNKAgentDetailsSliderViewController : UIViewController
{

    IBOutlet UIImageView *_bgImage;
    __weak IBOutlet UIImageView *_profileImage;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_serviceLabel;
    __weak IBOutlet UIView *_ratingView;
    
    IBOutlet UIButton *_favoriteButton;
     
    IBOutlet UIButton *_callButton;
    __weak IBOutlet UILabel *_addressLabel;
    __weak IBOutlet NSLayoutConstraint *nameLabelHeight;
    __weak IBOutlet NSLayoutConstraint *_addressLabelHeight;
    __weak IBOutlet NSLayoutConstraint *_headerViewHeight;
    __weak IBOutlet UIView *_headerView;
}

@property (nonatomic,retain) NSString *incomingViewType;
@property (nonatomic,retain)  NSMutableArray *favouriteArray;

@property (nonatomic,retain) NSMutableDictionary *agentDictionary;
@property (nonatomic,retain) NSMutableDictionary *agentStaticDictionary;

- (IBAction)callButton_clicked:(id)sender;
- (IBAction)favoriteButton_clicked:(id)sender;
- (IBAction)backButton_clicked:(id)sender;
@end
