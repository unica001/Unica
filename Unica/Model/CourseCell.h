//
//  CourseCell.h
//  Unica
//
//  Created by vineet patidar on 28/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *placeHoderImageView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scholarshipLabel;
@property (weak, nonatomic) IBOutlet UILabel *universityNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UIButton *chemarkButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *countryName;
@property (weak, nonatomic) IBOutlet UIButton *courseTopButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseTopButtonHeight;
@property (weak, nonatomic) IBOutlet UIView *imageBackgroundView;

// constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseNameLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feeLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scholarshipLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *universityNameLabelHeight;

@property (weak, nonatomic) IBOutlet UIView *courseView;
@property (weak, nonatomic) IBOutlet UIButton *universityButton;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@end
