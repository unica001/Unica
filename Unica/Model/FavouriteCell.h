//
//  FavouriteCell.h
//  Unica
//
//  Created by vineet patidar on 06/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavouriteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *_addressLabel;

@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *callButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelHeight;
@property (strong, nonatomic) IBOutlet UIImageView *_bgView;

@end
