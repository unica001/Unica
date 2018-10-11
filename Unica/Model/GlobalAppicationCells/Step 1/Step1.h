//
//  Step1.h
//  Unica
//
//  Created by Chankit on 3/7/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Step1 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelSubTitle;
@property (weak, nonatomic) IBOutlet UITextField *textInputData;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidth;

@property (weak, nonatomic) IBOutlet UIView *viewSectionFooter;
@property (weak, nonatomic) IBOutlet UIView *viewSectionHeader;
@property (weak, nonatomic) IBOutlet UIButton *btnCalender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeight;

@end
