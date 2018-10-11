//
//  PredictLevelCell.m
//  Unica
//
//  Created by vineet patidar on 09/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "PredictLevelCell.h"

@implementation PredictLevelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerLabel.text= @"How Do you rate your English Proficiency? \n Predict your level";
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
