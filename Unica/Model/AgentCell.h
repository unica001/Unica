//
//  AgentCell.h
//  Unica
//
//  Created by vineet patidar on 15/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *_profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIView *ratingBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLabelHeight;
@property (weak, nonatomic) IBOutlet UIView *agentCellBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *agentCellBGViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *callButtonWidth;
@property (weak, nonatomic) IBOutlet UIView *viewBG;

@end
