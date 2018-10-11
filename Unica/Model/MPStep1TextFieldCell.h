//
//  MPStep1TextFieldCell.h
//  Unica
//
//  Created by vineet patidar on 07/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPStep1TextFieldCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *completeCheckMark;
@property (weak, nonatomic) IBOutlet UIButton *ongoingCheckMark;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIImageView *searchImage;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *downArraowImage;


@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backGroundViewHeight;

@end
