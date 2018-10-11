//
//  UNKForgotPasswordViewController.h
//  Unica
//
//  Created by vineet patidar on 02/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNKForgotPasswordViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate>{
    __weak IBOutlet UIScrollView *_scrollView;
    __weak IBOutlet UIView *_forgotPasswordWhiteView;

    __weak IBOutlet UITextField *_emailTextField;
    __weak IBOutlet UILabel *txtLabel;
    
    NSString *_minimum_value;
    NSString *maximum_value;

}
- (IBAction)backButton_clicked:(id)sender;
- (IBAction)submitButton_clicked:(id)sender;
@property (nonatomic,retain) NSString *type;
@end
