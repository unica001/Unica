//
//  courseFeeCell.h
//  Unica
//
//  Created by sirez on 12/09/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface courseFeeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headinLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descHeightConstant;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headingWidthConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descWidthConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descX_axis;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headingLaelX_Axis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageX_Axis;

@end
