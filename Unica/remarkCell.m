//
//  remarkCell.m
//  Unica
//
//  Created by Meenkashi on 4/7/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "remarkCell.h"

@implementation remarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.remarktextView.layer.borderWidth = 1;
    self.remarktextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
