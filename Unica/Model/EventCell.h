//
//  EventCell.h
//  Unica
//
//  Created by ramniwas on 02/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *_imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressHeight;
@property (weak, nonatomic) IBOutlet UIView *eventBackGroundView;
@property (weak, nonatomic) IBOutlet UIView *viewBG;

@end
