//
//  UNKOTPViewController.m
//  Unica
//
//  Created by vineet patidar on 02/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKOTPViewController.h"
#import "PhoneNumberFormatter.h"
#import "UNKSignInViewController.h"
#import "UNKWebViewController.h"
#import "UNKChangePasswordViewController.h"


@interface UNKOTPViewController (){
    
    NSMutableDictionary *loginDictionary;
}

@end

@implementation UNKOTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // make view round up
    _whiteView.layer.cornerRadius = 5.0;
    [_whiteView.layer setMasksToBounds:YES];
    
    // code for enable resend code button
    
    _timeSlider.value = 0;
    _sliderCount = 0;
    
    countResendTimer = 60;
    _timerLabel.text = [NSString stringWithFormat:@"%d sec",countResendTimer];
    _secondsCountTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(secondsCountTimerShedule) userInfo:nil repeats:YES];
    [self setMobilevalidationString];
    loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    if(loginDictionary.count>0)
    {
        _userID = [loginDictionary valueForKey:Kuserid];
    }
    else
    {
        _userID= _forgotPasswordUserId;
    }
    
    
    // check incomingview type
    if ([self.incomingViewType isEqualToString:kRegister]) {
        
        _lockImage.image = [UIImage imageNamed:@"Mobile"];
        _OTPLabel.text = @"Sit Back & Relax! you will receive an OTP on your registered Email Id.";
        _verifyLabel.text = @"Enter OTP below in case if we fail to detect it automatically ";
        // self.title = @"Mobile Verification";
        
        _cancelButton.hidden = YES;
        _loginButton.hidden = YES;
        _verifyButton.hidden = NO;
        
        _webView.hidden = NO;
        _checkMarkButton.hidden = NO;
        
        [_webView loadHTMLString:@"<font face = 'arial'><span style='font-size:14px;color:#FFFFFF'><p>I agree with <a href='' style='color:#FFFFFF;'>Terms & Conditions</a></p></span></font> " baseURL:nil];
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
        
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor clearColor]];
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        
        _mobileNumberLabel.text = [loginDictionary valueForKey:kEmail];
        
        
    }
    else {
        
        _cancelButton.hidden = NO;
        _loginButton.hidden = NO;
        _verifyButton.hidden = YES;
        
        _webView.hidden = YES;
        _checkMarkButton.hidden = YES;
        
        editViewHeight.constant = 0;
        _editMobileView.hidden = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma TextField Delegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if (textField == _phoneNumberTextField) {
        
        [_phoneNumberTextField resignFirstResponder];
    }
    
    
    return YES;
}



- (BOOL) textField: (UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString: (NSString *)string {
    
    if(textField == _phoneNumberTextField )
    {
        NSString *strQueryString;
        if((range.length == 0) && (string.length > 0)){
            NSString *strStarting = [textField.text substringToIndex:range.location];
            NSString *strEnding = [textField.text substringFromIndex:range.location];
            strQueryString = [NSString stringWithFormat:@"%@%@%@",strStarting,string,strEnding];
        }
        else{
            NSString *strStarting = [textField.text substringToIndex:range.location];
            NSString *strEnding = [textField.text substringFromIndex:range.location];
            if(strEnding.length > 0)
                strEnding = [strEnding substringFromIndex:range.length];
            strQueryString = [NSString stringWithFormat:@"%@%@",strStarting,strEnding];
        }
        
        if(strQueryString.length == 0){
            return YES;
        }
        
        
        // All digits entered
        if (range.location == 14) {
            return NO;
        }
        strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@"(" withString:@""];
        strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@")" withString:@""];
        strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@" " withString:@""];
        strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        PhoneNumberFormatter *formatter = [[PhoneNumberFormatter alloc] init];
        NSLog(@"%@",[formatter formatForUS:strQueryString]);
        textField.text = [formatter formatForUS:strQueryString];
        
        
        
        return NO;
    }
    
    else{
        
        if(string.length==0)
        {
            return YES;
        }
        else
        {
            NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            NSUInteger newLength = newString.length;
            
            if(textField==_emailTextField && newLength ==5)
            {
                [_emailTextField resignFirstResponder];
                
            }
            
            return YES;
        }
    }
    
    return YES;
    
}

#pragma mark - Butoon Clicked

