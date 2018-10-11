//
//  RadioButtonStep4.h
//  Unica
//
//  Created by Chankit on 3/24/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioButtonStep4 : UITableViewCell

-(void)setData:(NSString *)nameString  dictionary:(NSMutableDictionary*)dictionaty;
-(void)setDataForTestResult:(NSMutableDictionary*)dictionaty isSelected:(BOOL)isSelected;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonX_axis;
@property (weak, nonatomic) IBOutlet UIButton *btnFinancialOption;
@property (weak, nonatomic) IBOutlet UILabel *labelFinacialOption;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkMarkWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkMarkHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkMarkY_axis;
@end
