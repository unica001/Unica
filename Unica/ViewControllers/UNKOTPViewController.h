//
//  UNKOTPViewController.h
//  Unica
//
//  Created by vineet patidar on 02/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNKWelcomeViewController.h"

@interface UNKOTPViewController : UIViewController<UITextFieldDelegate>{
    
    NSTimer *_secondsCountTimer;
    int countResendTimer;
    int _sliderCount;


    __weak IBOutlet UIButton *_resendCodeButton;
    __weak IBOutlet UILabel *_timerLabel;
    __weak IBOutlet UISlider *_timeSlider;
    __weak IBOutlet UITextField *_emailTextField;
    UITextField *_phoneNumberTextField;
    __weak IBOutlet UIView *_whiteView;
    __weak IBOutlet UIScrollView *scrollView;

    __weak IBOutlet UIImageView *_lockImage;
    __weak IBOutlet UILabel *_OTPLabel;
   
    __weak IBOutlet UILabel *_verifyLabel;
    __weak IBOutlet UIButton *_verifyButton;
    __weak IBOutlet UIButton *_cancelButton;
    __weak IBOutlet UIButton *_loginButton;
    __weak IBOutlet UIButton *_checkMarkButton;
    __weak IBOutlet UIWebView *_webView;
    
    NSString *_userID;
    __weak IBOutlet UIView *_editMobileView;
    __weak IBOutlet UILabel *_mobileNumberLabel;
    __weak IBOutlet UIButton *editMobileNumberButton;
    __weak IBOutlet NSLayoutConstraint *editViewHeight;
    
    NSString *_minimum_value;
    NSString *maximum_value;
}
@property (nonatomic) BOOL isAgreeTerms;
@property (nonatomic,retain) NSString *forgotPasswordUserId;
@property (nonatomic,retain) NSString *incomingViewType;

- (IBAction)resendCodeButton_clicked:(id)sender;
- (IBAction)backButton_clicked:(id)sender;
- (IBAction)cancelButton_clicked:(id)sender;
- (IBAction)loginButton_clicked:(id)sender;
- (IBAction)verifyButton_clicked:(id)sender;
- (IBAction)checkMarkButton_clicked:(id)sender;
- (IBAction)editMobileNumberButton_clicked:(id)sender;
- (IBAction)verifyForgotPasswordButton_clicked:(id)sender;

@end