/****************************
 * Function Name : - resendCode_Clicked
 * Create on : -  03 marcj 2017
 * Developed By : - Ramniwas
 * Description : - This Function are used for resend OTP
 
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
- (IBAction)resendCodeButton_clicked:(id)sender {
    
    _sliderCount = 0;
    _timeSlider.value = 0;
    countResendTimer = 60;
    _timerLabel.text = [NSString stringWithFormat:@"%d sec",countResendTimer];
    _secondsCountTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(secondsCountTimerShedule) userInfo:nil repeats:YES];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:_userID forKey:kUser_id];
    
    
    [self resendCode:dictionary];
    
}

-(void)sliderValue:(int )timer{
    
    NSLog(@"%d",timer);
    _timeSlider.value = (float)timer;
}

- (IBAction)backButton_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)cancelButton_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginButton_clicked:(id)sender {
    
    
    if(!(_emailTextField.text.length > 0)){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please enter OTP" block:^(int index) {
            [_emailTextField becomeFirstResponder];
        }];
    }
    else{
        
        
        NSArray *array = self.navigationController.viewControllers;
        
        for (UIViewController *controller in array) {
            if ([controller isKindOfClass:[UNKSignInViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
                
            }
        }
    }
}

- (IBAction)verifyButton_clicked:(id)sender {
    
    if ([self validatePassword]) {
        
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        [dictionary setValue:_emailTextField.text forKey:KOTP];
        if ([[loginDictionary valueForKey:Kid] length]>0 && ![[loginDictionary valueForKey:Kid] isKindOfClass:[NSNull class]]) {
            [dictionary setValue:[loginDictionary valueForKey:Kid] forKey:kUser_id];
        }
        else{
            [dictionary setValue:[loginDictionary valueForKey:Kuserid] forKey:kUser_id];
        }
        
        [self verifyMobileNumber:dictionary];
    }
    
}


/****************************
 * Function Name : - validateUserProfile
 * Create on : - 6 march 2017
 * Developed By : - Ramniwas Patidar
 * Description : - This Function is used to validate user mobile number
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
- (BOOL)validatePassword{
    
    if(!(_emailTextField.text.length > 0)){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter OTP" block:^(int index) {
            [_emailTextField becomeFirstResponder];
        }];
        return false;
    }
    
    else  if(!self.isAgreeTerms){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please agree Terms & Conditions" block:^(int index) {
            
        }];
        return false;
    }
    return true;
}


/****************************
 * Function Name : - checkMarkButton_Clicked
 * Create on : -  06 march 2017
 * Developed By : - Ramniwas
 * Description : - This funtiion are used fo check term & condition check mark
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

- (IBAction)checkMarkButton_clicked:(id)sender {
    
    self.isAgreeTerms = !self.isAgreeTerms;
    UIButton *button = (UIButton *)sender;
    
    //Check Wether button state is selected or unselcted and set the desire image
    if (self.isAgreeTerms == YES) {
        [button setBackgroundImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
    }
    else{
        [button setBackgroundImage:[UIImage imageNamed:@"UnCheck"] forState:UIControlStateNormal];
    }
}

- (IBAction)editMobileNumberButton_clicked:(id)sender {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @""
                                                                              message: @"Please enter your mobile number to receive an OTP"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"+91";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
        _phoneNumberTextField = textField;
        _phoneNumberTextField.text = [loginDictionary valueForKey:kMobileNumber];
        _phoneNumberTextField.delegate = self;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"SAVE" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        NSLog(@"%@",namefield.text);
        
        
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        [dictionary setValue:[self getMobileNumber:_phoneNumberTextField.text] forKey:@"mobile_number"];
        [dictionary setValue:[loginDictionary valueForKey:Kuserid] forKey:Kuserid];
        if([self validateMobileNumber])
        {
            [self editMobileNumber:dictionary];
        }
        
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)verifyForgotPasswordButton_clicked:(id)sender {
    
    if ([Utility replaceNULL:_emailTextField.text value:@""].length>0) {
        
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        [dictionary setValue:_emailTextField.text forKey:KOTP];
        [dictionary setValue:_userID forKey:kUser_id];
        
        [self verifyMobileNumber:dictionary];
    }
    else
    {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter OTP" block:^(int index) {
            [_emailTextField becomeFirstResponder];
        }];
    }
    
}


/****************************
 * Function Name : - secondsCountTimerShedule
 * Create on : -  03 march 2017
 * Developed By : - Ramniwas
 * Description : - Thid funtion are used for timer second count
 
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)secondsCountTimerShedule{
    
    countResendTimer--;
    _sliderCount = _sliderCount+1;
    
    [self sliderValue:_sliderCount];
    
    _resendCodeButton.enabled = NO;
    _resendCodeButton.alpha = 0.4;
    
    if (countResendTimer==0) {
        _resendCodeButton.enabled = YES;
        _resendCodeButton.alpha = 1.0;
        
        [_secondsCountTimer invalidate];
        _secondsCountTimer=nil;
    }
    _timerLabel.text  = [NSString stringWithFormat:@"%d sec",countResendTimer];
    
    
}


/****************************
 * Function Name : - getMobileNumber
 * Create on : - 16 march 2017
 * Developed By : - Ramniwas
 * Description : - This function are used for remove phone number formate
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(NSString *)getMobileNumber:(NSString *)string{
    
    NSString *strQueryString = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@")" withString:@""];
    strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@" " withString:@""];
    strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    return strQueryString;
}

#pragma mark - Webview delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        [self performSegueWithIdentifier:kwebviewSegueIdentifier sender:nil];
        
        
        return NO;
    }
    return YES;
}


#pragma mark - APIS
/****************************
 * Function Name : - APIs call
 * Create on : -  06 march 2017
 * Developed By : - Ramniwas
 * Description : - This funtiion are used for send and recieved data
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)resendCode:(NSMutableDictionary*)dictionary{
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"otp-resend-student.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    
                    _emailTextField.text = @"";
                    [Utility showAlertViewControllerIn:self title:@"" message:@"OTP sent" block:^(int index){
                        
                    }];
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                        }];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
            
        }
        
        
    }];
    
}


-(void)verifyMobileNumber:(NSMutableDictionary*)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"otp-verify-login-student.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    
                    _emailTextField.text = @"";
                    
                    if ([self.incomingViewType isEqualToString:kRegister])
                    {
                        /*[Utility showAlertViewControllerIn:self title:@"" message:[dictionary valueForKey:KMessages] block:^(int index){
                         
                         
                         }];*/
                        NSMutableDictionary *_loginInfo = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
                        [_loginInfo setValue:@"true" forKey:@"verifyOtp"];
                        [kUserDefault setValue:[Utility archiveData:_loginInfo] forKey:kLoginInfo];
                        [self performSegueWithIdentifier:kWelcomeSegueIdentifier sender:nil];
                        
                    }
                    else
                    {
                        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                        
                        UNKChangePasswordViewController *changePasswordViewController = [storyBoard instantiateViewControllerWithIdentifier:@"UNKChangePasswordViewController"];
                        changePasswordViewController.incomingViewType =KForgotPassword;
                        changePasswordViewController._userId =_userID;
                        [self.navigationController pushViewController:changePasswordViewController animated:YES];
                        
                    }
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                        }];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
            
        }
        
        
    }];
    
}

