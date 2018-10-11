//
//  ShortlistCourseCell.h
//  Unica
//
//  Created by Shilpa Sharma on 03/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShortlistCourseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *placeHoderImageView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *universityNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *countryName;
@property (weak, nonatomic) IBOutlet UIButton *courseTopButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseTopButtonHeight;
@property (weak, nonatomic) IBOutlet UIView *imageBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *countryName2;

// constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseNameLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *universityNameLabelHeight;

@property (weak, nonatomic) IBOutlet UIView *courseView;


@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@end
