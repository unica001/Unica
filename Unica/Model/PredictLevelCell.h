//
//  PredictLevelCell.h
//  Unica
//
//  Created by vineet patidar on 09/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PredictLevelCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *IELTSLabel;
@property (weak, nonatomic) IBOutlet UILabel *TOEFLLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IELSLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TOEFlabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLine1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLine2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightConstant;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@end