-(void)editMobileNumber:(NSMutableDictionary*)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"update-phone-number.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    _mobileNumberLabel.text = _phoneNumberTextField.text;
                    _phoneNumberTextField.text = @"";
                    [loginDictionary setValue:_mobileNumberLabel.text forKey:kMobileNumber];
                    [Utility showAlertViewControllerIn:self title:@"Edit Mobile Number" message:[dictionary valueForKey:kAPIMessage] block:^(int index){
                        
                    }];
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                        }];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
            
        }
        
        
    }];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kwebviewSegueIdentifier]) {
        UNKWebViewController *_wevView = segue.destinationViewController;
        _wevView.webviewMode = UNKTermAndConditions;
    }
}

-(void)setMobilevalidationString
{
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",@"102"];
    
    NSMutableArray *countryList =[[UtilityPlist getData:kCountries] valueForKey:kCountries];
    NSLog(@"%@",countryList);
    
    NSArray *lastEducationCountryFilterArray = [countryList filteredArrayUsingPredicate:predicate];
    
    if (lastEducationCountryFilterArray.count>0) {
        
        NSMutableDictionary *countryDict = [lastEducationCountryFilterArray objectAtIndex:0];
        
        _minimum_value = [countryDict valueForKey:kminimum_value];
        maximum_value = [countryDict valueForKey:kmaximum_value];
    }
    
    
}
- (BOOL)validateMobileNumber{
    
    if(!(_phoneNumberTextField.text.length > 0)){
        [Utility showAlertViewControllerIn:self title:@"" message:@"Enter Phone No" block:^(int index) {
            
        }];
        return false;
    }
    else if([Utility removeZero:_phoneNumberTextField.text].length < [_minimum_value integerValue] || [Utility removeZero:_phoneNumberTextField.text].length > [maximum_value integerValue]){
        
        NSString *message = [NSString stringWithFormat:@"Enter valid mobile no."];
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:message block:^(int index) {
            
        }];
        return false;
    }
    
    return YES;
}

@end
