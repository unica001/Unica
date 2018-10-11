//
//  RadioButtonStep3.h
//  Unica
//
//  Created by Chankit on 3/23/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioButtonStep3 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelQuestion;
@property (weak, nonatomic) IBOutlet UIButton *btnYES;
@property (weak, nonatomic) IBOutlet UIButton *btnNo;
@property (weak, nonatomic) IBOutlet UIView *viewLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnYESHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnNoWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnNoHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerLabelHeight;

@end
