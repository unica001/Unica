//
//  CourserFilterCell.h
//  Unica
//
//  Created by vineet patidar on 28/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourserFilterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *checkMarkLeftImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkMarkLeftImageHeight;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checmarkRightImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkMarkRightImageWidth;

@end
