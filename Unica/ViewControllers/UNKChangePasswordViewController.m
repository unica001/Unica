//
//  UNKChangePasswordViewController.m
//  Unica
//
//  Created by vineet patidar on 07/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKChangePasswordViewController.h"
#import "ChangePasswordCell.h"

@interface UNKChangePasswordViewController (){
    NSString *passwordRequired;
    NSString *userLoginType;
}

@end

@implementation UNKChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _oldPassSecurity = YES;
    _newPassSecurity = YES;
    _confirmPassSecurity = YES;
    
    
    changePasswordTable.layer.cornerRadius = 10.0;
    [changePasswordTable.layer setMasksToBounds:YES];
    
    if([self.incomingViewType isEqualToString:KForgotPassword])
    {
        passwordRequired=@"notRequired";
        _headingTitleLabel.text =@"Update Password";
        _subHeadingLabel.hidden =true;
        self.navigationItem.title = @"Update Password";
    }
    else
    {
        _headingTitleLabel.text =@"Change Password";
        self.navigationItem.title = @"Change Password";
    }
    
    [submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];

    
    
    // Do any additional setup after loading the view.
    
//    NSString *loginType = [kUserDefault valueForKey:kLoginInfo];
//    
//    if (![loginType isKindOfClass:[NSNull class]] && [loginType isEqualToString:kSocial]) {
//        passwordRequired = @"notRequired";
//        userLoginType = @"FB";
//        
//    }
//    else{
//        
//        passwordRequired = @"required";
//        userLoginType = @"normal";
//        
//    }
    
    [self setupInitialLayout];
}



