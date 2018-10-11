//
//  AgentReviewCell.h
//  Unica
//
//  Created by vineet patidar on 27/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgentReviewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewDescriptionHeight;

@end
