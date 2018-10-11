//
//  EventDetailCell.h
//  Unica
//
//  Created by ramniwas on 02/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImageWidth;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *iconTopSpaceconstant;
@end
