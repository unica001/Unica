//
//  MPStep1TextFieldCell.m
//  Unica
//
//  Created by vineet patidar on 07/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "MPStep1TextFieldCell.h"

@implementation MPStep1TextFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
