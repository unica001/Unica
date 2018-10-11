//
//  RadioButtonStep4.m
//  Unica
//
//  Created by Chankit on 3/24/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "RadioButtonStep4.h"

@implementation RadioButtonStep4

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setData:(NSString *)nameString  dictionary:(NSMutableDictionary*)dictionaty{
    
    self.labelFinacialOption.text = nameString;
    self.labelFinacialOption.textColor = [UIColor colorWithRed:94.0/255.0 green:114.0/255.0 blue:131.0/255.0 alpha:1];
    
    // check mark
    if ([[dictionaty valueForKey:kStep4FinancialSupport] isEqualToString:nameString]) {
        [self.btnFinancialOption setBackgroundImage:[UIImage imageNamed:@"StepCheckedActive"] forState:UIControlStateNormal];
    }
    else{
        [self.btnFinancialOption setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
    }
}

-(void)setDataForTestResult:(NSMutableDictionary*)dictionaty isSelected:(BOOL)isSelected{
    
    self.labelFinacialOption.text = [dictionaty valueForKey:kSub_title];
    
    // check mark
    if (isSelected == true) {
        [self.btnFinancialOption setBackgroundImage:[UIImage imageNamed:@"CheckBoxActive"] forState:UIControlStateNormal];
    }
    else{
        [self.btnFinancialOption setBackgroundImage:[UIImage imageNamed:@"CheckBox"] forState:UIControlStateNormal];
    }
    
    self.checkMarkY_axis.constant = (self.frame.size.height-20)/2;
    self.checkMarkWidth.constant = 20;
    self.checkMarkHeight.constant = 20;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
