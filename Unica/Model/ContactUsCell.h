//
//  ContactUsCell.h
//  Unica
//
//  Created by vineet patidar on 09/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactUsCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberLabelHeight;

@property (weak, nonatomic) IBOutlet UIButton *_messageButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneNumberButtonWidth;

@end