/****************************
 * Function Name : - setUPInitialLayout
 * Create on : - 21th Dec 2016
 * Developed By : - Jitender Sharma
 * Description : - In this function initilization all the basic control before screen load
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

-(void)setupInitialLayout{
    
    
    self.navigationItem.hidesBackButton = YES;
    
    //Intialize Common Options for TextField
    CGRect frame = CGRectMake(20, 10, kiPhoneWidth-60, 30);
    NSMutableDictionary *optionDictionary = [NSMutableDictionary dictionary];
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:[NSNumber numberWithInt:UIReturnKeyNext] forKey:kTextFeildOptionReturnType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocorrectionTypeNo] forKey:kTextFeildOptionAutocorrectionType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocapitalizationTypeNone] forKey:kTextFeildOptionAutocapitalizationType];
    
    
    //Setup  Current Password Field
    [optionDictionary setValue:@"Enter old password" forKey:kTextFeildOptionPlaceholder];
    _currentPasswordText = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    _currentPasswordText.borderStyle = UITextBorderStyleRoundedRect;
    _currentPasswordText.textColor = [UIColor blackColor];

    
    //Setup  New Password Field
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeEmailAddress] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:@"Enter new password" forKey:kTextFeildOptionPlaceholder];
    _newPasswordText = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    _newPasswordText.borderStyle = UITextBorderStyleRoundedRect;
    _newPasswordText.textColor = [UIColor blackColor];

    
    
    //Setup  Confirm Password Field
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeEmailAddress] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:@"Confirm new password" forKey:kTextFeildOptionPlaceholder];
    _confirmNewPasswordText = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    _confirmNewPasswordText.returnKeyType = UIReturnKeyDone;
    _confirmNewPasswordText.borderStyle = UITextBorderStyleRoundedRect;
    _confirmNewPasswordText.textColor = [UIColor blackColor];

     if([self.incomingViewType isEqualToString:KForgotPassword])
     {
         _newPasswordText.placeholder =@"Enter new password";
         _confirmNewPasswordText.placeholder= @"Confirm new password";
     }
    
}


#pragma mark - Table view delegate methods



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([passwordRequired isEqualToString:@"notRequired"]) {
        
        return 2;
    }
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier  =@"changePasswordCell";
    
    ChangePasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ChangePasswordCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if ([passwordRequired isEqualToString:@"notRequired"]) {
        
        if (indexPath.row == currentPassword) {
            [cell.textField removeFromSuperview];
            cell.textField = _newPasswordText;
            cell.textField.secureTextEntry = true;
            [cell.contentView addSubview:cell.textField];
            
        }
        else  if (indexPath.row == newPassword) {
            [cell.textField removeFromSuperview];
            cell.textField = _confirmNewPasswordText;
            cell.textField.secureTextEntry = true;
            [cell.contentView addSubview:cell.textField];
            
        }
    }
    else{
        
        if (indexPath.row == currentPassword) {
            [cell.textField removeFromSuperview];
            cell.textField = _currentPasswordText;
            cell.textField.secureTextEntry = true;
            [cell.contentView addSubview:cell.textField];
            
        }
        else  if (indexPath.row == newPassword) {
            [cell.textField removeFromSuperview];
            cell.textField = _newPasswordText;
            cell.textField.secureTextEntry = true;
            [cell.contentView addSubview:cell.textField];
            
        }
        else  if (indexPath.row == confirmNewPassword) {
            [cell.textField removeFromSuperview];
            cell.textField = _confirmNewPasswordText;
            cell.textField.secureTextEntry = true;
            [cell.contentView addSubview:cell.textField];
            
        }
    }
    
    
    return  cell;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


#pragma mark -
#pragma TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if (textField == _currentPasswordText) {
        [_newPasswordText becomeFirstResponder];
    }
    else if (textField == _newPasswordText) {
        [_confirmNewPasswordText becomeFirstResponder];
    }
    
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/****************************
 * Function Name : - validateUserProfile
 * Create on : - 1 Feb 2017
 * Developed By : -  Ramniwas
 * Description : - This Function is used to validate  password  fields
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
- (BOOL)validatePassword{
    
    
    
    if(![Utility validateField:_currentPasswordText.text] && ![passwordRequired isEqualToString:@"notRequired"]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter old password" block:^(int index) {
            
        }];
        return false;
    }
    else if(![Utility validateField:_newPasswordText.text]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter new password" block:^(int index) {
            
        }];
        return false;
    }
    
    else if(![Utility isValidPassword:_newPasswordText.text]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"password length is too low its should be greater than six" block:^(int index) {
            
        }];        return false;
    }
    
    else if(![Utility validateField:_confirmNewPasswordText.text]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Confirm your password" block:^(int index) {
            
        }];
        return false;
    }
    
    else if(![Utility isValidPassword:_confirmNewPasswordText.text]&& ![passwordRequired isEqualToString:@"notRequired"]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"password length is too low its should be greater than six" block:^(int index) {
            
        }];
        return false;
    }
   
    else if(![_newPasswordText.text isEqualToString:_confirmNewPasswordText.text]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Password not matched" block:^(int index) {
            
        }];
        return false;
    }
    
    
    return true;
}

-(BOOL)validateForgotPassword
{
   if(![Utility validateField:_newPasswordText.text]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Enter new password" block:^(int index) {
            
        }];
        return false;
    }
   else if(![Utility isValidPassword:_newPasswordText.text]){
       [Utility showAlertViewControllerIn:self title:kUNKError message:@"password length is too low its should be greater than six" block:^(int index) {
           
       }];        return false;
   }
    else if(![Utility validateField:_confirmNewPasswordText.text]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Confirm your password" block:^(int index) {
            
        }];
        return false;
    }
  
    else if(![_newPasswordText.text isEqualToString:_confirmNewPasswordText.text]){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Password not matched" block:^(int index) {
            
        }];
        return false;
    }
    
    
    return true;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



- (IBAction)changePasswordButton_Clicked:(id)sender {
    
    if([self.incomingViewType isEqualToString:KForgotPassword])
    {
        if ([self validateForgotPassword]) {
            
            [_currentPasswordText resignFirstResponder];
            [_newPasswordText resignFirstResponder];
            [_confirmNewPasswordText resignFirstResponder];
            
            [self changeForgotPassword];
        }
    }
    else
    {
        if ([self validatePassword]) {
            
            [_currentPasswordText resignFirstResponder];
            [_newPasswordText resignFirstResponder];
            [_confirmNewPasswordText resignFirstResponder];
            
            [self changePassword];
        }
    }
    
    
}


-(void)changePassword{
    
    NSMutableDictionary *loginDictioanry = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setValue:_currentPasswordText.text forKey:kOldPassword];
    [dictionary setValue:_newPasswordText.text forKey:
     kNewPassword];
   
    
    
    if (![[loginDictioanry valueForKey:Kid] isKindOfClass:[NSNull class]] && [[loginDictioanry valueForKey:Kid] length]>0 ) {
        
        [dictionary setValue:[loginDictioanry valueForKey:Kid] forKey:Kuserid];
    }
    else {
        [dictionary setValue:[loginDictioanry valueForKey:Kuserid] forKey:Kuserid];
    }
    
    
   // [dictionary setValue:userLoginType forKey:kLoginType];
    
    NSString *url;
    
    url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"change-password.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [Utility showAlertViewControllerIn:self title:@"Change Password" message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }];
                    
                    
                    
                }
                else{
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                        }];
                    });
                    
                    
                }
                
                
            });
        }
        else{
            //Remove when API issue is fixed
            
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

-(void)changeForgotPassword{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setValue:_newPasswordText.text forKey:
     kNewPassword];
    [dictionary setValue:self._userId forKey:Kuserid];
    
      NSString *url;
    
    url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"update-forgot-password.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [Utility showAlertViewControllerIn:self title:@"" message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                        
                      //  [self.navigationController popToRootViewControllerAnimated:YES];
                        
                        NSArray *controller = self.navigationController.viewControllers;
                        
                        if (controller.count>0) {
                            for (UIViewController *view in controller) {
                                if ([view isKindOfClass:[UNKSignInViewController class]]) {
                                    
                                    [self.navigationController popToViewController:view animated:YES];
                                }
                            }
                        }
                        
                    }];
                    
                    
                    
                }
                else{
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                        }];
                    });
                    
                    
                }
                
                
            });
        }
        else{
            //Remove when API issue is fixed
            
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

- (IBAction)backButton_Clicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
