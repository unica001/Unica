//
//  AgentForgotPasswordVC.h
//  Unica
//
//  Created by meenakshi on 10/04/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgentForgotPasswordVC : UIViewController
{
    
    IBOutlet UILabel *detailTextView;
    IBOutlet UITextField *emailtextField;
        NSString *_minimum_value;
        NSString *maximum_value;
    
}
- (IBAction)backButton_clicked:(id)sender;
- (IBAction)submitButton_clicked:(id)sender;
@property (nonatomic,retain) NSString *type;

@end
